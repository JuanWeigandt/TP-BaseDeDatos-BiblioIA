USE BiblioIA;

-- =============================================
-- 1. GÉNEROS (5)
-- =============================================
INSERT INTO GENERO (nombre, descripcion) VALUES
('Ingeniería de Software', 'Metodologías, procesos unificados y arquitectura'),
('Bases de Datos', 'Diseño, modelado relacional y SQL'),
('Sistemas Operativos', 'Sistemas de archivos, kernel y memoria'),
('Matemática Computacional', 'Programación lineal y optimización'),
('Programación', 'Estructuras de datos dinámicas y algoritmos');

-- =============================================
-- 2. AUTORES (10)
-- =============================================
INSERT INTO AUTOR (nombre, apellido, nacionalidad) VALUES
('Philippe',  'Kruchten',    'Francesa'),
('Ian',       'Sommerville', 'Británica'),
('Ramez',     'Elmasri',     'Egipcia'),
('Shamkant',  'Navathe',     'India'),
('Abraham',   'Silberschatz','Estadounidense'),
('Andrew',    'Tanenbaum',   'Estadounidense'),
('Hamdy',     'Taha',        'Egipcia'),
('Niklaus',   'Wirth',       'Suiza'),
('Roger',     'Pressman',    'Estadounidense'),
('Ivar',      'Jacobson',    'Sueca');

-- =============================================
-- 3. LIBROS (20)
-- stock_disponible se ajusta más abajo según préstamos activos
-- =============================================
INSERT INTO LIBRO (isbn, titulo, anio_publicacion, stock_total, stock_disponible) VALUES
('978-0201123456', 'Arquitectura de Software: Vistas 4+1',          1995, 3, 2),
('978-0133970777', 'Ingeniería de Software: Un Enfoque Práctico',   2014, 5, 2),
('978-0137081073', 'El Proceso Unificado de Desarrollo de Software', 1999, 4, 2),
('978-0133970778', 'Ingeniería de Software',                         2011, 4, 3),
('978-0133970779', 'Sistemas de Bases de Datos: Conceptos',         2015, 6, 4),
('978-0133970780', 'Fundamentos de Bases de Datos',                 2010, 5, 3),
('978-0133970781', 'Sistemas Operativos Modernos',                   2014, 4, 1),
('978-0133970782', 'Conceptos de Sistemas Operativos',              2018, 5, 2),
('978-0133970783', 'Investigación de Operaciones',                   2017, 3, 2),
('978-0133970784', 'Algoritmos y Estructuras de Datos en Pascal',   1985, 2, 1),
('978-0133970785', 'Diseño de Bases de Datos Relacionales',         2008, 4, 2),
('978-0133970786', 'Patrones de Arquitectura de Software',          2001, 3, 2),
('978-0133970787', 'Administración de Linux',                        2020, 2, 1),
('978-0133970788', 'Modelos Lineales con LINDO',                    2005, 3, 2),
('978-0133970789', 'Programación Estructurada',                      1990, 4, 2),
('978-0133970790', 'SQL Avanzado',                                   2019, 5, 3),
('978-0133970791', 'Metodologías Ágiles y Scrum',                   2021, 6, 4),
('978-0133970792', 'Sistemas de Archivos NTFS y VFS',               2012, 2, 1),
('978-0133970793', 'El Método Simplex',                              2003, 3, 2),
('978-0133970794', 'Normalización de Bases de Datos',               2016, 4, 3);

-- =============================================
-- 4. LIBRO_AUTOR (todos los libros con autor)
-- =============================================
INSERT INTO LIBRO_AUTOR (isbn_libro, id_autor) VALUES
('978-0201123456', 1),
('978-0133970777', 9),
('978-0137081073', 10),
('978-0133970778', 2),
('978-0133970779', 3),
('978-0133970779', 4),
('978-0133970780', 5),
('978-0133970781', 6),
('978-0133970782', 5),
('978-0133970783', 7),
('978-0133970784', 8),
('978-0133970785', 3),
('978-0133970786', 9),
('978-0133970787', 6),
('978-0133970788', 7),
('978-0133970789', 8),
('978-0133970790', 5),
('978-0133970791', 2),
('978-0133970792', 6),
('978-0133970793', 7),
('978-0133970794', 3);

