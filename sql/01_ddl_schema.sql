DROP DATABASE IF EXISTS BiblioIA;
CREATE DATABASE BiblioIA;
USE BiblioIA;

-- 1. TABLAS MAESTRAS (Sin dependencias)
CREATE TABLE SOCIO (
    id_socio INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(15) UNIQUE NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    fecha_alta DATE NOT NULL,
    estado VARCHAR(20) DEFAULT 'Activo',
    CONSTRAINT chk_estado_socio CHECK (estado IN ('Activo', 'Suspendido', 'Baja'))
);

CREATE TABLE AUTOR (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    nacionalidad VARCHAR(50)
);

CREATE TABLE GENERO (
    id_genero INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT
);

CREATE TABLE LIBRO (
    isbn VARCHAR(20) PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    anio_publicacion INT,
    stock_total INT NOT NULL DEFAULT 0,
    stock_disponible INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_stock CHECK (stock_disponible >= 0 AND stock_disponible <= stock_total)
);

-- 2. TABLAS INTERMEDIAS (Normalización Muchos a Muchos)
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

-- 3. TABLAS DEPENDIENTES DIRECTAS
CREATE TABLE EJEMPLAR (
    id_ejemplar INT AUTO_INCREMENT PRIMARY KEY,
    isbn_libro VARCHAR(20) NOT NULL,
    nro_ejemplar INT NOT NULL,
    estado_fisico VARCHAR(20) DEFAULT 'Disponible', 
    FOREIGN KEY (isbn_libro) REFERENCES LIBRO(isbn) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE (isbn_libro, nro_ejemplar),
    CONSTRAINT chk_estado_ejemplar CHECK (estado_fisico IN ('Disponible', 'Prestado', 'Dañado', 'Baja'))
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

-- 4. TABLA TRANSACCIONAL (El centro del negocio)
CREATE TABLE PRESTAMO (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_socio INT NOT NULL,
    id_ejemplar INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    fecha_devolucion DATE NULL,
    estado VARCHAR(20) DEFAULT 'Activo',
    FOREIGN KEY (id_socio) REFERENCES SOCIO(id_socio) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_ejemplar) REFERENCES EJEMPLAR(id_ejemplar) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_fechas_prestamo CHECK (fecha_vencimiento >= fecha_prestamo),
    CONSTRAINT chk_estado_prestamo CHECK (estado IN ('Activo', 'Devuelto', 'Vencido'))
);

-- 5. TABLA DE AUDITORÍA (Requerida para Triggers)
CREATE TABLE AUDITORIA_PRESTAMOS (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT NOT NULL,
    accion VARCHAR(10) NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_bd VARCHAR(50) NOT NULL,
    detalles TEXT
);
