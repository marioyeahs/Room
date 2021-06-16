CREATE PROCEDURAL LANGUAGE plpgsql;
--------------------------------------------------------
--------------PROCEDIMENTOS ALMACENADOS-----------------
----------------------INSERTAR------------------------
---------------------1.-------------------------------
-------------insertar puja-----------------------------
CREATE OR REPLACE PROCEDURE aniadir_puja(id integer,hora time, monto integer, cliente_id integer, obra_id integer)
LANGUAGE SQL
AS $$
INSERT INTO subastas_puja VALUES(id,hora,monto,cliente_id,obra_id);
$$;
---------------------2.-------------------------------
-------------insertar artista-----------------------------
CREATE OR REPLACE PROCEDURE aniadir_artista(id integer,nombre varchar, apellidos varchar, nacionalidad varchar,corriente varchar)
LANGUAGE SQL
AS $$
INSERT INTO subastas_artista VALUES(id,nombre,apellidos,nacionalidad,corriente);
$$;
---------------------3.-------------------------------
-------------insertar obra-----------------------------
CREATE OR REPLACE PROCEDURE aniadir_obra(id integer,artista_id integer, duenio_id integer, nombre varchar)
LANGUAGE SQL
AS $$
INSERT INTO subastas_obra VALUES(id,artista_id,duenio_id,nombre);
$$;
--------------------------------------------------------
---------------------4.-------------------------------
-------------insertar sala-----------------------------
CREATE OR REPLACE PROCEDURE aniadir_sala(id integer,apertura date, costo_inicial integer, articulo_id integer, fecha_cierre date, hora_cierre time)
LANGUAGE SQL
AS $$
INSERT INTO subastas_sala VALUES(id,apertura,costo_inicial,articulo_id,fecha_cierre,hora_cierre);
$$;

--------------------------------------------------------
---------------------5.-------------------------------
-------------insertar usuario-----------------------------
CREATE OR REPLACE PROCEDURE aniadir_usuario(id integer,nombre varchar,apellido_paterno varchar,apellido_materno varchar,correo varchar,celular integer,direccion varchar,colonia varchar,cp_zip integer)
LANGUAGE SQL
AS $$
INSERT INTO subastas_usuario VALUES(id,nombre,apellido_paterno,apellido_materno,correo,celular,direccion,colonia);
$$;

---------------------6.-------------------------------
-------------insertar comprador-----------------------------
CREATE OR REPLACE PROCEDURE aniadir_comprador(id integer,usuario_comprador integer)
LANGUAGE SQL
AS $$
INSERT INTO subastas_comprador VALUES(id,usuario_comprador);
$$;

---------------------7.-------------------------------
-------------insertar vendedor-----------------------------
CREATE OR REPLACE PROCEDURE aniadir_vendedor(id integer,usuario_vendedor integer)
LANGUAGE SQL
AS $$
INSERT INTO subastas_vendedor VALUES(id,usuario_vendedor);
$$;

---------------------ELIMINAR-------------------------------
---------------------8.-------------------------------
-------------eliminar vendedor-----------------------------
CREATE OR REPLACE PROCEDURE quitar_vendedor(id integer)
LANGUAGE SQL
AS $$
DELETE FROM subastas_vendedor WHERE id=id;
$$;

---------------------9.-------------------------------
-------------eliminar comprador-----------------------------
CREATE OR REPLACE PROCEDURE quitar_comprador(id integer)
LANGUAGE SQL
AS $$
DELETE FROM subastas_comprador WHERE id=id;
$$;

---------------------10.-------------------------------
-------------eliminar usuario-----------------------------
CREATE OR REPLACE PROCEDURE quitar_usuario(id integer)
LANGUAGE SQL
AS $$
DELETE FROM AUTH_USER WHERE id=id;
$$;

---------------------11.-------------------------------
-------------eliminar obra-----------------------------
CREATE OR REPLACE PROCEDURE quitar_obra(id integer)
LANGUAGE SQL
AS $$
DELETE FROM subastas_obra WHERE id=id;
$$;
---------------------12.-------------------------------
-------------eliminar SALA-----------------------------
CREATE OR REPLACE PROCEDURE quitar_sala(id integer)
LANGUAGE SQL
AS $$
DELETE FROM subastas_sala WHERE id=id;
$$;
---------------------13.-------------------------------
-------------eliminar artista-----------------------------
CREATE OR REPLACE PROCEDURE quitar_artista(id integer)
LANGUAGE SQL
AS $$
DELETE FROM subastas_artista WHERE id=id;
$$;
---------------------14.-------------------------------
-------------eliminar puja-----------------------------
CREATE OR REPLACE PROCEDURE quitar_puja(id integer)
LANGUAGE SQL
AS $$
DELETE FROM subastas_puja WHERE id=id;
$$;
---------------------ACTUALIZAR-------------------------------
---------------------15.-------------------------------
-------------actuzalizar artista-----------------------------
CREATE OR REPLACE PROCEDURE actualizar_artista(id integer,nombre varchar, apellidos varchar, nacionalidad varchar,corriente varchar)
LANGUAGE SQL
AS $$
	UPDATE subastas_artista
	SET nombre = nombre,
    apellidos = apellidos,
    nacionalidad=nacionalidad,
	corriente=corriente
	WHERE id=id;
