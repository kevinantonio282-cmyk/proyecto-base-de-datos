/*
PROYECTO SISTEMA DE GESTION DE REPARACIONES TECNOLOGICAS

ESTUDIANTES:
JUAN DAVID CALVO RIOS
CARLOS DANIEL ARAYA BARRANTES
KEVIN ANTONIO HERNANDEZ MORALES

*/

-- FASE 1. INVESTIGACION Y ANALISIS DEL DISEÑO

-- Ver archivo de word.

-- FASE 2. CREACION DE LA ESTRUCTURA (DDL)

-- 2.1 Crear la base de datos SISTEMAREPARACIONES (si ya existe, puedes omitir esta línea o usar la que tienes)

CREATE DATABASE SISTEMAREPARACIONES;
GO

-- Crea la base de datos donde se almacenará toda la información del sistema de reparaciones. Constituye el contenedor principal de las tablas, relaciones y demás objetos SQL.

-- 2.2 Usar obligatoriamente la base de datos SISTEMAREPARACIONES

USE SISTEMAREPARACIONES;
GO

-- Establece la base de datos sobre la cual se ejecutarán las instrucciones posteriores. El comando GO separa los bloques de ejecución en SQL Server Management Studio.

-- 2.3 SE HIZO UN BORRADO DE TABLAS ERROR EN CODIGOS

DROP TABLE IF EXISTS Asignaciones;
DROP TABLE IF EXISTS DetallesReparacion;
DROP TABLE IF EXISTS Reparaciones;
DROP TABLE IF EXISTS Equipos;
DROP TABLE IF EXISTS Tecnicos;
DROP TABLE IF EXISTS USUARIOS;
GO

--Elimina las tablas existentes para permitir su creación nuevamente, evitando conflictos por nombres duplicados. Las tablas se eliminan en un orden que respeta las relaciones entre claves primarias y foráneas.
--Esta operación también elimina permanentemente los registros almacenados en dichas tablas.

-- 2.4 Tabla Usuarios
CREATE TABLE USUARIOS (
    USUARIOID INT IDENTITY(101,1) PRIMARY KEY,
    NOMBRE VARCHAR(100) NOT NULL,
    CORREOELECTRONICO VARCHAR(100) NOT NULL,
    TELEFONO VARCHAR(20)
);
GO

-- Crea la tabla que almacena la información de los usuarios que solicitan servicios de reparación, incluyendo nombre, correo electrónico y teléfono.
-- La columna USUARIOID funciona como clave primaria y utiliza IDENTITY(101,1) para generar identificadores consecutivos a partir de 101.

-- 2.5 Tabla Equipos (Depende de USUARIOS)
CREATE TABLE Equipos (
    EquipoID INT IDENTITY(201,1) PRIMARY KEY,
    TipoEquipo VARCHAR(50) NOT NULL,
    Modelo VARCHAR(50) NOT NULL,
    UsuarioID INT NOT NULL,
    FOREIGN KEY (UsuarioID) REFERENCES USUARIOS(USUARIOID)
);
GO

-- Registra los equipos tecnológicos pertenecientes a los usuarios, identificando su tipo y modelo.
-- Utiliza EquipoID como clave primaria y UsuarioID como clave foránea para establecer la relación con la tabla USUARIOS.

-- 2.6 Tabla Tecnicos

