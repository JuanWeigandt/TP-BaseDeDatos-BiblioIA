DROP DATABASE IF EXISTS BiblioIA;
CREATE DATABASE BiblioIA;
USE BiblioIA;

-- 1. TABLAS DE DOMINIO

CREATE TABLE ESTADO_SOCIO (
    id_estado_socio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE ESTADO_EJEMPLAR (
    id_estado_ejemplar INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE ESTADO_PRESTAMO (
    id_estado_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE ESTADO_RESERVA (
    id_estado_reserva INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE NACIONALIDAD(
    id_nacionalidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE GENERO (
    id_genero INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT
);

-- 2. TABLAS MAESTRAS PRINCIPALES

CREATE TABLE SOCIO (
    id_socio INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(15) UNIQUE NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    fecha_alta DATE NOT NULL,
    id_estado_socio INT NOT NULL DEFAULT 1, -- Por defecto '1' (Activo)
    FOREIGN KEY (id_estado_socio) REFERENCES ESTADO_SOCIO(id_estado_socio) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE LIBRO (
    isbn VARCHAR(20) PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    anio_publicacion INT,
    stock_total INT NOT NULL DEFAULT 0,
    stock_disponible INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_stock CHECK (stock_disponible >= 0 AND stock_disponible <= stock_total)
);

-- 3. TABLAS INTERMEDIAS Y DEPENDIENTES DIRECTAS

CREATE TABLE AUTOR (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    id_nacionalidad INT NOT NULL,
    FOREIGN KEY (id_nacionalidad) REFERENCES NACIONALIDAD(id_nacionalidad) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE LIBRO_AUTOR (
    isbn_libro VARCHAR(20),
    id_autor INT,
    PRIMARY KEY (isbn_libro, id_autor),
    FOREIGN KEY (isbn_libro) REFERENCES LIBRO(isbn) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES AUTOR(id_autor) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE LIBRO_GENERO (
    isbn_libro VARCHAR(20),
    id_genero INT,
    PRIMARY KEY (isbn_libro, id_genero),
    FOREIGN KEY (isbn_libro) REFERENCES LIBRO(isbn) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_genero) REFERENCES GENERO(id_genero) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE EJEMPLAR (
    id_ejemplar INT AUTO_INCREMENT PRIMARY KEY,
    isbn_libro VARCHAR(20) NOT NULL,
    nro_ejemplar INT NOT NULL,
    id_estado_ejemplar INT NOT NULL DEFAULT 1,  -- Por defecto '1' (Disponible)
    FOREIGN KEY (isbn_libro) REFERENCES LIBRO(isbn) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_estado_ejemplar) REFERENCES ESTADO_EJEMPLAR(id_estado_ejemplar) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE (isbn_libro, nro_ejemplar)
);

CREATE TABLE SANCION (
    id_sancion INT AUTO_INCREMENT PRIMARY KEY,
    id_socio INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    motivo TEXT NOT NULL,
    FOREIGN KEY (id_socio) REFERENCES SOCIO(id_socio) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_fechas_sancion CHECK (fecha_fin >= fecha_inicio)
);

-- 4. TABLAS TRANSACCIONALES (Ciclo Operativo de la Biblioteca)

CREATE TABLE PRESTAMO (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_socio INT NOT NULL,
    id_ejemplar INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    fecha_devolucion DATE NULL,
    id_estado_prestamo INT NOT NULL DEFAULT 1, -- Por defecto '1' (Activo)
    FOREIGN KEY (id_socio) REFERENCES SOCIO(id_socio) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_ejemplar) REFERENCES EJEMPLAR(id_ejemplar) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_estado_prestamo) REFERENCES ESTADO_PRESTAMO(id_estado_prestamo) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_fechas_prestamo CHECK (fecha_vencimiento >= fecha_prestamo)
);

CREATE TABLE RESERVA (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_socio INT NOT NULL,
    isbn_libro VARCHAR(20) NOT NULL,
    fecha_solicitud DATE NOT NULL,
    id_estado_reserva INT NOT NULL DEFAULT 1,  -- Por defecto '1' (Pendiente)
    FOREIGN KEY (id_socio) REFERENCES SOCIO(id_socio) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (isbn_libro) REFERENCES LIBRO(isbn) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_estado_reserva) REFERENCES ESTADO_RESERVA(id_estado_reserva) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 5. TABLA DE AUDITORÍA E ÍNDICES

CREATE TABLE AUDITORIA_PRESTAMO (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT NOT NULL,
    accion VARCHAR(10) NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_bd VARCHAR(50) NOT NULL,
    detalles TEXT
);

-- Índices para optimizar las consultas del Agente IA
CREATE INDEX idx_libro_titulo ON LIBRO(titulo);

CREATE INDEX idx_autor_apellido ON AUTOR(apellido);

CREATE INDEX idx_prestamo_vencimiento ON PRESTAMO(fecha_vencimiento);

CREATE INDEX idx_sancion_fecha_fin ON SANCION(fecha_fin);