$$;
---------------------16.-------------------------------
-------------actuzalizar obra-----------------------------
CREATE OR REPLACE PROCEDURE actualizar_obra(id integer,artista_id integer, duenio_id integer, nombre varchar)
LANGUAGE SQL
AS $$
	UPDATE subastas_obra
	SET artista_id = artista_id,
    duenio_id = duenio_id,
    nombre=nombre
	WHERE id=id;
$$;
---------------------17.-------------------------------
-------------actuzalizar puja-----------------------------
CREATE OR REPLACE PROCEDURE actualizar_puja(id integer,hora time, monto integer, cliente_id integer,obra_id integer)
LANGUAGE SQL
AS $$
	UPDATE subastas_puja
	SET hora = hora,
    monto = monto,
    cliente_id=cliente_id,
	obra_id=obra_id
	WHERE id=id;
$$;
---------------------18.-------------------------------
-------------actuzalizar sala-----------------------------
CREATE OR REPLACE PROCEDURE actualizar_sala(id integer,apertura date, costo_inicial integer, articulo_id integer,fecha_cierre date, hora_cierre time)
LANGUAGE SQL
AS $$
	UPDATE subastas_sala
	SET apertura = apertura,
    costo_inicial = costo_inicial,
    articulo_id=articulo_id,
	fecha_cierre=fecha_cierre
	WHERE id=id;
$$;

------------------------------------------------------------
----------------------CONSULTAS SIMPLES----------------------
---------------------------------------------------------
CREATE PROCEDURE muestra_artistas (id integer)
LANGUAGE SQL
AS $$
SELECT * FROM subastas_artista WHERE id=id;
$$;
------------------------------------------------------------
CREATE PROCEDURE muestra_salas (id integer)
LANGUAGE SQL
AS $$
SELECT * FROM subastas_sala WHERE id=id;
$$;
------------------------------------------------------------
CREATE PROCEDURE muestra_pujas (id integer)
LANGUAGE SQL
AS $$
SELECT * FROM subastas_puja WHERE id=id;
$$;
------------------------------------------------------------
CREATE PROCEDURE muestra_usuarios (id integer)
LANGUAGE SQL
AS $$
SELECT * FROM subastas_usuario WHERE id=id;
$$;
------------------------------------------------------------
CREATE PROCEDURE muestra_obras (id integer)
LANGUAGE SQL
AS $$
SELECT * FROM subastas_obra WHERE id=id;
$$;
------------------------------------------------------------
----------------------CONSULTAS MULTITABLA----------------------
---------------------------------------------------------
CREATE OR REPLACE PROCEDURE obra_puja ( obra_nombre varchar, puja_obra varchar)
LANGUAGE SQL
AS $$
SELECT subastas_obra.nombre, subastas_puja.monto FROM
subastas_obra INNER JOIN subastas_puja ON obra_nombre = puja_obra;
$$;
---------------------------------------------------------
CREATE PROCEDURE
Room=# CREATE PROCEDURE artista_sala ( articulo_sala varchar,sala_artista varchar)
LANGUAGE SQL
AS $$
SELECT subastas_artista.nombre, subastas_sala.id FROM subastas_artista
INNER JOIN subastas_sala ON articulo_sala = sala_artista;
$$;
------------------------------------------------------------
----------------------CONSULTAS DE RESUMEN-------------------------
---------------------------------------------------------
SELECT SUM(monto) from subastas_puja where obra_id=3;
---------------------------------------------------------
SELECT cliente_id,AVG(monto) from subastas_puja where cliente_id=8 group by cliente_id;
------------------------------------------------------------
SELECT articulo_id,COUNT(monto) FROM subastas_puja,subastas_sala 
WHERE subastas_puja.id=subastas_sala.articulo_id
GROUP BY articulo_id;
------------------------------------------------------------
----------------------SUBCONSULTAS-------------------------
---------------------------------------------------------
--1.- articulos en subastas con costo inical mayor al promedio de las pujas hechas
SELECT ARTICULO_ID FROM SUBASTAS_SALA WHERE COSTO_INICIAL<(SELECT sum(MONTO) FROM SUBASTAS_PUJA);

