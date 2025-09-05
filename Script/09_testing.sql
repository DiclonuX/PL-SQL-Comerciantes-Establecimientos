-- Archivo: 09_testing.sql
-- Fecha: 2025/09/05
-- Nota: Probamos todos los script.

SET SERVEROUTPUT ON;

DECLARE
    V_RESULTADO NUMBER;
    V_MENSAJE VARCHAR2(200);
    V_CURSOR SYS_REFCURSOR;
    V_ID NUMBER;
    V_NOMBRE VARCHAR2(100);
    V_DEPARTAMENTO VARCHAR2(100);

BEGIN
    -- Probar creacion de comerciante valido
    SP_CREAR_COMERCIANTE('Test Comerciante', 'Test Dept', 'Test Mun', '123456', 'test@valid.com', 'ACTIVO', V_RESULTADO, V_MENSAJE);
    DBMS_OUTPUT.PUT_LINE('Creación válida: Resultado=' || V_RESULTADO || ', Mensaje=' || V_MENSAJE);

    -- Probar creacion con correo inválido
    SP_CREAR_COMERCIANTE('Invalid', 'Dept', 'Mun', NULL, 'invalidemail', 'ACTIVO', V_RESULTADO, V_MENSAJE);
    DBMS_OUTPUT.PUT_LINE('Creación inválida (correo): Resultado=' || V_RESULTADO || ', Mensaje=' || V_MENSAJE);

    -- Probar actualizacion
    SP_ACTUALIZAR_COMERCIANTE(1, 'Updated Name', 'Updated Dept', 'Updated Mun', NULL, NULL, V_RESULTADO, V_MENSAJE);
    DBMS_OUTPUT.PUT_LINE('Actualización: Resultado=' || V_RESULTADO || ', Mensaje=' || V_MENSAJE);

    -- Probar eliminacion logica
    SP_ELIMINAR_COMERCIANTE(2, V_RESULTADO, V_MENSAJE);
    DBMS_OUTPUT.PUT_LINE('Eliminación: Resultado=' || V_RESULTADO || ', Mensaje=' || V_MENSAJE);

    -- Probar creacion de establecimiento
    SP_CREAR_ESTABLECIMIENTO(1, 'Test Estab', 100000, 5, V_RESULTADO, V_MENSAJE);
    DBMS_OUTPUT.PUT_LINE('Creación estab: Resultado=' || V_RESULTADO || ', Mensaje=' || V_MENSAJE);

    -- Probar funcion listar establecimientos
    V_CURSOR := FN_ESTABLECIMIENTOS_COMERCIANTE(1);
    DBMS_OUTPUT.PUT_LINE('Establecimientos para ID 1: (simulado fetch)');

    -- Probar reporte
    V_CURSOR := FN_REPORTE_COMERCIANTES_ACTIVOS;
    DBMS_OUTPUT.PUT_LINE('Reporte activos: (simulado fetch)');

    -- Verificar triggers: Despues de inserts/updates
    SELECT ID INTO V_ID FROM COMERCIANTES WHERE NOMBRE = 'Updated Name';
    DBMS_OUTPUT.PUT_LINE('Trigger audit ok si fecha no nula para ID ' || V_ID);

END;
/
