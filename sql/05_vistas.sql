USE BiblioIA;


-- 1. vista_catalogo_libros 
-- Catálogo completo con autores y géneros agrupados.

CREATE OR REPLACE VIEW vista_catalogo_libros AS
SELECT
    l.isbn,
    l.titulo,
    l.anio_publicacion,
    l.stock_total,
    l.stock_disponible,
    -- Concatenamos Nombre, Apellido y (Nacionalidad)
    GROUP_CONCAT(DISTINCT CONCAT(a.nombre, ' ', a.apellido, ' (', n.nombre, ')') ORDER BY a.apellido SEPARATOR ', ') AS autores,
    GROUP_CONCAT(DISTINCT g.nombre ORDER BY g.nombre SEPARATOR ', ') AS generos
FROM LIBRO l
LEFT JOIN LIBRO_AUTOR la  ON l.isbn = la.isbn_libro
LEFT JOIN AUTOR a         ON la.id_autor = a.id_autor
LEFT JOIN NACIONALIDAD n  ON a.id_nacionalidad = n.id_nacionalidad
LEFT JOIN LIBRO_GENERO lg ON l.isbn = lg.isbn_libro
LEFT JOIN GENERO g        ON lg.id_genero = g.id_genero
GROUP BY l.isbn, l.titulo, l.anio_publicacion, l.stock_total, l.stock_disponible;


-- 2. vista_prestamos_actuales 
-- Préstamos activos y vencidos con días de mora calculados.

CREATE OR REPLACE VIEW vista_prestamos_actuales AS
SELECT
    p.id_prestamo,
    s.dni,
    CONCAT(s.nombre, ' ', s.apellido) AS socio,
    l.titulo AS libro,
    e.nro_ejemplar,
    p.fecha_prestamo,
    p.fecha_vencimiento,
    ep.nombre AS estado_prestamo, 
    GREATEST(0, DATEDIFF(CURRENT_DATE, p.fecha_vencimiento)) AS dias_mora
FROM PRESTAMO p
JOIN SOCIO    s ON p.id_socio    = s.id_socio
JOIN EJEMPLAR e ON p.id_ejemplar = e.id_ejemplar
JOIN LIBRO    l ON e.isbn_libro  = l.isbn
JOIN ESTADO_PRESTAMO ep ON p.id_estado_prestamo = ep.id_estado_prestamo
WHERE p.id_estado_prestamo IN (1, 3); -- 1 = 'Activo', 3 = 'Vencido'


-- 3. vista_historial_socios 
-- Historial completo de préstamos por socio.

CREATE OR REPLACE VIEW vista_historial_socios AS
SELECT
    s.id_socio,
    s.dni,
    CONCAT(s.nombre, ' ', s.apellido) AS socio,
    l.isbn,
    l.titulo,
    p.fecha_prestamo,
    p.fecha_devolucion,
    ep.nombre AS estado_prestamo 
FROM SOCIO    s
JOIN PRESTAMO p ON s.id_socio    = p.id_socio
JOIN EJEMPLAR e ON p.id_ejemplar = e.id_ejemplar
JOIN LIBRO    l ON e.isbn_libro  = l.isbn
JOIN ESTADO_PRESTAMO ep ON p.id_estado_prestamo = ep.id_estado_prestamo
ORDER BY s.id_socio, p.fecha_prestamo DESC;


-- 4. vista_ranking_libros
-- Libros ordenados por cantidad de veces prestados.

CREATE OR REPLACE VIEW vista_ranking_libros AS
SELECT
    l.isbn,
    l.titulo,
    GROUP_CONCAT(DISTINCT CONCAT(a.nombre, ' ', a.apellido) SEPARATOR ', ') AS autores,
    COUNT(p.id_prestamo) AS total_prestamos,
    l.stock_disponible
FROM LIBRO l
LEFT JOIN LIBRO_AUTOR la ON l.isbn = la.isbn_libro
LEFT JOIN AUTOR a        ON la.id_autor = a.id_autor
LEFT JOIN EJEMPLAR e     ON l.isbn = e.isbn_libro
LEFT JOIN PRESTAMO p     ON e.id_ejemplar = p.id_ejemplar
GROUP BY l.isbn, l.titulo, l.stock_disponible
ORDER BY total_prestamos DESC;


-- 5. vista_socios_morosos 
-- Socios con préstamos vencidos en este momento.
CREATE OR REPLACE VIEW vista_socios_morosos AS
SELECT
    s.id_socio,
    s.dni,
    CONCAT(s.nombre, ' ', s.apellido) AS socio,
    s.email,
    COUNT(p.id_prestamo) AS prestamos_vencidos,
    MAX(DATEDIFF(CURRENT_DATE, p.fecha_vencimiento)) AS max_dias_mora
FROM SOCIO    s
JOIN PRESTAMO p ON s.id_socio = p.id_socio
WHERE p.id_estado_prestamo = 3 -- 3 = 'Vencido'
GROUP BY s.id_socio, s.dni, s.nombre, s.apellido, s.email;


-- 6. vista_socios_activos 

CREATE OR REPLACE VIEW vista_socios_activos AS
SELECT
    s.id_socio,
    s.dni,
    CONCAT(s.nombre, ' ', s.apellido) AS socio,
    s.email,
    es.nombre AS estado_cuenta
FROM SOCIO s
JOIN ESTADO_SOCIO es ON s.id_estado_socio = es.id_estado_socio
WHERE es.id_estado_socio = 1; -- 1 = 'Activo'


-- 7. vista_reservas_pendientes 

CREATE OR REPLACE VIEW vista_reservas_pendientes AS
SELECT 
    r.id_reserva,
    CONCAT(s.nombre, ' ', s.apellido) AS socio,
    l.titulo AS libro_solicitado,
    r.fecha_solicitud,
    er.nombre AS estado_reserva
FROM RESERVA r
JOIN SOCIO s ON r.id_socio = s.id_socio
JOIN LIBRO l ON r.isbn_libro = l.isbn
JOIN ESTADO_RESERVA er ON r.id_estado_reserva = er.id_estado_reserva
WHERE er.id_estado_reserva IN (1, 2); -- Pendientes y Avisados