--2. pujas MENORES AL PROMEDIO DE LAS pujas HECHAS 
SELECT id FROM SUBASTAS_PUJA 
WHERE MONTO<(SELECT AVG(MONTO) FROM SUBASTAS_PUJA)

--3. Usuarios que tengan el mismo nombre que los artistas LEO Y DIEGO
SELECT nombre FROM SUBASTAS_USUARIO 
WHERE nombre IN (SELECT apellidos FROM SUBASTAS_ARTISTA WHERE NOMBRE='Leo' AND nombre='Diego')

------------------------------------------------------
------------------------VISTAS---------------------------
------------------------------------------------------

--1	 VER LA COLONIA DE LOS USUARIOS
CREATE VIEW muestra_COLONIA_DE_DUENIOS AS
	SELECT subastas_usuario.apellido_paterno,COLONIA,SUBASTAS_OBRA.NOMBRE FROM SUBASTAS_USUARIO, SUBASTAS_OBRA
	WHERE DUENIO_ID=SUBASTAS_USUARIO.ID;

SELECT * FROM MUESTRA_colonia_de_DUENIOS;

--2	VER CORRIENTE DE LAS OBRAS
CREATE VIEW MUESTRA_CORRIENTE_DE_OBRAS AS
	SELECT CORRIENTE,SUBASTAS_OBRA.NOMBRE FROM SUBASTAS_ARTISTA,SUBASTAS_OBRA
	WHERE SUBASTAS_ARTISTA.ID=ARTISTA_ID;
	
SELECT * FROM MUESTRA_CORRIENTE_DE_OBRAS;

--3	VER OBRAS DE LOS ARTISTAS
CREATE VIEW MUESTRA_OBRAS_DE_ARTISTAS AS
	SELECT SUBASTAS_ARTISTA.NOMBRE, SUBASTAS_OBRA.NOMBRE FROM SUBASTAS_ARTISTA, SUBASTAS_OBRA
	WHERE SUBASTAS_ARTISTA.ID=ARTISTA_ID;

SELECT * FROM MUESTRA_OBRAS_DE_ARTISTAS;

--4	VER DUENIOS DE OBRAS EN SALAS
CREATE VIEW MUESTRA_DUENIOS_DE_OBRAS AS
	SELECT SUBASTAS_USUARIO.APELLIDO_PATERNO,SUBASTAS_OBRA.NOMBRE FROM SUBASTAS_USUARIO, SUBASTAS_OBRA
	WHERE SUBASTAS_USUARIO.ID=DUENIO_ID;

SELECT * FROM MUESTRA_DUENIOS_DE_OBRAS;

--5	OBRAS CON PUJAS MAYORES A MIL
CREATE VIEW OBRAS_PUJAS_MAYORES_1000 AS
	SELECT SUBASTAS_SALA.ARTICULO_ID, SUBASTAS_PUJA.MONTO FROM SUBASTAS_SALA,SUBASTAS_PUJA
	WHERE ARTICULO_ID=OBRA_ID AND MONTO>1000;
	
SELECT * FROM OBRAS_PUJAS_MAYORES_1000;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-----------------------------DISPARADORES---------------------------
------------------------------------------------------------------------------------------------
--ES NECESARIO CREAR SP PARA QUE SE DISPAREN LOS TRIGGERS
--triggers se ejecutan antes o despues de un INSERT,DELETE,UPDATE en una tabla
--el trigger ejecuta un SP(funcion) cuando el disparador se active, no debe recibir argumentos y retornar TRIGGER
--un mismo SP(funcion) puede ejecutarse por diferentes disparadores
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- 1, despues de registrar USER en django, INSERTA en ambas tablas, de compador y vendedor
--funcion que va dentro del trigger
CREATE FUNCTION SP_FuncTrigger_InsertarCompradorVendedor() RETURNS TRIGGER
AS
$$ 
BEGIN
	INSERT INTO subastas_comprador VALUES(new.id,new.id);
	INSERT INTO subastas_vendedor VALUES(new.id,new.id);