-- =============================================
-- 5. LIBRO_GENERO (todos los libros con género)
-- =============================================
INSERT INTO LIBRO_GENERO (isbn_libro, id_genero) VALUES
('978-0201123456', 1),
('978-0133970777', 1),
('978-0137081073', 1),
('978-0133970778', 1),
('978-0133970779', 2),
('978-0133970780', 2),
('978-0133970785', 2),
('978-0133970790', 2),
('978-0133970794', 2),
('978-0133970781', 3),
('978-0133970782', 3),
('978-0133970787', 3),
('978-0133970792', 3),
('978-0133970783', 4),
('978-0133970788', 4),
('978-0133970793', 4),
('978-0133970784', 5),
('978-0133970789', 5),
('978-0133970786', 1),
('978-0133970791', 1);

-- =============================================
-- 6. EJEMPLARES (todos los libros tienen ejemplares)
-- Convención: estado_fisico calculado según préstamos activos abajo
-- =============================================
INSERT INTO EJEMPLAR (isbn_libro, nro_ejemplar, estado_fisico) VALUES
-- isbn 978-0201123456 (stock 3, 1 activo → 1 Prestado, 2 Disponibles)
('978-0201123456', 1, 'Prestado'),
('978-0201123456', 2, 'Disponible'),
('978-0201123456', 3, 'Disponible'),
-- isbn 978-0133970777 (stock 5, 2 activos → 2 Prestados, 3 Disponibles)
('978-0133970777', 1, 'Prestado'),
('978-0133970777', 2, 'Prestado'),
('978-0133970777', 3, 'Prestado'),
('978-0133970777', 4, 'Disponible'),
('978-0133970777', 5, 'Disponible'),
-- isbn 978-0137081073 (stock 4, 2 activos → 2 Prestados, 1 Disponible, 1 Baja)
('978-0137081073', 1, 'Prestado'),
('978-0137081073', 2, 'Prestado'),
('978-0137081073', 3, 'Disponible'),
('978-0137081073', 4, 'Baja'),
-- isbn 978-0133970778 (stock 4, 1 activo → 1 Prestado, 3 Disponibles)
('978-0133970778', 1, 'Prestado'),
('978-0133970778', 2, 'Disponible'),
('978-0133970778', 3, 'Disponible'),
('978-0133970778', 4, 'Disponible'),
-- isbn 978-0133970779 (stock 6, 2 activos → 2 Prestados, 4 Disponibles)
('978-0133970779', 1, 'Prestado'),
('978-0133970779', 2, 'Prestado'),
('978-0133970779', 3, 'Disponible'),
('978-0133970779', 4, 'Disponible'),
('978-0133970779', 5, 'Disponible'),
('978-0133970779', 6, 'Disponible'),
-- isbn 978-0133970780 (stock 5, 2 activos → 2 Prestados, 3 Disponibles)
('978-0133970780', 1, 'Prestado'),
('978-0133970780', 2, 'Prestado'),
('978-0133970780', 3, 'Disponible'),
('978-0133970780', 4, 'Disponible'),
('978-0133970780', 5, 'Disponible'),
-- isbn 978-0133970781 (stock 4, 2 activos → 2 Prestados, 2 Disponibles)
('978-0133970781', 1, 'Prestado'),
('978-0133970781', 2, 'Prestado'),
('978-0133970781', 3, 'Prestado'),
('978-0133970781', 4, 'Disponible'),
-- isbn 978-0133970782 (stock 5, 2 activos → 2 Prestados, 3 Disponibles)
('978-0133970782', 1, 'Prestado'),
('978-0133970782', 2, 'Prestado'),
('978-0133970782', 3, 'Prestado'),
('978-0133970782', 4, 'Disponible'),
('978-0133970782', 5, 'Disponible'),
-- isbn 978-0133970783 (stock 3, 1 activo → 1 Prestado, 2 Disponibles)
('978-0133970783', 1, 'Prestado'),
('978-0133970783', 2, 'Disponible'),
('978-0133970783', 3, 'Disponible'),
-- isbn 978-0133970784 (stock 2, 1 activo → 1 Prestado, 1 Disponible)
('978-0133970784', 1, 'Prestado'),
('978-0133970784', 2, 'Disponible'),
-- isbn 978-0133970785 (stock 4, 1 activo → 1 Prestado, 3 Disponibles)
('978-0133970785', 1, 'Prestado'),
('978-0133970785', 2, 'Prestado'),
('978-0133970785', 3, 'Disponible'),
('978-0133970785', 4, 'Disponible'),
-- isbn 978-0133970786 (stock 3, 1 activo → 1 Prestado, 2 Disponibles)
('978-0133970786', 1, 'Prestado'),
('978-0133970786', 2, 'Disponible'),
('978-0133970786', 3, 'Disponible'),
-- isbn 978-0133970787 (stock 2, 1 activo → 1 Prestado, 1 Disponible)
('978-0133970787', 1, 'Prestado'),
('978-0133970787', 2, 'Disponible'),
-- isbn 978-0133970788 (stock 3, 1 activo → 1 Prestado, 2 Disponibles)
('978-0133970788', 1, 'Prestado'),
('978-0133970788', 2, 'Disponible'),
('978-0133970788', 3, 'Disponible'),
-- isbn 978-0133970789 (stock 4, 1 activo → 1 Prestado, 3 Disponibles)
('978-0133970789', 1, 'Prestado'),
('978-0133970789', 2, 'Prestado'),
('978-0133970789', 3, 'Disponible'),
('978-0133970789', 4, 'Disponible'),
-- isbn 978-0133970790 (stock 5, 2 activos → 2 Prestados, 3 Disponibles)
('978-0133970790', 1, 'Prestado'),
('978-0133970790', 2, 'Prestado'),
('978-0133970790', 3, 'Disponible'),
('978-0133970790', 4, 'Disponible'),
('978-0133970790', 5, 'Disponible'),
-- isbn 978-0133970791 (stock 6, 2 activos → 2 Prestados, 4 Disponibles)
('978-0133970791', 1, 'Prestado'),
('978-0133970791', 2, 'Prestado'),
('978-0133970791', 3, 'Disponible'),
('978-0133970791', 4, 'Disponible'),
('978-0133970791', 5, 'Disponible'),
('978-0133970791', 6, 'Disponible'),
-- isbn 978-0133970792 (stock 2, 1 activo → 1 Prestado, 1 Disponible)
('978-0133970792', 1, 'Prestado'),
('978-0133970792', 2, 'Disponible'),
-- isbn 978-0133970793 (stock 3, 1 activo → 1 Prestado, 2 Disponibles)
('978-0133970793', 1, 'Prestado'),
('978-0133970793', 2, 'Disponible'),
('978-0133970793', 3, 'Disponible'),
-- isbn 978-0133970794 (stock 4, 1 activo → 1 Prestado, 3 Disponibles)
('978-0133970794', 1, 'Prestado'),
('978-0133970794', 2, 'Disponible'),
('978-0133970794', 3, 'Disponible'),
('978-0133970794', 4, 'Disponible');

