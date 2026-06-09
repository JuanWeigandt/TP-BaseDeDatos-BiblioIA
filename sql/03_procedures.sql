USE BiblioIA;

DELIMITER //

-- ======================================================================
-- 1. sp_registrar_prestamo
-- ======================================================================
DROP PROCEDURE IF EXISTS sp_registrar_prestamo //
CREATE PROCEDURE sp_registrar_prestamo(
    IN p_id_socio INT,
    IN p_id_ejemplar INT,
    IN p_dias_prestamo INT
)
BEGIN
    DECLARE v_sanciones INT DEFAULT 0;
    DECLARE v_prestamos_activos INT DEFAULT 0;
    DECLARE v_estado_ejemplar VARCHAR(20);
    DECLARE v_existe_socio INT;
    DECLARE v_existe_ejemplar INT;
    DECLARE v_estado_socio VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Verificar que el socio existe
    SELECT COUNT(*) INTO v_existe_socio FROM SOCIO WHERE id_socio = p_id_socio;
    IF v_existe_socio = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El socio especificado no existe.';
    END IF;

    -- CORRECCIÓN: verificar que el socio esté Activo (no Suspendido ni Baja)
    SELECT estado INTO v_estado_socio FROM SOCIO WHERE id_socio = p_id_socio;
    IF v_estado_socio != 'Activo' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El socio no está activo (Suspendido o Baja).';
    END IF;

    -- Verificar que el ejemplar existe
    SELECT COUNT(*) INTO v_existe_ejemplar FROM EJEMPLAR WHERE id_ejemplar = p_id_ejemplar;
    IF v_existe_ejemplar = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El ejemplar especificado no existe.';
    END IF;

    START TRANSACTION;

    -- Validar sanciones activas
    SELECT COUNT(*) INTO v_sanciones
    FROM SANCION
    WHERE id_socio = p_id_socio AND fecha_fin >= CURRENT_DATE;

    IF v_sanciones > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El socio tiene sanciones activas y no puede pedir libros.';
    END IF;

    -- Validar límite de 3 préstamos activos
    SELECT COUNT(*) INTO v_prestamos_activos
    FROM PRESTAMO
    WHERE id_socio = p_id_socio AND estado = 'Activo';

    IF v_prestamos_activos >= 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El socio alcanzó el límite de 3 préstamos activos.';
    END IF;

    -- Validar disponibilidad del ejemplar con bloqueo
    SELECT estado_fisico INTO v_estado_ejemplar
    FROM EJEMPLAR
    WHERE id_ejemplar = p_id_ejemplar FOR UPDATE;

    IF v_estado_ejemplar != 'Disponible' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El ejemplar no está disponible actualmente.';
    END IF;

    -- Registrar el préstamo
    INSERT INTO PRESTAMO (id_socio, id_ejemplar, fecha_prestamo, fecha_vencimiento, estado)
    VALUES (p_id_socio, p_id_ejemplar, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL p_dias_prestamo DAY), 'Activo');

    UPDATE EJEMPLAR
    SET estado_fisico = 'Prestado'
    WHERE id_ejemplar = p_id_ejemplar;

    COMMIT;
END //

-- ======================================================================
-- 2. sp_generar_sancion
-- ======================================================================
DROP PROCEDURE IF EXISTS sp_generar_sancion //
CREATE PROCEDURE sp_generar_sancion(
    IN p_id_socio INT,
    IN p_tipo VARCHAR(50),
    IN p_dias_mora INT,
    IN p_motivo TEXT
)
BEGIN
    DECLARE v_dias_castigo INT;

    -- 2 días de sanción por cada día de mora
    SET v_dias_castigo = p_dias_mora * 2;

    INSERT INTO SANCION (id_socio, tipo, fecha_inicio, fecha_fin, motivo)
    VALUES (p_id_socio, p_tipo, CURRENT_DATE, DATE_ADD(CURRENT_DATE, INTERVAL v_dias_castigo DAY), p_motivo);

    -- El trigger trg_estado_socio suspende al socio automáticamente
    -- al insertar en SANCION. No es necesario hacerlo acá.
