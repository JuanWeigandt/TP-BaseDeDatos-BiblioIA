USE BiblioIA;

-- 1. GÉNEROS (5 registros)
INSERT INTO GENERO (nombre, descripcion) VALUES
('Ingeniería de Software', 'Metodologías, procesos unificados y arquitectura'),
('Bases de Datos', 'Diseño, modelado relacional y SQL'),
('Sistemas Operativos', 'Sistemas de archivos, kernel y memoria'),
('Matemática Computacional', 'Programación lineal y optimización'),
('Programación', 'Estructuras de datos dinámicas y algoritmos');

-- 2. AUTORES (10 registros)
INSERT INTO AUTOR (nombre, apellido, nacionalidad) VALUES
('Philippe', 'Kruchten', 'Francesa'),
('Ian', 'Sommerville', 'Británica'),
('Ramez', 'Elmasri', 'Egipcia'),
('Shamkant', 'Navathe', 'India'),
('Abraham', 'Silberschatz', 'Estadounidense'),
('Andrew', 'Tanenbaum', 'Estadounidense'),
('Hamdy', 'Taha', 'Egipcia'),
('Niklaus', 'Wirth', 'Suiza'),
('Roger', 'Pressman', 'Estadounidense'),
('Ivar', 'Jacobson', 'Sueca');

-- 3. LIBROS (20 registros)
INSERT INTO LIBRO (isbn, titulo, anio_publicacion, stock_total, stock_disponible) VALUES
('978-0201123456', 'Arquitectura de Software: Vistas 4+1', 1995, 3, 3),
('978-0133970777', 'Ingeniería de Software: Un Enfoque Práctico', 2014, 5, 5),
('978-0137081073', 'El Proceso Unificado de Desarrollo de Software', 1999, 4, 3),
('978-0133970778', 'Ingeniería de Software', 2011, 4, 4),
('978-0133970779', 'Sistemas de Bases de Datos: Conceptos Fundamentales', 2015, 6, 6),
('978-0133970780', 'Fundamentos de Bases de Datos', 2010, 5, 4),
('978-0133970781', 'Sistemas Operativos Modernos', 2014, 4, 4),
('978-0133970782', 'Conceptos de Sistemas Operativos', 2018, 5, 5),
('978-0133970783', 'Investigación de Operaciones', 2017, 3, 3),
('978-0133970784', 'Algoritmos y Estructuras de Datos en Pascal', 1985, 2, 2),
('978-0133970785', 'Diseño de Bases de Datos Relacionales', 2008, 4, 4),
('978-0133970786', 'Patrones de Arquitectura de Software', 2001, 3, 3),
('978-0133970787', 'Administración de Linux', 2020, 2, 2),
('978-0133970788', 'Modelos Lineales con LINDO', 2005, 3, 3),
('978-0133970789', 'Programación Estructurada', 1990, 4, 4),
('978-0133970790', 'SQL Avanzado', 2019, 5, 5),
('978-0133970791', 'Metodologías Ágiles y Scrum', 2021, 6, 6),
('978-0133970792', 'Sistemas de Archivos NTFS y VFS', 2012, 2, 2),
('978-0133970793', 'El Método Simplex', 2003, 3, 3),
('978-0133970794', 'Normalización de Bases de Datos', 2016, 4, 4);

-- 4. LIBRO_AUTOR y LIBRO_GENERO (Relaciones)
INSERT INTO LIBRO_AUTOR (isbn_libro, id_autor) VALUES
('978-0201123456', 1), ('978-0137081073', 10), ('978-0133970777', 9),
('978-0133970778', 2), ('978-0133970779', 3), ('978-0133970779', 4),
('978-0133970780', 5), ('978-0133970781', 6), ('978-0133970782', 5),
('978-0133970783', 7), ('978-0133970784', 8);

INSERT INTO LIBRO_GENERO (isbn_libro, id_genero) VALUES
('978-0201123456', 1), ('978-0133970777', 1), ('978-0137081073', 1),
('978-0133970779', 2), ('978-0133970780', 2), ('978-0133970781', 3),
('978-0133970782', 3), ('978-0133970783', 4), ('978-0133970784', 5);

-- 5. EJEMPLARES
INSERT INTO EJEMPLAR (isbn_libro, nro_ejemplar, estado_fisico) VALUES
('978-0201123456', 1, 'Disponible'), ('978-0201123456', 2, 'Disponible'), ('978-0201123456', 3, 'Disponible'),
('978-0137081073', 1, 'Prestado'), ('978-0137081073', 2, 'Disponible'), ('978-0137081073', 3, 'Disponible'), ('978-0137081073', 4, 'Baja'),
('978-0133970780', 1, 'Prestado'), ('978-0133970780', 2, 'Disponible'), ('978-0133970780', 3, 'Disponible'), ('978-0133970780', 4, 'Disponible'), ('978-0133970780', 5, 'Disponible');