--SIEMPRE RETURN NEW, REALIZA LA ACCION CON LA NUEVA INFORMACIÓN
RETURN NEW;
END
$$
LANGUAGE plpgsql;
--trigger, se dispara después de aniadir una fila a la tabla auth_user
CREATE TRIGGER TR_InsertarCompradorVendedor AFTER INSERT ON auth_user
FOR EACH ROW
	EXECUTE PROCEDURE SP_FuncTrigger_InsertarCompradorVendedor()
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--2, antes de eliminar el usuario, borrar su id de la tabla de compradores y vendedores
CREATE FUNCTION SP_FuncTrigger_EliminarCompradorVendedor() RETURNS TRIGGER 
AS
$$
BEGIN
	DELETE FROM subastas_comprador WHERE (id=old.id);
	DELETE FROM subastas_vendedor WHERE (id=old.id);
RETURN NEW;
END
$$
LANGUAGE plpgsql;
--TRIGGER
CREATE TRIGGER TR_EliminarCompradorVendedor BEFORE DELETE ON auth_user
FOR EACH ROW
	EXECUTE PROCEDURE SP_FuncTrigger_EliminarCompradorVendedor()

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-----------------------------TRANSACCIONES------------------------------------------------------
------------------------------------------------------------------------------------------------
---1.-
BEGIN;
	CALL eliminar_artista(5);
	ROLLBACK;
	SELECT * FROM subastas_artista;
COMMIT;
--2.-
BEGIN;
	CALL quitar_puja(30);
	ROLLBACK;
	SELECT * FROM subastas_puja;
COMMIT;
--3.-
BEGIN;
	CALL quitar_obra(8);
	ROLLBACK;
	SELECT * FROM subastas_obra;
COMMIT;




------------------------------------------------------------------------
---------------------FUNCIONES------------------------------------------
------------------------------------------------------------------------
--SU RESPECTIVA FUNCION
CREATE OR REPLACE FUNCTION inserta_artista (id integer,nombre varchar, apellidos varchar, nacionalidad varchar,corriente varchar)
RETURNS void
AS $$
CALL aniadir_artista(id,nombre, apellidos, nacionalidad, corriente);
$$
LANGUAGE SQL
--SU RESPECTIVA FUNCION
CREATE OR REPLACE FUNCTION inserta_puja (id integer,hora time, monto integer, cliente_id integer, obra_id integer)
RETURNS void
AS $$
CALL aniadir_puja(id,hora, monto, cliente_id, obra_id);
$$
LANGUAGE SQL
--SU RESPECTIVA FUNCION
CREATE OR REPLACE FUNCTION inserta_obra (id integer,artista_id integer, duenio_id integer, nombre varchar)
RETURNS void
AS $$
CALL aniadir_obra(id,artista_id,duenio_id,nombre);
$$
LANGUAGE SQL
--SU RESPECTIVA FUNCION
CREATE OR REPLACE FUNCTION inserta_sala (id integer,apertura date, costo_inicial integer, articulo_id integer, fecha_cierre date, hora_cierre time)
RETURNS void
AS $$
CALL aniadir_sala(id,apertura,costo_inicial,articulo_id,fecha_cierre,hora_cierre);
$$
LANGUAGE SQL
--SU RESPECTIVA FUNCION
CREATE OR REPLACE FUNCTION inserta_usuario(id integer,nombre varchar,apellido_paterno varchar,apellido_materno varchar,correo varchar,celular integer,direccion varchar,colonia varchar,cp_zip integer)
RETURNS void
AS $$
CALL aniadir_usuario(id,nombre,apellido_paterno,apellido_materno,correo,celular,direccion,colonia);
$$
LANGUAGE SQL
--SU RESPECTIVA FUNCION
CREATE OR REPLACE FUNCTION inserta_comprador(id integer,usuario_comprador integer)
RETURNS void
AS $$
CALL aniadir_comprador(id,usuario_comprador);
$$
LANGUAGE SQL
--SU RESPECTIVA FUNCION
CREATE OR REPLACE FUNCTION inserta_vendedor(id integer,usuario_vendedor integer)
RETURNS void
AS $$
CALL aniadir_vendedor(id,usuario_vendedor);
$$
LANGUAGE SQL
--SU RESPECTIVA FUNCION
CREATE OR REPLACE FUNCTION eliminar_vendedor(id integer)
RETURNS void
AS $$
CALL quitar_vendedor(id);
$$
LANGUAGE SQL
--SU RESPECTIVA FUNCION
CREATE OR REPLACE FUNCTION eliminar_comprador(id integer)
RETURNS void
AS $$
CALL quitar_compador(id);
$$
LANGUAGE SQL
--SU RESPECTIVA FUNCION
CREATE OR REPLACE FUNCTION eliminar_usuario(id integer)
RETURNS void
AS $$
CALL quitar_usuario(id);
$$
LANGUAGE SQL

select * from subastas_sala;
