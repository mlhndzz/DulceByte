DROP DATABASE IF EXISTS DulceByteDB;

CREATE DATABASE DulceByteDB
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE DulceByteDB;

-- Tabla Cliente
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(120) UNIQUE
);

-- Tabla Categoria
CREATE TABLE Categoria (
    idCategoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
);

-- Tabla EstadoPedido
CREATE TABLE EstadoPedido (
    idEstado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
);

-- Tabla Producto
CREATE TABLE Producto (
    idProducto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    precio DECIMAL(10,2) NOT NULL,
    disponible TINYINT(1) NOT NULL DEFAULT 1,
    idCategoria INT NOT NULL,

    CONSTRAINT chk_producto_precio
        CHECK (precio >= 0),

    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (idCategoria)
        REFERENCES Categoria(idCategoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Tabla Pedido
CREATE TABLE Pedido (
    idPedido INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    idCliente INT NOT NULL,
    idEstado INT NOT NULL,

    CONSTRAINT chk_pedido_total
        CHECK (total >= 0),

    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (idCliente)
        REFERENCES Cliente(idCliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_pedido_estado
        FOREIGN KEY (idEstado)
        REFERENCES EstadoPedido(idEstado)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Tabla DetallePedido
CREATE TABLE DetallePedido (
    idDetalle INT AUTO_INCREMENT PRIMARY KEY,
    cantidad INT NOT NULL,
    precioUnitario DECIMAL(10,2) NOT NULL,
    idPedido INT NOT NULL,
    idProducto INT NOT NULL,

    CONSTRAINT chk_detalle_cantidad
        CHECK (cantidad > 0),

    CONSTRAINT chk_detalle_precio
        CHECK (precioUnitario >= 0),

    CONSTRAINT uq_detalle_pedido_producto
        UNIQUE (idPedido, idProducto),

    CONSTRAINT fk_detalle_pedido
        FOREIGN KEY (idPedido)
        REFERENCES Pedido(idPedido)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (idProducto)
        REFERENCES Producto(idProducto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Tabla Auditoria
CREATE TABLE Auditoria (
    idAuditoria INT AUTO_INCREMENT PRIMARY KEY,
    tablaAfectada VARCHAR(50) NOT NULL,
    idRegistro INT NULL,
    accion VARCHAR(20) NOT NULL,
    descripcion VARCHAR(500),
    usuarioBD VARCHAR(150) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER trg_cliente_ai
AFTER INSERT ON Cliente
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria
        (tablaAfectada, idRegistro, accion, descripcion, usuarioBD)
    VALUES
        ('Cliente', NEW.idCliente, 'INSERT',
         CONCAT('Cliente creado: ', NEW.nombre),
         USER());
END$$

CREATE TRIGGER trg_cliente_au
AFTER UPDATE ON Cliente
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria
        (tablaAfectada, idRegistro, accion, descripcion, usuarioBD)
    VALUES
        ('Cliente', NEW.idCliente, 'UPDATE',
         CONCAT(
            'Cliente actualizado. Nombre: ', OLD.nombre, ' -> ', NEW.nombre,
            '; Telefono: ', COALESCE(OLD.telefono,''), ' -> ', COALESCE(NEW.telefono,''),
            '; Correo: ', COALESCE(OLD.correo,''), ' -> ', COALESCE(NEW.correo,'')
         ),
         USER());
END$$

CREATE TRIGGER trg_cliente_ad
AFTER DELETE ON Cliente
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria
        (tablaAfectada, idRegistro, accion, descripcion, usuarioBD)
    VALUES
        ('Cliente', OLD.idCliente, 'DELETE',
         CONCAT('Cliente eliminado: ', OLD.nombre),
         USER());
END$$

CREATE TRIGGER trg_producto_ai
AFTER INSERT ON Producto
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria
        (tablaAfectada, idRegistro, accion, descripcion, usuarioBD)
    VALUES
        ('Producto', NEW.idProducto, 'INSERT',
         CONCAT('Producto creado: ', NEW.nombre, '; precio=', NEW.precio),
         USER());
END$$

CREATE TRIGGER trg_producto_au
AFTER UPDATE ON Producto
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria
        (tablaAfectada, idRegistro, accion, descripcion, usuarioBD)
    VALUES
        ('Producto', NEW.idProducto, 'UPDATE',
         CONCAT(
            'Producto actualizado. Nombre: ', OLD.nombre, ' -> ', NEW.nombre,
            '; Precio: ', OLD.precio, ' -> ', NEW.precio,
            '; Disponible: ', OLD.disponible, ' -> ', NEW.disponible
         ),
         USER());
END$$

CREATE TRIGGER trg_producto_ad
AFTER DELETE ON Producto
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria
        (tablaAfectada, idRegistro, accion, descripcion, usuarioBD)
    VALUES
        ('Producto', OLD.idProducto, 'DELETE',
         CONCAT('Producto eliminado: ', OLD.nombre),
         USER());
END$$

CREATE TRIGGER trg_pedido_ai
AFTER INSERT ON Pedido
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria
        (tablaAfectada, idRegistro, accion, descripcion, usuarioBD)
    VALUES
        ('Pedido', NEW.idPedido, 'INSERT',
         CONCAT(
            'Pedido creado. Cliente=', NEW.idCliente,
            '; Estado=', NEW.idEstado,
            '; Total=', NEW.total
         ),
         USER());
END$$

CREATE TRIGGER trg_pedido_au
AFTER UPDATE ON Pedido
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria
        (tablaAfectada, idRegistro, accion, descripcion, usuarioBD)
    VALUES
        ('Pedido', NEW.idPedido, 'UPDATE',
         CONCAT(
            'Pedido actualizado. Estado: ', OLD.idEstado, ' -> ', NEW.idEstado,
            '; Total: ', OLD.total, ' -> ', NEW.total
         ),
         USER());
END$$

CREATE TRIGGER trg_pedido_ad
AFTER DELETE ON Pedido
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria
        (tablaAfectada, idRegistro, accion, descripcion, usuarioBD)
    VALUES
        ('Pedido', OLD.idPedido, 'DELETE',
         CONCAT('Pedido eliminado. Cliente=', OLD.idCliente, '; Total=', OLD.total),
         USER());
END$$

CREATE TRIGGER trg_detalle_bi
BEFORE INSERT ON DetallePedido
FOR EACH ROW
BEGIN
    DECLARE v_disponible TINYINT DEFAULT NULL;

    SELECT disponible
      INTO v_disponible
      FROM Producto
     WHERE idProducto = NEW.idProducto;

    IF v_disponible IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El producto indicado no existe';
    END IF;

    IF v_disponible = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede agregar un producto no disponible';
    END IF;
END$$

CREATE TRIGGER trg_detalle_ai
AFTER INSERT ON DetallePedido
FOR EACH ROW
BEGIN
    UPDATE Pedido
       SET total = (
            SELECT COALESCE(SUM(cantidad * precioUnitario), 0)
              FROM DetallePedido
             WHERE idPedido = NEW.idPedido
       )
     WHERE idPedido = NEW.idPedido;

    INSERT INTO Auditoria
        (tablaAfectada, idRegistro, accion, descripcion, usuarioBD)
    VALUES
        ('DetallePedido', NEW.idDetalle, 'INSERT',
         CONCAT(
            'Detalle agregado. Pedido=', NEW.idPedido,
            '; Producto=', NEW.idProducto,
            '; Cantidad=', NEW.cantidad
         ),
         USER());
END$$

CREATE TRIGGER trg_detalle_au
AFTER UPDATE ON DetallePedido
FOR EACH ROW
BEGIN
    UPDATE Pedido
       SET total = (
            SELECT COALESCE(SUM(cantidad * precioUnitario), 0)
              FROM DetallePedido
             WHERE idPedido = NEW.idPedido
       )
     WHERE idPedido = NEW.idPedido;

    IF OLD.idPedido <> NEW.idPedido THEN
        UPDATE Pedido
           SET total = (
                SELECT COALESCE(SUM(cantidad * precioUnitario), 0)
                  FROM DetallePedido
                 WHERE idPedido = OLD.idPedido
           )
         WHERE idPedido = OLD.idPedido;
    END IF;

    INSERT INTO Auditoria
        (tablaAfectada, idRegistro, accion, descripcion, usuarioBD)
    VALUES
        ('DetallePedido', NEW.idDetalle, 'UPDATE',
         CONCAT(
            'Detalle actualizado. Pedido=', NEW.idPedido,
            '; Producto=', NEW.idProducto,
            '; Cantidad=', OLD.cantidad, ' -> ', NEW.cantidad
         ),
         USER());
END$$

CREATE TRIGGER trg_detalle_ad
AFTER DELETE ON DetallePedido
FOR EACH ROW
BEGIN
    UPDATE Pedido
       SET total = (
            SELECT COALESCE(SUM(cantidad * precioUnitario), 0)
              FROM DetallePedido
             WHERE idPedido = OLD.idPedido
       )
     WHERE idPedido = OLD.idPedido;

    INSERT INTO Auditoria
        (tablaAfectada, idRegistro, accion, descripcion, usuarioBD)
    VALUES
        ('DetallePedido', OLD.idDetalle, 'DELETE',
         CONCAT(
            'Detalle eliminado. Pedido=', OLD.idPedido,
            '; Producto=', OLD.idProducto
         ),
         USER());
END$$

DELIMITER ;

CREATE OR REPLACE VIEW VW_CatalogoProductos AS
SELECT
    p.idProducto,
    p.nombre AS producto,
    p.descripcion,
    p.precio,
    p.disponible,
    c.idCategoria,
    c.nombre AS categoria
FROM Producto p
INNER JOIN Categoria c
    ON p.idCategoria = c.idCategoria;

CREATE OR REPLACE VIEW VW_ResumenPedidos AS
SELECT
    pe.idPedido,
    pe.fecha,
    cl.idCliente,
    cl.nombre AS cliente,
    ep.idEstado,
    ep.nombre AS estado,
    pe.total
FROM Pedido pe
INNER JOIN Cliente cl
    ON pe.idCliente = cl.idCliente
INNER JOIN EstadoPedido ep
    ON pe.idEstado = ep.idEstado;

CREATE OR REPLACE VIEW VW_DetallePedidos AS
SELECT
    pe.idPedido,
    pe.fecha,
    cl.nombre AS cliente,
    pr.idProducto,
    pr.nombre AS producto,
    dp.cantidad,
    dp.precioUnitario,
    (dp.cantidad * dp.precioUnitario) AS subtotal,
    ep.nombre AS estado
FROM DetallePedido dp
INNER JOIN Pedido pe
    ON dp.idPedido = pe.idPedido
INNER JOIN Cliente cl
    ON pe.idCliente = cl.idCliente
INNER JOIN Producto pr
    ON dp.idProducto = pr.idProducto
INNER JOIN EstadoPedido ep
    ON pe.idEstado = ep.idEstado;

CREATE OR REPLACE VIEW VW_AuditoriaReciente AS
SELECT
    idAuditoria,
    tablaAfectada,
    idRegistro,
    accion,
    descripcion,
    usuarioBD,
    fecha
FROM Auditoria;

DELIMITER $$

CREATE PROCEDURE sp_RegistrarCliente(
    IN p_nombre VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_correo VARCHAR(120)
)
BEGIN
    IF p_nombre IS NULL OR TRIM(p_nombre) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El nombre del cliente es obligatorio';
    END IF;

    INSERT INTO Cliente(nombre, telefono, correo)
    VALUES(TRIM(p_nombre), p_telefono, p_correo);
END$$

CREATE PROCEDURE sp_RegistrarProducto(
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(255),
    IN p_precio DECIMAL(10,2),
    IN p_disponible TINYINT,
    IN p_idCategoria INT
)
BEGIN
    IF p_nombre IS NULL OR TRIM(p_nombre) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El nombre del producto es obligatorio';
    END IF;

    IF p_precio < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El precio no puede ser negativo';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM Categoria WHERE idCategoria = p_idCategoria
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La categoría indicada no existe';
    END IF;

    INSERT INTO Producto
        (nombre, descripcion, precio, disponible, idCategoria)
    VALUES
        (TRIM(p_nombre), p_descripcion, p_precio, p_disponible, p_idCategoria);
END$$

CREATE PROCEDURE sp_CrearPedido(
    IN p_idCliente INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Cliente WHERE idCliente = p_idCliente
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente indicado no existe';
    END IF;

    INSERT INTO Pedido(fecha, total, idCliente, idEstado)
    VALUES(NOW(), 0.00, p_idCliente, 1);

    SELECT LAST_INSERT_ID() AS idPedidoCreado;
END$$

CREATE PROCEDURE sp_AgregarProductoPedido(
    IN p_idPedido INT,
    IN p_idProducto INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_precio DECIMAL(10,2) DEFAULT NULL;

    IF p_cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad debe ser mayor que cero';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM Pedido WHERE idPedido = p_idPedido
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pedido indicado no existe';
    END IF;

    SELECT precio
      INTO v_precio
      FROM Producto
     WHERE idProducto = p_idProducto
       AND disponible = 1;

    IF v_precio IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El producto no existe o no está disponible';
    END IF;

    INSERT INTO DetallePedido
        (cantidad, precioUnitario, idPedido, idProducto)
    VALUES
        (p_cantidad, v_precio, p_idPedido, p_idProducto);
END$$

CREATE PROCEDURE sp_ActualizarEstadoPedido(
    IN p_idPedido INT,
    IN p_idEstado INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Pedido WHERE idPedido = p_idPedido
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pedido indicado no existe';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM EstadoPedido WHERE idEstado = p_idEstado
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El estado indicado no existe';
    END IF;

    UPDATE Pedido
       SET idEstado = p_idEstado
     WHERE idPedido = p_idPedido;
END$$

CREATE PROCEDURE sp_ListarPedidosCliente(
    IN p_idCliente INT
)
BEGIN
    SELECT *
      FROM VW_ResumenPedidos
     WHERE idCliente = p_idCliente
     ORDER BY fecha DESC;
END$$

DELIMITER ;

INSERT INTO Categoria (nombre, descripcion) VALUES
('Bebidas', 'Cafés y bebidas disponibles en DulceByte'),
('Repostería', 'Pasteles, brownies, galletas y postres');

INSERT INTO EstadoPedido (nombre, descripcion) VALUES
('Pendiente', 'Pedido registrado y pendiente de preparación'),
('En preparación', 'Pedido actualmente en preparación'),
('Listo', 'Pedido listo para ser entregado'),
('Entregado', 'Pedido entregado al cliente'),
('Cancelado', 'Pedido cancelado');

INSERT INTO Cliente (nombre, telefono, correo) VALUES
('Andrea López', '7000-1001', 'andrea@email.com'),
('Carlos Martínez', '7000-1002', 'carlos@email.com'),
('Sofía Hernández', '7000-1003', 'sofia@email.com');

INSERT INTO Producto
    (nombre, descripcion, precio, disponible, idCategoria)
VALUES
('Café americano', 'Café negro tradicional', 2.50, 1, 1),
('Capuchino', 'Café con leche espumada', 3.50, 1, 1),
('Brownie', 'Brownie de chocolate', 2.00, 1, 2),
('Cheesecake', 'Porción de cheesecake', 4.00, 1, 2);

INSERT INTO Pedido (idCliente, idEstado) VALUES
(1, 1),
(2, 2);

INSERT INTO DetallePedido
    (cantidad, precioUnitario, idPedido, idProducto)
VALUES
(1, 3.50, 1, 2),
(2, 2.00, 1, 3),
(1, 2.50, 2, 1),
(1, 4.00, 2, 4);

DROP USER IF EXISTS 'dulce_admin'@'localhost';
DROP USER IF EXISTS 'dulce_operador'@'localhost';
DROP USER IF EXISTS 'dulce_auditor'@'localhost';

DROP ROLE IF EXISTS rol_admin;
DROP ROLE IF EXISTS rol_operador;
DROP ROLE IF EXISTS rol_auditor;

CREATE ROLE rol_admin;
CREATE ROLE rol_operador;
CREATE ROLE rol_auditor;

GRANT ALL PRIVILEGES
ON DulceByteDB.*
TO rol_admin;

GRANT SELECT, INSERT, UPDATE
ON DulceByteDB.Cliente
TO rol_operador;

GRANT SELECT
ON DulceByteDB.Categoria
TO rol_operador;

GRANT SELECT, INSERT, UPDATE
ON DulceByteDB.Producto
TO rol_operador;

GRANT SELECT
ON DulceByteDB.EstadoPedido
TO rol_operador;

GRANT SELECT, INSERT, UPDATE
ON DulceByteDB.Pedido
TO rol_operador;

GRANT SELECT, INSERT, UPDATE, DELETE
ON DulceByteDB.DetallePedido
TO rol_operador;

GRANT SELECT
ON DulceByteDB.VW_CatalogoProductos
TO rol_operador;

GRANT SELECT
ON DulceByteDB.VW_ResumenPedidos
TO rol_operador;

GRANT SELECT
ON DulceByteDB.VW_DetallePedidos
TO rol_operador;

GRANT EXECUTE
ON PROCEDURE DulceByteDB.sp_RegistrarCliente
TO rol_operador;

GRANT EXECUTE
ON PROCEDURE DulceByteDB.sp_RegistrarProducto
TO rol_operador;

GRANT EXECUTE
ON PROCEDURE DulceByteDB.sp_CrearPedido
TO rol_operador;

GRANT EXECUTE
ON PROCEDURE DulceByteDB.sp_AgregarProductoPedido
TO rol_operador;

GRANT EXECUTE
ON PROCEDURE DulceByteDB.sp_ActualizarEstadoPedido
TO rol_operador;

GRANT EXECUTE
ON PROCEDURE DulceByteDB.sp_ListarPedidosCliente
TO rol_operador;

GRANT SELECT
ON DulceByteDB.VW_CatalogoProductos
TO rol_auditor;

GRANT SELECT
ON DulceByteDB.VW_ResumenPedidos
TO rol_auditor;

GRANT SELECT
ON DulceByteDB.VW_DetallePedidos
TO rol_auditor;

GRANT SELECT
ON DulceByteDB.VW_AuditoriaReciente
TO rol_auditor;

GRANT SELECT
ON DulceByteDB.Auditoria
TO rol_auditor;

CREATE USER 'dulce_admin'@'localhost'
IDENTIFIED BY 'DulceAdmin_2026!';

CREATE USER 'dulce_operador'@'localhost'
IDENTIFIED BY 'DulceOperador_2026!';

CREATE USER 'dulce_auditor'@'localhost'
IDENTIFIED BY 'DulceAuditor_2026!';

GRANT rol_admin
TO 'dulce_admin'@'localhost';

GRANT rol_operador
TO 'dulce_operador'@'localhost';

GRANT rol_auditor
TO 'dulce_auditor'@'localhost';

SET DEFAULT ROLE rol_admin
FOR 'dulce_admin'@'localhost';

SET DEFAULT ROLE rol_operador
FOR 'dulce_operador'@'localhost';

SET DEFAULT ROLE rol_auditor
FOR 'dulce_auditor'@'localhost';

INSERT INTO Cliente(nombre, telefono, correo)
VALUES('Cliente Prueba', '7000-9999', 'prueba@email.com');

SELECT * FROM Cliente;

UPDATE Cliente
SET telefono = '7111-9999'
WHERE correo = 'prueba@email.com';

DELETE FROM Cliente
WHERE correo = 'prueba@email.com';

SHOW TABLES;

SELECT * FROM VW_CatalogoProductos;
SELECT * FROM VW_ResumenPedidos;
SELECT * FROM VW_DetallePedidos;

CALL sp_RegistrarCliente(
    'Valeria Cruz',
    '7200-1234',
    'valeria@email.com'
);

CALL sp_CrearPedido(3);
CALL sp_AgregarProductoPedido(3, 1, 2);
CALL sp_ActualizarEstadoPedido(1, 2);
CALL sp_ListarPedidosCliente(1);

SELECT *
FROM Auditoria
ORDER BY idAuditoria DESC;

SHOW TRIGGERS;

SHOW PROCEDURE STATUS
WHERE Db = 'DulceByteDB';

SHOW GRANTS FOR rol_admin;
SHOW GRANTS FOR rol_operador;
SHOW GRANTS FOR rol_auditor;

SELECT USER() AS usuario_conectado,
       CURRENT_USER() AS cuenta_efectiva;

SELECT *
FROM VW_ResumenPedidos
ORDER BY idPedido;
