USE BiblioIA;

DELIMITER //

-- ======================================================================
-- 1. trg_actualizar_stock
-- Recalcula stock_disponible en LIBRO según el estado del préstamo.
-- ======================================================================

DROP TRIGGER IF EXISTS trg_actualizar_stock_ins //
CREATE TRIGGER trg_actualizar_stock_ins
AFTER INSERT ON PRESTAMO
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Activo' THEN
        UPDATE LIBRO L
        JOIN EJEMPLAR E ON L.isbn = E.isbn_libro
        SET L.stock_disponible = L.stock_disponible - 1
        WHERE E.id_ejemplar = NEW.id_ejemplar;
    END IF;
END //

DROP TRIGGER IF EXISTS trg_actualizar_stock_upd //
CREATE TRIGGER trg_actualizar_stock_upd
AFTER UPDATE ON PRESTAMO
FOR EACH ROW
BEGIN
    -- Caso A: el préstamo pasa a Devuelto
    IF OLD.estado != 'Devuelto' AND NEW.estado = 'Devuelto' THEN
        -- Solo recupera stock si el ejemplar quedó Disponible (no Dañado/Baja)
        IF (SELECT estado_fisico FROM EJEMPLAR WHERE id_ejemplar = NEW.id_ejemplar) = 'Disponible' THEN
            UPDATE LIBRO L
            JOIN EJEMPLAR E ON L.isbn = E.isbn_libro
            SET L.stock_disponible = L.stock_disponible + 1
            WHERE E.id_ejemplar = NEW.id_ejemplar;
        END IF;

    -- Caso B: el préstamo pasa a Activo desde otro estado
    ELSEIF OLD.estado != 'Activo' AND NEW.estado = 'Activo' THEN
        UPDATE LIBRO L
        JOIN EJEMPLAR E ON L.isbn = E.isbn_libro
        SET L.stock_disponible = L.stock_disponible - 1
        WHERE E.id_ejemplar = NEW.id_ejemplar;
    END IF;
END //

-- ======================================================================
-- 2. trg_estado_socio
-- Suspende al socio automáticamente cuando se le crea una sanción.
-- Reactiva al socio si ya no tiene sanciones vigentes.
-- ======================================================================

DROP TRIGGER IF EXISTS trg_estado_socio_ins //
CREATE TRIGGER trg_estado_socio_ins
AFTER INSERT ON SANCION
FOR EACH ROW
BEGIN
    UPDATE SOCIO
    SET estado = 'Suspendido'
    WHERE id_socio = NEW.id_socio;
END //

-- CORRECCIÓN: la tabla SANCION no tiene columna 'estado'.
-- Se determina si una sanción está activa por fecha_fin >= CURDATE().
DROP TRIGGER IF EXISTS trg_estado_socio_upd //
CREATE TRIGGER trg_estado_socio_upd
AFTER UPDATE ON SANCION
FOR EACH ROW
BEGIN
    -- Si la sanción se actualizó y ahora su fecha_fin ya pasó,
    -- verificar si el socio no tiene otras sanciones aún vigentes.
    IF NEW.fecha_fin < CURDATE() THEN
        IF (
            SELECT COUNT(*) FROM SANCION
            WHERE id_socio = NEW.id_socio
              AND fecha_fin >= CURDATE()
        ) = 0 THEN
            UPDATE SOCIO
            SET estado = 'Activo'
            WHERE id_socio = NEW.id_socio;
        END IF;
    END IF;
END //

-- ======================================================================
-- 3. trg_audit_prestamo
-- Registra cada INSERT, UPDATE y DELETE en AUDITORIA_PRESTAMOS.
-- ======================================================================

DROP TRIGGER IF EXISTS trg_audit_prestamo_ins //
CREATE TRIGGER trg_audit_prestamo_ins
AFTER INSERT ON PRESTAMO
FOR EACH ROW
BEGIN
    INSERT INTO AUDITORIA_PRESTAMOS (id_prestamo, accion, usuario_bd, detalles)
    VALUES (
        NEW.id_prestamo,
        'INSERT',
        CURRENT_USER(),
        CONCAT('Préstamo creado. Socio: ', NEW.id_socio, ', Ejemplar: ', NEW.id_ejemplar)
    );
END //

DROP TRIGGER IF EXISTS trg_audit_prestamo_upd //
CREATE TRIGGER trg_audit_prestamo_upd
AFTER UPDATE ON PRESTAMO
FOR EACH ROW
BEGIN
    INSERT INTO AUDITORIA_PRESTAMOS (id_prestamo, accion, usuario_bd, detalles)
    VALUES (
        NEW.id_prestamo,
        'UPDATE',
        CURRENT_USER(),
        CONCAT('Cambio de estado: ', OLD.estado, ' -> ', NEW.estado)
    );
END //

DROP TRIGGER IF EXISTS trg_audit_prestamo_del //
CREATE TRIGGER trg_audit_prestamo_del
AFTER DELETE ON PRESTAMO
FOR EACH ROW
BEGIN
    INSERT INTO AUDITORIA_PRESTAMOS (id_prestamo, accion, usuario_bd, detalles)
    VALUES (
        OLD.id_prestamo,
        'DELETE',
        CURRENT_USER(),
        CONCAT('Préstamo eliminado. Socio: ', OLD.id_socio)
    );
END //

DELIMITER ;