CREATE TABLE Tecnicos (
    TecnicoID INT IDENTITY(301,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Especialidad VARCHAR(100)
);
GO

-- Almacena la información de los técnicos responsables de realizar las reparaciones, incluyendo su nombre y especialidad.
-- La clave primaria TecnicoID identifica de manera única a cada técnico, comenzando la numeración en 301.

-- 2.7 Tabla Reparaciones (Depende de Equipos)

CREATE TABLE Reparaciones (
    ReparacionID INT IDENTITY(401,1) PRIMARY KEY,
    EquipoID INT NOT NULL,
    FechaSolicitud DATE NOT NULL,
    Estado VARCHAR(50) NOT NULL,
    FOREIGN KEY (EquipoID) REFERENCES Equipos(EquipoID)
);
GO

-- Registra las solicitudes de reparación realizadas por los usuarios, incluyendo el equipo correspondiente, la fecha de solicitud y el estado del servicio.
-- Utiliza ReparacionID como clave primaria y EquipoID como clave foránea para relacionar cada reparación con un equipo existente.

-- 2.8 Tabla DetallesReparacion (Depende de Reparaciones)

CREATE TABLE DetallesReparacion (
    DetalleID INT IDENTITY(501,1) PRIMARY KEY,
    ReparacionID INT NOT NULL,
    Descripcion TEXT NOT NULL,
    FechaInicio DATE,
    FechaFin DATE,
    FOREIGN KEY (ReparacionID) REFERENCES Reparaciones(ReparacionID)
);
GO

-- Almacena la descripción de los trabajos realizados, así como las fechas de inicio y finalización.
-- La columna FechaFin permite valores NULL para identificar reparaciones que todavía no han concluido.

-- 2.9 Tabla Asignaciones (Depende de Reparaciones y Tecnicos)

CREATE TABLE Asignaciones (
    AsignacionID INT IDENTITY(601,1) PRIMARY KEY,
    ReparacionID INT NOT NULL,
    TecnicoID INT NOT NULL,
    FechaAsignacion DATE NOT NULL,
    FOREIGN KEY (ReparacionID) REFERENCES Reparaciones(ReparacionID),
    FOREIGN KEY (TecnicoID) REFERENCES Tecnicos(TecnicoID)
);

-- Establece la relación entre las reparaciones solicitadas y los técnicos encargados de atenderlas.
-- Utiliza dos claves foráneas, ReparacionID y TecnicoID, que permiten identificar qué técnico fue asignado a cada reparación y en qué fecha.

-- FASE 3. MANIPULACION Y LOGICA DE NEGOCIO (DML Y PROCEDIMIENTO)

-- 3.1 Insertar Datos para Tabla Usuarios

INSERT INTO dbo.USUARIOS (NOMBRE, CORREOELECTRONICO, TELEFONO)
    VALUES ('DANIEL ARAYA B', 'daniel-a-6@hotmail.com','8821-6148'),
           ('CARLOS BARRANTES C', 'danielab4784@gmail.com', '8861-2148'),
           ('JORGE PEREZ D', 'jperez@gmail.com', '8950-3647'),
           ('HILDA CORRALES A', 'hildacorrales@hotmail.com', '8123-4567'),
           ('DIEGO ARTAVIA A', 'dartavia1977@hotmail.com', '8675-4321'),
           ('MARVIN MORENO C', 'marvin.moreno11@gmail.com', '8978-7890'),
           ('RUTH MORA H', 'mora.ruth@gmail.com', '8890-4369'),
           ('ADRIANA DURAN P', 'adri.duran15@gmail.com', '8746-8523');

-- Incorpora ocho usuarios iniciales con sus respectivos datos de contacto.
-- La instrucción SELECT * FROM USUARIOS permite consultar los registros almacenados y verificar que la inserción se realizó correctamente.

SELECT * FROM USUARIOS;

-- 3.2 Insertar Datos para Tabla Equipos

INSERT INTO Equipos (TipoEquipo, Modelo, UsuarioID)
    VALUES ('LAPTOP', 'LENOVO IdeaPad Slim 3 15IRU8', 101),
           ('MONITOR', 'SAMSUNG Odyssey OLED G8', 102),
           ('IMPRESORA', 'EPSON EcoTank L120 ', 103),
           ('CELULAR', 'HONOR Magic 8 Pro', 104),
           ('TABLET', 'SAMSUNG Galaxy Tab S12', 105),
           ('CELULAR', 'XIAOMI Redmi A7 Pro', 106),
           ('CELULAR', 'HONOR X7d', 107),
           ('LAPTOP', 'HP 15-fc0230la', 108);

-- Registra ocho equipos tecnológicos y los relaciona con sus respectivos propietarios mediante UsuarioID.
-- Esta operación garantiza que cada equipo quede vinculado a un usuario previamente registrado.

SELECT * FROM Equipos;

-- 3.3 Insertar Datos para Tabla Tecnicos

INSERT INTO Tecnicos(Nombre, Especialidad)
    VALUES ('JUAN CALVO', 'DESKTOP SUPPORT'),
           ('ANTONIO HERNANDEZ', 'APLICACIONES Y SOFTWARE'),
           ('DAVID RIOS', 'CIBERSEGURIDAD'),
           ('KEVIN MORALES', 'HARDWARE'),
           ('CATALINA MORENO', 'DESKTOP SUPPORT');

-- Incorpora cinco técnicos con diferentes especialidades, como soporte técnico, aplicaciones, ciberseguridad y hardware. Estos registros serán utilizados posteriormente para asignar las reparaciones.

SELECT * FROM Tecnicos;

-- 3.4 Insertar Datos para tabla Reparaciones

INSERT INTO Reparaciones(EquipoID, FechaSolicitud, Estado)
    VALUES (201, '2026/10/15', 'COMPLETADO'),
           (202, '2026/10/20', 'COMPLETADO'),
           (203, '2026/10/28', 'COMPLETADO'),
           (204, '2026/11/03', 'PENDIENTE'),
           (205, '2026/11/09', 'PENDIENTE'),
           (206, '2026/11/17', 'PENDIENTE'),
           (207, '2026/11/20', 'ASIGNADA'),
           (208, '2026/11/21', 'ASIGNADA');

-- Registra ocho solicitudes iniciales, indicando el equipo, la fecha de solicitud y su estado.
-- Se utilizan los estados COMPLETADO, PENDIENTE y ASIGNADA para identificar la situación de cada reparación.

SELECT * FROM Reparaciones;

-- 3.5 Insertar Datos para tabla Detalles Reparación

INSERT INTO DetallesReparacion(ReparacionID, Descripcion, FechaInicio, FechaFin)
    VALUES (401, 'Instalacion de varios softwares', '2026/10/15','2026/10/22'),
           (402, 'Equipo no enciende', '2026/10/20','2026/10/25'),
           (403, 'Conectar impresora por WiFi','2026/10/28', '2026/10/30'),
           (404, 'Cambio de pantalla', '2026/11/03', NULL),
           (405, 'Revisión por lentitud en funcionamiento de equipo', '2026/11/03', NULL),
           (406, 'Sobrecalentamiento del equipo', '2026/11/03', NULL),
           (407, 'Revision de virus y malware', '2026/11/03', NULL),
           (408, 'Reinstalación de Windows 11', '2026/11/03', NULL);

-- Registra las actividades asociadas a cada reparación, incluyendo la descripción del problema y las fechas correspondientes.
-- Las reparaciones pendientes mantienen FechaFin = NULL, lo que permite identificar trabajos que todavía no han finalizado.

SELECT * FROM DetallesReparacion;

-- 3.6 Datos para tabla Asignaciones

INSERT INTO Asignaciones(ReparacionID, TecnicoID, FechaAsignacion)
    VALUES (401, 302, '2026/10/14'),
           (402, 304, '2026/10/19'),
           (403, 301, '2026/10/27'),
           (404, 304, '2026/11/02'),
           (405, 301, '2026/11/07'),
           (406, 303, '2026/11/16'),
           (407, 303, '2026/11/19'),
           (408, 302, '2026/11/20');

-- Registra la distribución inicial de las reparaciones entre los técnicos disponibles.
-- Cada registro contiene el identificador de la reparación, el técnico asignado y la fecha de asignación.

SELECT * FROM Asignaciones;

-- 3.8 Procedimiento de almacenado. Registrar nueva Reparación

USE SISTEMAREPARACIONES;
GO

CREATE OR ALTER PROCEDURE dbo.sp_RegistrarReparacion
    @NombreUsuario VARCHAR(100),
    @CorreoElectronico VARCHAR(100),
    @Telefono VARCHAR(20),
    @TipoEquipo VARCHAR(50),
    @Modelo VARCHAR(50),
    @FechaSolicitud DATE
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @UsuarioID INT;
    DECLARE @EquipoID INT;
    DECLARE @ReparacionID INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. REGISTRAR NUEVO USUARIO

        INSERT INTO USUARIOS
            (NOMBRE, CORREOELECTRONICO, TELEFONO)
        VALUES
            (@NombreUsuario, @CorreoElectronico,
             @Telefono);

        -- Obtener el ID generado automáticamente
        SET @UsuarioID = SCOPE_IDENTITY();

        -- 2. REGISTRAR NUEVO EQUIPO

        INSERT INTO Equipos
            (TipoEquipo, Modelo, UsuarioID)
        VALUES
            (@TipoEquipo, @Modelo, @UsuarioID);

        -- Obtener el ID del nuevo equipo
        SET @EquipoID = SCOPE_IDENTITY();

        -- 3. REGISTRAR NUEVA REPARACION

        INSERT INTO Reparaciones
            (EquipoID, FechaSolicitud, Estado)
        VALUES
            (@EquipoID, @FechaSolicitud, 'PENDIENTE');

        -- Obtener el ID de la reparación
        SET @ReparacionID = SCOPE_IDENTITY();

        -- Confirmar las tres inserciones
        COMMIT TRANSACTION;

        -- 4. MOSTRAR LOS DATOS REGISTRADOS

        SELECT
            U.USUARIOID,
            U.NOMBRE AS NombreUsuario,
            U.CORREOELECTRONICO,
            U.TELEFONO,
            E.EquipoID,
            E.TipoEquipo,
            E.Modelo,
            R.ReparacionID,
            R.FechaSolicitud,
            R.Estado
        FROM USUARIOS U
        INNER JOIN Equipos E
            ON U.USUARIOID = E.UsuarioID
        INNER JOIN Reparaciones R
            ON E.EquipoID = R.EquipoID
        WHERE R.ReparacionID = @ReparacionID;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;
END;
GO

-- Este procedimiento automatiza el registro de un usuario nuevo, su equipo tecnológico y la solicitud de reparación correspondiente.
-- Recibe como parámetros el nombre, correo electrónico, teléfono, tipo de equipo, modelo y fecha de solicitud.
-- Utiliza SCOPE_IDENTITY() para recuperar los identificadores generados automáticamente y establecer correctamente las relaciones entre las tablas.
-- Además, incorpora BEGIN TRANSACTION, COMMIT, ROLLBACK y TRY...CATCH para garantizar que las operaciones se ejecuten conjuntamente y se reviertan si ocurre algún error.

    -- Ejecutar el procedimiento

EXEC dbo.sp_RegistrarReparacion
    @NombreUsuario = 'EYLLIN ARIAS C',
    @CorreoElectronico = 'earias1982@outlook.com',
    @Telefono = '8412-9435',
    @TipoEquipo = 'LAPTOP',
    @Modelo = 'ASUS VivoBook 15',
    @FechaSolicitud = '2026-11-22';


-- 3.9 Procedimiento de almacenado. Asignar Técnico

USE SISTEMAREPARACIONES;
GO

CREATE OR ALTER PROCEDURE sp_AsignarTecnico
    @ReparacionID INT,
    @TecnicoID INT,
    @FechaAsignacion DATE
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar que exista la reparación

        IF NOT EXISTS (
            SELECT 1
            FROM Reparaciones WITH (UPDLOCK, HOLDLOCK)
            WHERE ReparacionID = @ReparacionID
              AND Estado IN ('PENDIENTE', 'ASIGNADA', 'EN PROGRESO')
        )
        BEGIN
            THROW 50002,
                'La reparacion no existe o esta finalizada.', 1;
        END;

        -- Verificar que exista el técnico

        IF NOT EXISTS (
            SELECT 1
            FROM Tecnicos WITH (UPDLOCK, HOLDLOCK)
            WHERE TecnicoID = @TecnicoID
        )
        BEGIN
            THROW 50003, 'El tecnico no existe.', 1;
        END;

        -- Verificar disponibilidad del técnico

        IF EXISTS (
            SELECT 1
            FROM Asignaciones A
            INNER JOIN Reparaciones R
                ON A.ReparacionID = R.ReparacionID
            WHERE A.TecnicoID = @TecnicoID
              AND R.Estado IN
                  ('PENDIENTE', 'ASIGNADA', 'EN PROGRESO')
        )
        BEGIN
            THROW 50004,
                'El tecnico tiene una reparacion activa.', 1;
        END;

        -- Evitar asignaciones duplicadas

        IF EXISTS (
            SELECT 1
            FROM Asignaciones
            WHERE ReparacionID = @ReparacionID
        )
        BEGIN
            THROW 50005,
                'La reparacion ya tiene un tecnico asignado.', 1;
        END;

        -- Registrar asignación

        INSERT INTO Asignaciones
            (ReparacionID, TecnicoID, FechaAsignacion)
        VALUES
            (@ReparacionID, @TecnicoID, @FechaAsignacion);

        -- Actualizar estado

        UPDATE Reparaciones
        SET Estado = 'ASIGNADA'
        WHERE ReparacionID = @ReparacionID;

        COMMIT TRANSACTION;

        -- Mostrar la asignación

        SELECT
            A.AsignacionID,
            A.ReparacionID,
            A.TecnicoID,
            T.Nombre AS NombreTecnico,
            A.FechaAsignacion,
            R.Estado
        FROM Asignaciones A
        INNER JOIN Tecnicos T
            ON A.TecnicoID = T.TecnicoID
        INNER JOIN Reparaciones R
            ON A.ReparacionID = R.ReparacionID
        WHERE A.AsignacionID = SCOPE_IDENTITY();

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

-- Automatiza la asignación de un técnico disponible a una reparación existente.
-- Recibe tres parámetros: ReparacionID, TecnicoID y FechaAsignacion.
-- Evita asignaciones duplicadas mediante las condiciones IF EXISTS e IF NOT EXISTS.
-- Si las validaciones se cumplen, inserta el registro en Asignaciones y actualiza el estado de la reparación a ASIGNADA.
-- La instrucción THROW permite generar mensajes de error específicos cuando alguna condición no se cumple.

    -- Ejecutar el procedimiento

    EXEC sp_AsignarTecnico
    @ReparacionID = 409,
    @TecnicoID = 305,
    @FechaAsignacion = '2026-11-22';


-- 3.10 Trigger (disparador) para cambiar Estado de una Reparación de Pendiente a Completado

USE SISTEMAREPARACIONES;
GO

CREATE OR ALTER TRIGGER trg_FinalizarReparacion
ON DetallesReparacion
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualizar el estado de la reparación
    -- cuando se registre una FechaFin

    UPDATE R
    SET R.Estado = 'COMPLETADO'
    FROM Reparaciones R
    INNER JOIN inserted I
        ON R.ReparacionID = I.ReparacionID
    INNER JOIN deleted D
        ON I.DetalleID = D.DetalleID
    WHERE I.FechaFin IS NOT NULL
      AND D.FechaFin IS NULL
      AND R.Estado IN
          ('PENDIENTE', 'ASIGNADA', 'EN PROGRESO');
END;
GO

    -- Registro de fecha de finalización

UPDATE DetallesReparacion
SET FechaFin = '2026-11-22'
WHERE ReparacionID = 404;

-- Este disparador automatiza la actualización del estado de una reparación cuando se registra su fecha de finalización. Se ejecuta mediante AFTER UPDATE sobre la tabla DetallesReparacion.
-- Cuando se pasa de no tener fecha de finalización (NULL) a tener una fecha registrada, actualiza automáticamente su estado a COMPLETADO en la tabla Reparaciones.

    -- Probar funcionamiento del Trigger
 
 SELECT
    R.ReparacionID,
    R.Estado,
    D.Descripcion,
    D.FechaInicio,
    D.FechaFin
FROM Reparaciones R
INNER JOIN DetallesReparacion D
    ON R.ReparacionID = D.ReparacionID
WHERE R.ReparacionID = 404;

-- FASE 4. CONSULTAS DE ANALISIS E INFORMES

-- 4.1 Informe de Asignaciones


USE SISTEMAREPARACIONES;
GO

SELECT
    U.NOMBRE AS NombreUsuario,
    E.Modelo AS ModeloEquipo,
    T.Nombre AS NombreTecnico,
    R.ReparacionID,
    R.FechaSolicitud,
    R.Estado,
    A.FechaAsignacion
FROM USUARIOS U
INNER JOIN Equipos E
    ON U.USUARIOID = E.UsuarioID
INNER JOIN Reparaciones R
    ON E.EquipoID = R.EquipoID
INNER JOIN Asignaciones A
    ON R.ReparacionID = A.ReparacionID
INNER JOIN Tecnicos T
    ON A.TecnicoID = T.TecnicoID
ORDER BY U.NOMBRE;

-- El objetivo es generar un informe que identifique el nombre del usuario, el modelo de su equipo, el técnico responsable, la fecha de solicitud, la fecha de asignación y el estado de la reparación.
-- La instrucción INNER JOIN permite combinar la información de diferentes tablas utilizando sus claves relacionadas.


-- 4.2 Estadística de carga de trabajo

USE SISTEMAREPARACIONES;
GO

SELECT
    T.TecnicoID,
    T.Nombre AS NombreTecnico,
    T.Especialidad,
    COUNT(A.ReparacionID) AS TotalReparaciones
FROM Tecnicos T
LEFT JOIN Asignaciones A
    ON T.TecnicoID = A.TecnicoID
GROUP BY
    T.TecnicoID,
    T.Nombre,
    T.Especialidad
ORDER BY TotalReparaciones DESC;

-- 4.3 Filtro de Seguridad

USE SISTEMAREPARACIONES;
GO

DECLARE @Modelo VARCHAR(50);
SET @Modelo = 'HONOR Magic 8 Pro';

SELECT
    E.EquipoID,
    E.TipoEquipo,
    E.Modelo,
    U.NOMBRE AS NombreUsuario,
    R.ReparacionID,
    R.FechaSolicitud,
    R.Estado
FROM Equipos E
INNER JOIN USUARIOS U
    ON E.UsuarioID = U.USUARIOID
INNER JOIN Reparaciones R
    ON E.EquipoID = R.EquipoID
WHERE E.Modelo = @Modelo
  AND R.FechaSolicitud >= DATEADD(MONTH, -1,
                                  CAST(GETDATE() AS DATE))
  AND R.FechaSolicitud <= CAST(GETDATE() AS DATE)
ORDER BY R.FechaSolicitud DESC;

-- Esta consulta calcula la cantidad de reparaciones asignadas a cada técnico.
-- La función COUNT() contabiliza las asignaciones, mientras que GROUP BY organiza los resultados por técnico y especialidad.
-- Se utiliza LEFT JOIN para incluir también a los técnicos que no tienen reparaciones asignadas.
-- Con ORDER BY, se presentan los resultados desde el técnico con mayor cantidad de asignaciones hasta el de menor cantidad.

-- FIN DEL PROYECTO


