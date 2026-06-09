USE BiblioIA;

-- ======================================================================
-- 1. vista_catalogo_libros
-- Catálogo completo con autores y géneros agrupados.
-- ======================================================================
CREATE OR REPLACE VIEW vista_catalogo_libros AS
SELECT
    l.isbn,
    l.titulo,
    l.anio_publicacion,
    l.stock_total,
    l.stock_disponible,
    GROUP_CONCAT(DISTINCT CONCAT(a.nombre, ' ', a.apellido) ORDER BY a.apellido SEPARATOR ', ') AS autores,
    GROUP_CONCAT(DISTINCT g.nombre ORDER BY g.nombre SEPARATOR ', ') AS generos
FROM LIBRO l
LEFT JOIN LIBRO_AUTOR la ON l.isbn = la.isbn_libro
LEFT JOIN AUTOR a        ON la.id_autor = a.id_autor
LEFT JOIN LIBRO_GENERO lg ON l.isbn = lg.isbn_libro
LEFT JOIN GENERO g       ON lg.id_genero = g.id_genero
GROUP BY l.isbn, l.titulo, l.anio_publicacion, l.stock_total, l.stock_disponible;

-- ======================================================================
-- 2. vista_prestamos_actuales
-- Préstamos activos y vencidos con días de mora calculados.
-- ======================================================================
CREATE OR REPLACE VIEW vista_prestamos_actuales AS
SELECT
    p.id_prestamo,
    s.dni,
    CONCAT(s.nombre, ' ', s.apellido) AS socio,
    l.titulo AS libro,
    e.nro_ejemplar,
    p.fecha_prestamo,
    p.fecha_vencimiento,
    p.estado,
    GREATEST(0, DATEDIFF(CURRENT_DATE, p.fecha_vencimiento)) AS dias_mora
FROM PRESTAMO p
JOIN SOCIO    s ON p.id_socio    = s.id_socio
JOIN EJEMPLAR e ON p.id_ejemplar = e.id_ejemplar
JOIN LIBRO    l ON e.isbn_libro  = l.isbn
WHERE p.estado IN ('Activo', 'Vencido');

-- ======================================================================
-- 3. vista_historial_socios
-- Historial completo de préstamos por socio.
-- CORRECCIÓN: el punto y coma estaba antes del ORDER BY, se eliminó.
-- ======================================================================
CREATE OR REPLACE VIEW vista_historial_socios AS
SELECT
    s.id_socio,
    s.dni,
    CONCAT(s.nombre, ' ', s.apellido) AS socio,
    l.isbn,
    l.titulo,
    p.fecha_prestamo,
    p.fecha_devolucion,
    p.estado AS estado_prestamo
FROM SOCIO    s
JOIN PRESTAMO p ON s.id_socio    = p.id_socio
JOIN EJEMPLAR e ON p.id_ejemplar = e.id_ejemplar
JOIN LIBRO    l ON e.isbn_libro  = l.isbn
ORDER BY s.id_socio, p.fecha_prestamo DESC;

-- ======================================================================
-- 4. vista_ranking_libros
-- Libros ordenados por cantidad de veces prestados.
-- Útil para el agente IA (pregunta "5 libros más prestados").
-- ======================================================================
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

-- ======================================================================
-- 5. vista_socios_morosos
-- Socios con préstamos vencidos en este momento.
-- Útil para el agente IA.
-- ======================================================================
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
WHERE p.estado = 'Vencido'
GROUP BY s.id_socio, s.dni, s.nombre, s.apellido, s.email;

