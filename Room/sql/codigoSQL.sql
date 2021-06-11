CREATE PROCEDURAL LANGUAGE plpgsql;
--------------------------------------------------------
--PROCEDIMENTOS ALMACENADOS
--------------------------------------------------------
CREATE OR REPLACE PROCEDURE aniadir_puja(id integer,hora time, monto integer, cliente_id integer, obra_id integer)
LANGUAGE SQL
AS $$
INSERT INTO subastas_puja VALUES(id,hora,monto,cliente_id,obra_id);
$$;
--SU RESPECTIVA FUNCION
CREATE OR REPLACE FUNCTION inserta_puja (id integer,hora time, monto integer, cliente_id integer, obra_id integer)
RETURNS void
AS $$
CALL aniadir_puja(id,hora, monto, cliente_id, obra_id);
$$
LANGUAGE SQL


--PROCEDIMIENTO PARA MOSTAR CORRIENTES DE LAS OBRAS(view)
CREATE OR REPLACE PROCEDURE muestra_corriente_de_obras()
LANGUAGE SQL
AS $$
SELECT * FROM MUESTRA_CORRIENTE_DE_OBRAS;
$$;
--SU RESPECTIVA FUNCION
CREATE OR REPLACE FUNCTION ver_corrientes()
RETURNS void
AS $$
CALL MUESTRA_CORRIENTE_DE_OBRAS();
$$
LANGUAGE SQL
DROP FUNCTION ver_corrientes()
------------------------------------------------------------
		
------------------------------------------------------------
--SUBCONSULTAS
---------------------------------------------------------
--1.- SUBASTAS CON COSTO INICIAL MENOR QUE LA SUMA DE TODAS LAS PUJAS
SELECT ARTICULO_ID FROM SUBASTAS_SALA 
WHERE COSTO_INICIAL<(SELECT SUM(MONTO) FROM SUBASTAS_PUJA)

--2. SUBASTAS MENORES AL PROMEDIO DE LAS SUBASTAS HECHAS 
SELECT * FROM SUBASTAS_PUJA 
WHERE MONTO<(SELECT AVG(MONTO) FROM SUBASTAS_PUJA)

--3. Usuarios que tengan el mismo nombre que los artistas LEO Y DIEGO
SELECT nombre FROM SUBASTAS_USUARIO 
WHERE nombre IN (SELECT apellidos FROM SUBASTAS_ARTISTA WHERE NOMBRE='Leo' AND nombre='diego')

--4. 
------------------------------------------------------
--VISTAS
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
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--DISPARADORES
------------------------------------------------------------------------------------------------
--ES NECESARIO CREAR SP PARA QUE SE DISPAREN LOS TRIGGERS
--triggers se ejecutan antes o despues de un INSERT,DELETE,UPDATE en una tabla
--el trigger ejecuta un SP(funcion) cuando el disparador se active, no debe recibir argumentos y retornar TRIGGER
--un mismo SP(funcion) puede ejecutarse por diferentes disparadores
------------------------------------------------------------------------------------------------
--3 triggers, uno para insertar, otro para eliminar y otro para actualizar
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






select * from auth_user;select * from subastas_comprador;
select * from subastas_vendedor;