-- =============================================
-- 7. SOCIOS (30)
-- =============================================
INSERT INTO SOCIO (dni, nombre, apellido, email, fecha_alta, estado) VALUES
('35123456', 'Juan',      'Perez',     'juancraftero777@email.com', '2025-01-10', 'Activo'),
('28456789', 'Maria',     'Gomez',     'maria@email.com',           '2025-02-15', 'Activo'),
('41234567', 'Carlos',    'Lopez',     'carlos@email.com',          '2025-03-20', 'Suspendido'),
('33987654', 'Ana',       'Martinez',  'ana@email.com',             '2025-04-25', 'Activo'),
('29112233', 'Luis',      'Rodriguez', 'luis@email.com',            '2025-05-30', 'Activo'),
('45678901', 'Laura',     'Fernandez', 'laura@email.com',           '2025-06-05', 'Activo'),
('31445566', 'Diego',     'Gonzalez',  'diego@email.com',           '2025-07-10', 'Activo'),
('40123987', 'Sofia',     'Diaz',      'sofia@email.com',           '2025-08-15', 'Activo'),
('27889900', 'Valentin',  'Paccot',    'PP@email.com',              '2025-09-20', 'Baja'),
('38556677', 'Marta',     'Alvarez',   'marta@email.com',           '2025-10-25', 'Activo'),
('42334455', 'Pedro',     'Romero',    'pedro@email.com',           '2026-01-05', 'Activo'),
('36778899', 'Lucia',     'Suarez',    'lucia@email.com',           '2026-01-10', 'Activo'),
('25112244', 'Jorge',     'Torres',    'jorge@email.com',           '2026-01-15', 'Activo'),
('39445522', 'Elena',     'Ruiz',      'elena@email.com',           '2026-01-20', 'Activo'),
('34556611', 'Camilo',    'Tommasi',   'camilo@email.com',          '2026-01-25', 'Activo'),
('43223344', 'Paula',     'Flores',    'paula@email.com',           '2026-02-01', 'Activo'),
('30113355', 'Andres',    'Acosta',    'andres@email.com',          '2026-02-05', 'Activo'),
('26998877', 'Silvia',    'Medina',    'silvia@email.com',          '2026-02-10', 'Suspendido'),
('44556677', 'Martin',    'Rojas',     'martin@email.com',          '2026-02-15', 'Activo'),
('37221100', 'Valentino', 'Gussalli',  'valentino@email.com',       '2026-02-20', 'Activo'),
('32445588', 'Roberto',   'Castro',    'roberto@email.com',         '2026-03-01', 'Activo'),
('24887766', 'Teresa',    'Ortiz',     'teresa@email.com',          '2026-03-05', 'Activo'),
('41998833', 'Fernando',  'Silva',     'fernando@email.com',        '2026-03-10', 'Activo'),
('35667788', 'Patricia',  'Nuñez',     'patricia@email.com',        '2026-03-15', 'Activo'),
('29334455', 'Alejandro', 'Cruz',      'alejandro@email.com',       '2026-03-20', 'Activo'),
('46112233', 'Natalia',   'Reyes',     'natalia@email.com',         '2026-04-01', 'Activo'),
('38990011', 'Hugo',      'Morales',   'hugo@email.com',            '2026-04-05', 'Activo'),
('31223344', 'Luciano',   'Herrera',   'luciano@email.com',         '2026-04-10', 'Activo'),
('40556677', 'Mariano',   'Luna',      'mariano@email.com',         '2026-04-15', 'Activo'),
('36119988', 'Valeria',   'Cabrera',   'valeria@email.com',         '2026-04-20', 'Activo');

