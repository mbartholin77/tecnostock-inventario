
-- Script de base de datos - Sistema de inventario Tecnostock --

CREATE DATABASE IF NOT EXISTS tecnostock
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE tecnostock;

-- 1. Tabla de Usuarios --
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(120) NOT NULL UNIQUE,
    clave VARCHAR(255) NOT NULL,
    estado TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = Activo, 0 = Inactivo'
) ENGINE=InnoDB;

-- 2. Tabla de Categorias --
CREATE TABLE IF NOT EXISTS categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL UNIQUE,
    descripcion VARCHAR(255) NULL,
    estado TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = Activo, 0 = Inactivo'
) ENGINE=InnoDB;

-- 3. Tabla de Productos --
CREATE TABLE IF NOT EXISTS productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    stock_actual INT NOT NULL DEFAULT 0 CHECK (stock_actual >= 0),
    stock_minimo INT NOT NULL DEFAULT 0 CHECK (stock_minimo >= 0),
    estado TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 = Activo, 0 = Inactivo',
    id_categoria INT NOT NULL,
    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 4. Tabla de Movimientos --
CREATE TABLE IF NOT EXISTS movimientos (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo ENUM('entrada', 'salida') NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    observacion VARCHAR(255) NULL,
    id_producto INT NOT NULL,
    id_usuario INT NOT NULL,
    CONSTRAINT fk_movimiento_producto
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_movimiento_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


-- Datos iniciales de prueba --


-- Usuario: Encargado TecnoStock --
-- Correo: encargado@tecnostock.cl --
-- Clave:  password  (hash generado con password_hash de PHP) --
INSERT INTO usuarios (nombre, correo, clave, estado) VALUES
('Encargado TecnoStock', 'encargado@tecnostock.cl', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1);

-- Categorias iniciales --
INSERT INTO categorias (nombre, descripcion, estado) VALUES
('Accesorios', 'Cables, fundas, soportes y adaptadores generales', 1),
('Almacenamiento', 'Pendrives, tarjetas microSD y discos externos', 1),
('Conectividad', 'Hubs USB, adaptadores HDMI, routers y cables de red', 1),
('Perifericos', 'Mouse, teclados, audifonos y webcams', 1);

-- Productos iniciales (incluye un producto con stock bajo para probar alertas) --
INSERT INTO productos (codigo, nombre, descripcion, precio, stock_actual, stock_minimo, estado, id_categoria) VALUES
('TEC-001', 'Mouse Inalambrico Optico', 'Mouse ergonomico 1600 DPI con receptor USB', 12990.00, 15, 5, 1, 4),
('TEC-002', 'Cable HDMI 2.1 2 Metros', 'Cable trenzado de alta velocidad soporte 4K', 7500.00, 3, 8, 1, 3),
('TEC-003', 'Pendrive USB 3.2 64GB', 'Memoria flash metalica de alta transferencia', 9990.00, 20, 6, 1, 2),
('TEC-004', 'Hub USB-C 4 en 1', 'Adaptador multipuerto USB-C a 4 puertos USB 3.0', 18500.00, 4, 4, 1, 1),
('TEC-005', 'Audifonos Cableados Antiguos', 'Modelo discontinuado conector jack 3.5mm', 4990.00, 0, 2, 0, 4);

-- Movimientos iniciales de ejemplo --
INSERT INTO movimientos (tipo, cantidad, observacion, id_producto, id_usuario) VALUES
('entrada', 15, 'Carga inicial de inventario', 1, 1),
('entrada', 10, 'Compra a proveedor mayorista', 2, 1),
('salida', 7, 'Venta despacho tienda local', 2, 1);