END //

-- ======================================================================
-- 3. sp_registrar_devolucion
-- ======================================================================
DROP PROCEDURE IF EXISTS sp_registrar_devolucion //
CREATE PROCEDURE sp_registrar_devolucion(
    IN p_id_prestamo INT,
    IN p_estado_final_ejemplar VARCHAR(20)
)
BEGIN
    DECLARE v_id_socio INT;
    DECLARE v_id_ejemplar INT;
    DECLARE v_fecha_vencimiento DATE;
    DECLARE v_estado_prestamo VARCHAR(20);
    DECLARE v_dias_mora INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT id_socio, id_ejemplar, fecha_vencimiento, estado
    INTO v_id_socio, v_id_ejemplar, v_fecha_vencimiento, v_estado_prestamo
    FROM PRESTAMO
    WHERE id_prestamo = p_id_prestamo FOR UPDATE;

    IF v_estado_prestamo = 'Devuelto' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El préstamo ya se encuentra devuelto.';
    END IF;

    -- Actualizar estado físico del ejemplar
    UPDATE EJEMPLAR
    SET estado_fisico = p_estado_final_ejemplar
    WHERE id_ejemplar = v_id_ejemplar;

    -- Cerrar el préstamo (dispara trg_actualizar_stock automáticamente)
    UPDATE PRESTAMO
    SET fecha_devolucion = CURRENT_DATE, estado = 'Devuelto'
    WHERE id_prestamo = p_id_prestamo;

    -- Sanción por mora si corresponde
    IF CURRENT_DATE > v_fecha_vencimiento THEN
        SET v_dias_mora = DATEDIFF(CURRENT_DATE, v_fecha_vencimiento);
        CALL sp_generar_sancion(
            v_id_socio,
            'Mora',
            v_dias_mora,
            CONCAT('Devolución tardía. Préstamo Nro: ', p_id_prestamo, '. Días de mora: ', v_dias_mora)
        );
    END IF;

    -- Sanción adicional si el libro volvió dañado
    IF p_estado_final_ejemplar = 'Dañado' THEN
        CALL sp_generar_sancion(
            v_id_socio,
            'Daño a Material',
            15,
            CONCAT('Ejemplar devuelto dañado. Préstamo Nro: ', p_id_prestamo)
        );
    END IF;

    COMMIT;
END //

-- ======================================================================
-- 4. sp_renovar_prestamo (BONUS)
-- ======================================================================
DROP PROCEDURE IF EXISTS sp_renovar_prestamo //
CREATE PROCEDURE sp_renovar_prestamo(
    IN p_id_prestamo INT,
    IN p_dias_adicionales INT
)
BEGIN
    DECLARE v_id_socio INT;
    DECLARE v_estado_prestamo VARCHAR(20);
    DECLARE v_fecha_vencimiento DATE;
    DECLARE v_sanciones_activas INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT id_socio, estado, fecha_vencimiento
    INTO v_id_socio, v_estado_prestamo, v_fecha_vencimiento
    FROM PRESTAMO
    WHERE id_prestamo = p_id_prestamo FOR UPDATE;

    IF v_estado_prestamo != 'Activo' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Solo se pueden renovar préstamos activos.';
    ELSEIF CURRENT_DATE > v_fecha_vencimiento THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El préstamo ya está VENCIDO. No se puede renovar.';
    END IF;

    SELECT COUNT(*) INTO v_sanciones_activas
    FROM SANCION
    WHERE id_socio = v_id_socio AND fecha_fin >= CURRENT_DATE;

    IF v_sanciones_activas > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El socio tiene sanciones activas, no se puede renovar.';
    END IF;

    UPDATE PRESTAMO
    SET fecha_vencimiento = DATE_ADD(fecha_vencimiento, INTERVAL p_dias_adicionales DAY)
    WHERE id_prestamo = p_id_prestamo;

    COMMIT;
END //

DELIMITER ;