-- =============================================
-- 8. SANCIONES
-- Socios 3 y 18 ya están Suspendidos, sus sanciones vigentes
-- Se agregan históricas y adicionales para tener datos ricos
-- =============================================
INSERT INTO SANCION (id_socio, tipo, fecha_inicio, fecha_fin, motivo) VALUES
-- Sanciones activas (fecha_fin >= hoy 2026-06-09)
(3,  'Mora',  '2026-06-01', '2026-06-20', 'Devolución tardía — 7 días de mora'),
(18, 'Daño',  '2026-06-05', '2026-07-05', 'Hojas arrancadas en ejemplar devuelto'),
(9,  'Mora',  '2026-05-20', '2026-06-10', 'Préstamo vencido sin devolución'),
-- Sanciones históricas (ya cumplidas, para enriquecer reportes)
(1,  'Mora',  '2026-01-10', '2026-01-20', 'Sanción cumplida — 3 días de mora'),
(2,  'Mora',  '2025-11-01', '2025-11-10', 'Devolución con 2 días de retraso'),
(5,  'Daño',  '2025-09-15', '2025-10-15', 'Tapa dañada en libro de SO'),
(7,  'Mora',  '2026-02-10', '2026-02-20', 'Vencimiento sin aviso'),
(11, 'Mora',  '2026-03-05', '2026-03-12', 'Retraso en devolución de 4 días'),
(14, 'Mora',  '2026-04-01', '2026-04-08', 'Mora leve — 2 días');

