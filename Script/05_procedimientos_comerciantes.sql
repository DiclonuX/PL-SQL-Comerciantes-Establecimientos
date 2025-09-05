-- Archivo: 05_procedimientos_comerciantes.sql
-- Fecha: 2025/09/05
-- Nota: Se realiza validaciones simples para correo como hacer chequeo básico de @ y despues ver si el resultaedo es: 0 éxito, -1 error.

CREATE OR REPLACE PROCEDURE SP_CREAR_COMERCIANTE(
    P_NOMBRE IN VARCHAR2,
    P_DEPARTAMENTO IN VARCHAR2,
    P_MUNICIPIO IN VARCHAR2,
    P_TELEFONO IN VARCHAR2 DEFAULT NULL,
    P_CORREO IN VARCHAR2 DEFAULT NULL,
    P_ESTADO IN VARCHAR2 DEFAULT 'ACTIVO',
    P_RESULTADO OUT NUMBER,
    P_MENSAJE OUT VARCHAR2
) AS
BEGIN
    P_RESULTADO := 0;
    P_MENSAJE := 'OK';

    -- Validaciones
    IF P_NOMBRE IS NULL OR P_DEPARTAMENTO IS NULL OR P_MUNICIPIO IS NULL THEN
        P_RESULTADO := -1;
        P_MENSAJE := 'Campos obligatorios no pueden ser nulos';
        RETURN;
    END IF;

    IF P_CORREO IS NOT NULL AND (INSTR(P_CORREO, '@') < 2 OR INSTR(P_CORREO, '.', INSTR(P_CORREO, '@')) < 1) THEN
        P_RESULTADO := -1;
        P_MENSAJE := 'Formato de correo inválido';
        RETURN;
    END IF;

    IF P_ESTADO NOT IN ('ACTIVO', 'INACTIVO', 'SUSPENDIDO') THEN
        P_RESULTADO := -1;
        P_MENSAJE := 'Estado inválido';
        RETURN;
    END IF;

    INSERT INTO COMERCIANTES (NOMBRE, DEPARTAMENTO, MUNICIPIO, TELEFONO, CORREO, FECHA_REGISTRO, ESTADO)
    VALUES (P_NOMBRE, P_DEPARTAMENTO, P_MUNICIPIO, P_TELEFONO, P_CORREO, SYSDATE, P_ESTADO);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        P_RESULTADO := -1;
        P_MENSAJE := SQLERRM;
        ROLLBACK;
END;
/

CREATE OR REPLACE PROCEDURE SP_ACTUALIZAR_COMERCIANTE(
    P_ID IN NUMBER,
    P_NOMBRE IN VARCHAR2,
    P_DEPARTAMENTO IN VARCHAR2,
    P_MUNICIPIO IN VARCHAR2,
    P_TELEFONO IN VARCHAR2 DEFAULT NULL,
    P_CORREO IN VARCHAR2 DEFAULT NULL,
    P_RESULTADO OUT NUMBER,
    P_MENSAJE OUT VARCHAR2
) AS
BEGIN
    P_RESULTADO := 0;
    P_MENSAJE := 'OK';

    -- Validaciones similares
    IF P_NOMBRE IS NULL OR P_DEPARTAMENTO IS NULL OR P_MUNICIPIO IS NULL THEN
        P_RESULTADO := -1;
        P_MENSAJE := 'Campos obligatorios no pueden ser nulos';
        RETURN;
    END IF;

    IF P_CORREO IS NOT NULL AND (INSTR(P_CORREO, '@') < 2 OR INSTR(P_CORREO, '.', INSTR(P_CORREO, '@')) < 1) THEN
        P_RESULTADO := -1;
        P_MENSAJE := 'Formato de correo inválido';
        RETURN;
    END IF;

    UPDATE COMERCIANTES
    SET NOMBRE = P_NOMBRE,
        DEPARTAMENTO = P_DEPARTAMENTO,
        MUNICIPIO = P_MUNICIPIO,
        TELEFONO = P_TELEFONO,
        CORREO = P_CORREO
    WHERE ID = P_ID;

    IF SQL%ROWCOUNT = 0 THEN
        P_RESULTADO := -1;
        P_MENSAJE := 'Comerciante no encontrado';
        RETURN;
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        P_RESULTADO := -1;
        P_MENSAJE := SQLERRM;
        ROLLBACK;
END;
/

CREATE OR REPLACE PROCEDURE SP_ELIMINAR_COMERCIANTE(
    P_ID IN NUMBER,
    P_RESULTADO OUT NUMBER,
    P_MENSAJE OUT VARCHAR2
) AS
BEGIN
    P_RESULTADO := 0;
    P_MENSAJE := 'OK';

    UPDATE COMERCIANTES
    SET ESTADO = 'INACTIVO'
    WHERE ID = P_ID;

    IF SQL%ROWCOUNT = 0 THEN
        P_RESULTADO := -1;
        P_MENSAJE := 'Comerciante no encontrado';
        RETURN;
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        P_RESULTADO := -1;
        P_MENSAJE := SQLERRM;
        ROLLBACK;
END;
/