-- 6. SOCIOS (30)
INSERT INTO SOCIO (dni, nombre, apellido, email, fecha_alta, estado) VALUES
('35123456', 'Juan', 'Perez', 'juan@email.com', '2025-01-10', 'Activo'),
('28456789', 'Maria', 'Gomez', 'maria@email.com', '2025-02-15', 'Activo'),
('41234567', 'Carlos', 'Lopez', 'carlos@email.com', '2025-03-20', 'Suspendido'),
('33987654', 'Ana', 'Martinez', 'ana@email.com', '2025-04-25', 'Activo'),
('29112233', 'Luis', 'Rodriguez', 'luis@email.com', '2025-05-30', 'Activo'),
('45678901', 'Laura', 'Fernandez', 'laura@email.com', '2025-06-05', 'Activo'),
('31445566', 'Diego', 'Gonzalez', 'diego@email.com', '2025-07-10', 'Activo'),
('40123987', 'Sofia', 'Diaz', 'sofia@email.com', '2025-08-15', 'Activo'),
('27889900', 'Javier', 'Hernandez', 'javier@email.com', '2025-09-20', 'Baja'),
('38556677', 'Marta', 'Alvarez', 'marta@email.com', '2025-10-25', 'Activo'),
('42334455', 'Pedro', 'Romero', 'pedro@email.com', '2026-01-05', 'Activo'),
('36778899', 'Lucia', 'Suarez', 'lucia@email.com', '2026-01-10', 'Activo'),
('25112244', 'Jorge', 'Torres', 'jorge@email.com', '2026-01-15', 'Activo'),
('39445522', 'Elena', 'Ruiz', 'elena@email.com', '2026-01-20', 'Activo'),
('34556611', 'Raul', 'Ramirez', 'raul@email.com', '2026-01-25', 'Activo'),
('43223344', 'Paula', 'Flores', 'paula@email.com', '2026-02-01', 'Activo'),
('30113355', 'Andres', 'Acosta', 'andres@email.com', '2026-02-05', 'Activo'),
('26998877', 'Silvia', 'Medina', 'silvia@email.com', '2026-02-10', 'Suspendido'),
('44556677', 'Martin', 'Rojas', 'martin@email.com', '2026-02-15', 'Activo'),
('37221100', 'Carmen', 'Molina', 'carmen@email.com', '2026-02-20', 'Activo'),
('32445588', 'Roberto', 'Castro', 'roberto@email.com', '2026-03-01', 'Activo'),
('24887766', 'Teresa', 'Ortiz', 'teresa@email.com', '2026-03-05', 'Activo'),
('41998833', 'Fernando', 'Silva', 'fernando@email.com', '2026-03-10', 'Activo'),
('35667788', 'Patricia', 'Nuñez', 'patricia@email.com', '2026-03-15', 'Activo'),
('29334455', 'Alejandro', 'Cruz', 'alejandro@email.com', '2026-03-20', 'Activo'),
('46112233', 'Natalia', 'Reyes', 'natalia@email.com', '2026-04-01', 'Activo'),
('38990011', 'Hugo', 'Morales', 'hugo@email.com', '2026-04-05', 'Activo'),
('31223344', 'Gabriela', 'Herrera', 'gabriela@email.com', '2026-04-10', 'Activo'),
('40556677', 'Mariano', 'Luna', 'mariano@email.com', '2026-04-15', 'Activo'),
('36119988', 'Valeria', 'Cabrera', 'valeria@email.com', '2026-04-20', 'Activo');

-- 7. SANCIONES ACTIVAS E INACTIVAS
INSERT INTO SANCION (id_socio, tipo, fecha_inicio, fecha_fin, motivo) VALUES
(3, 'Mora', '2026-06-01', '2026-06-15', 'Devolución tardía de libro'),
(18, 'Daño', '2026-06-05', '2026-07-05', 'Hojas arrancadas en ejemplar'),
(1, 'Mora', '2026-01-10', '2026-01-20', 'Sanción ya cumplida histórica');

-- 8. PRÉSTAMOS (Muestra representativa de activos, devueltos y vencidos)
INSERT INTO PRESTAMO (id_socio, id_ejemplar, fecha_prestamo, fecha_vencimiento, fecha_devolucion, estado) VALUES
(1, 4, '2026-06-01', '2026-06-15', NULL, 'Activo'),
(2, 8, '2026-05-01', '2026-05-15', '2026-05-14', 'Devuelto'),
(4, 8, '2026-05-10', '2026-05-24', NULL, 'Vencido');