-- =============================================
-- 9. PRÉSTAMOS (55 registros)
-- Referencia de id_ejemplar por libro:
--   isbn 978-0201123456 → ej 1,2,3
--   isbn 978-0133970777 → ej 4,5,6,7,8
--   isbn 978-0137081073 → ej 9,10,11,12
--   isbn 978-0133970778 → ej 13,14,15,16
--   isbn 978-0133970779 → ej 17,18,19,20,21,22
--   isbn 978-0133970780 → ej 23,24,25,26,27
--   isbn 978-0133970781 → ej 28,29,30,31
--   isbn 978-0133970782 → ej 32,33,34,35,36
--   isbn 978-0133970783 → ej 37,38,39
--   isbn 978-0133970784 → ej 40,41
--   isbn 978-0133970785 → ej 42,43,44,45
--   isbn 978-0133970786 → ej 46,47,48
--   isbn 978-0133970787 → ej 49,50
--   isbn 978-0133970788 → ej 51,52,53
--   isbn 978-0133970789 → ej 54,55,56,57
--   isbn 978-0133970790 → ej 58,59,60,61,62
--   isbn 978-0133970791 → ej 63,64,65,66,67,68
--   isbn 978-0133970792 → ej 69,70
--   isbn 978-0133970793 → ej 71,72,73
--   isbn 978-0133970794 → ej 74,75,76,77
-- =============================================
INSERT INTO PRESTAMO (id_socio, id_ejemplar, fecha_prestamo, fecha_vencimiento, fecha_devolucion, estado) VALUES
-- ---- ACTIVOS (26 préstamos — coinciden con ejemplares Prestados) ----
(1,  1,  '2026-05-26', '2026-06-09', NULL, 'Activo'),
(2,  4,  '2026-05-28', '2026-06-11', NULL, 'Activo'),
(4,  5,  '2026-06-01', '2026-06-15', NULL, 'Activo'),
(5,  9,  '2026-06-02', '2026-06-16', NULL, 'Activo'),
(6,  10, '2026-06-03', '2026-06-17', NULL, 'Activo'),
(7,  13, '2026-06-01', '2026-06-15', NULL, 'Activo'),
(8,  17, '2026-05-30', '2026-06-13', NULL, 'Activo'),
(10, 18, '2026-06-04', '2026-06-18', NULL, 'Activo'),
(11, 23, '2026-06-05', '2026-06-19', NULL, 'Activo'),
(12, 24, '2026-06-05', '2026-06-19', NULL, 'Activo'),
(13, 28, '2026-06-02', '2026-06-16', NULL, 'Activo'),
(14, 29, '2026-06-03', '2026-06-17', NULL, 'Activo'),
(15, 32, '2026-06-04', '2026-06-18', NULL, 'Activo'),
(16, 33, '2026-06-01', '2026-06-15', NULL, 'Activo'),
(19, 37, '2026-06-05', '2026-06-19', NULL, 'Activo'),
(20, 40, '2026-05-27', '2026-06-10', NULL, 'Activo'),
(21, 42, '2026-06-03', '2026-06-17', NULL, 'Activo'),
(22, 46, '2026-06-04', '2026-06-18', NULL, 'Activo'),
(23, 49, '2026-06-02', '2026-06-16', NULL, 'Activo'),
(24, 51, '2026-06-05', '2026-06-19', NULL, 'Activo'),
(25, 54, '2026-05-30', '2026-06-13', NULL, 'Activo'),
(26, 58, '2026-06-01', '2026-06-15', NULL, 'Activo'),
(27, 59, '2026-06-03', '2026-06-17', NULL, 'Activo'),
(28, 63, '2026-06-04', '2026-06-18', NULL, 'Activo'),
(29, 64, '2026-06-05', '2026-06-19', NULL, 'Activo'),
(30, 69, '2026-06-02', '2026-06-16', NULL, 'Activo'),
-- ---- VENCIDOS (7 préstamos — fecha_vencimiento pasada, sin devolver) ----
(1,  71, '2026-05-01', '2026-05-15', NULL, 'Vencido'),
(2,  74, '2026-04-10', '2026-04-24', NULL, 'Vencido'),
(4,  6,  '2026-04-20', '2026-05-04', NULL, 'Vencido'),
(6,  30, '2026-05-05', '2026-05-19', NULL, 'Vencido'),
(10, 34, '2026-05-10', '2026-05-24', NULL, 'Vencido'),
(13, 43, '2026-04-15', '2026-04-29', NULL, 'Vencido'),
(20, 55, '2026-05-08', '2026-05-22', NULL, 'Vencido'),
-- ---- DEVUELTOS (22 préstamos — historial variado) ----
(1,  2,  '2026-01-05', '2026-01-19', '2026-01-18', 'Devuelto'),
(2,  7,  '2026-01-10', '2026-01-24', '2026-01-22', 'Devuelto'),
(3,  11, '2025-11-01', '2025-11-15', '2025-11-14', 'Devuelto'),
(4,  14, '2026-02-01', '2026-02-15', '2026-02-14', 'Devuelto'),
(5,  19, '2025-09-10', '2025-09-24', '2025-09-30', 'Devuelto'),
(6,  25, '2026-02-10', '2026-02-24', '2026-02-23', 'Devuelto'),
(7,  31, '2026-02-05', '2026-02-19', '2026-02-26', 'Devuelto'),
(8,  35, '2026-03-01', '2026-03-15', '2026-03-14', 'Devuelto'),
(10, 38, '2026-01-20', '2026-02-03', '2026-02-01', 'Devuelto'),
(11, 44, '2026-03-10', '2026-03-24', '2026-03-22', 'Devuelto'),
(12, 47, '2026-02-15', '2026-03-01', '2026-02-28', 'Devuelto'),
(13, 50, '2026-03-20', '2026-04-03', '2026-04-01', 'Devuelto'),
(14, 52, '2026-04-05', '2026-04-19', '2026-04-17', 'Devuelto'),
(15, 56, '2026-01-15', '2026-01-29', '2026-01-27', 'Devuelto'),
(16, 60, '2026-04-10', '2026-04-24', '2026-04-22', 'Devuelto'),
(17, 65, '2026-03-05', '2026-03-19', '2026-03-18', 'Devuelto'),
(19, 39, '2026-02-20', '2026-03-06', '2026-03-04', 'Devuelto'),
(21, 45, '2026-04-15', '2026-04-29', '2026-04-27', 'Devuelto'),
(22, 48, '2026-05-01', '2026-05-15', '2026-05-13', 'Devuelto'),
(25, 57, '2026-03-25', '2026-04-08', '2026-04-06', 'Devuelto'),
(27, 61, '2026-04-20', '2026-05-04', '2026-05-02', 'Devuelto'),
(28, 66, '2026-05-10', '2026-05-24', '2026-05-22', 'Devuelto');
