/*
Integrantes da SeniorSmart

Andressa Vitória Regina Santos - RM93995
Bianca Barrancos Teixeira - RM92831
Gabriel Ferla Martins dos Anjos - RM93344
Gerson dos Reis de Melo - RM96210
Jefferson de Andrade Chaves - RM96236
*/

SET SERVEROUTPUT ON;
SET VERIFY OFF;

-- Packages

-- Cabecalho

CREATE OR REPLACE PACKAGE PCT_PLANO_ANUAL
AS
    FUNCTION FUNC_CALCULAR_DESCONTO_PLANO_ANUAL(V_CD_PLANO IN NUMBER, PERCENTUAL_DESCONTO IN NUMBER)
        RETURN NUMBER;
END PCT_PLANO_ANUAL;

CREATE OR REPLACE PACKAGE PCT_USUARIO
AS
    FUNCTION FUNC_CALCULA_IDADE(V_CD_USUARIO IN NUMBER)
        RETURN NUMBER;
    PROCEDURE relatorio_usuarios_por_plano;
END PCT_USUARIO;

CREATE OR REPLACE PACKAGE PCT_PLANO_MENSAL
AS
    PROCEDURE relatorio_pagamentos_mensais;
END PCT_PLANO_MENSAL;

-- Body

CREATE OR REPLACE PACKAGE BODY PCT_PLANO_ANUAL
AS
    FUNCTION FUNC_CALCULAR_DESCONTO_PLANO_ANUAL(V_CD_PLANO IN NUMBER, PERCENTUAL_DESCONTO IN NUMBER)
        RETURN NUMBER
        IS
            VALOR_COM_DESCONTO NUMBER(10,2);
            V_VALOR_PLANO NUMBER(10,2);
            ERR_CODE NUMBER(5);
            ERR_MSG VARCHAR2(100);
            V_DATE_ERR DATE := SYSDATE;
            
            NULL_EXCEPTION EXCEPTION;
            PRAGMA EXCEPTION_INIT(NULL_EXCEPTION, -20001);
        BEGIN
            SELECT VL_PLANO_ANUAL INTO V_VALOR_PLANO FROM T_SS_PLANO
            WHERE CD_PLANO = V_CD_PLANO;
            
            IF V_VALOR_PLANO IS NULL THEN
                ERR_CODE := -20001;
                RAISE NULL_EXCEPTION;
            END IF;
            
            VALOR_COM_DESCONTO := V_VALOR_PLANO * (1 - (PERCENTUAL_DESCONTO / 100));
            RETURN VALOR_COM_DESCONTO;
        EXCEPTION 
            WHEN NULL_EXCEPTION THEN
                ERR_MSG := 'O valor do plano anual está nulo';
                
                INSERT INTO T_SS_ERRO(CD_ERRO, NM_ERRO, DT_OCORRENCIA, USUARIO)
                VALUES(ERR_CODE, ERR_MSG, V_DATE_ERR, USER);
                COMMIT;
                RETURN NULL;
                
            WHEN OTHERS THEN
                ERR_CODE := SQLCODE;
                ERR_MSG := SUBSTR(SQLERRM, 1, 100);
                
                INSERT INTO T_SS_ERRO(CD_ERRO, NM_ERRO, DT_OCORRENCIA, USUARIO)
                VALUES (ERR_CODE, ERR_MSG, V_DATE_ERR, USER);
                COMMIT;
                RETURN NULL;
        END FUNC_CALCULAR_DESCONTO_PLANO_ANUAL;
END PCT_PLANO_ANUAL;

-- Fazendo o package funcionar

DECLARE
    V_CD_PLANO NUMBER(2) := &CODIGO_DO_PLANO;
    V_PERCENTUAL_DE_DESCONTO NUMBER(2) := &PERCENTUAL_DE_DESCONTO;
BEGIN
    DBMS_OUTPUT.PUT_LINE(PCT_PLANO_ANUAL.FUNC_CALCULAR_DESCONTO_PLANO_ANUAL(V_CD_PLANO, V_PERCENTUAL_DE_DESCONTO));
END;

CREATE OR REPLACE PACKAGE BODY PCT_USUARIO
AS
    FUNCTION FUNC_CALCULA_IDADE(V_CD_USUARIO IN NUMBER)
        RETURN NUMBER
        IS
            IDADE NUMBER(3);
            ERR_CODE NUMBER(5);
            ERR_MSG VARCHAR2(100);
            V_DATE_ERR DATE := SYSDATE;
        BEGIN
            SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, DT_NASCIMENTO) / 12) INTO IDADE FROM T_SS_USUARIO
            WHERE CD_USUARIO = V_CD_USUARIO;
        
            RETURN IDADE;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            ERR_CODE := SQLCODE;
            ERR_MSG := SUBSTR(SQLERRM, 1, 100);
        
            INSERT INTO T_SS_ERRO(CD_ERRO, NM_ERRO, DT_OCORRENCIA, USUARIO)
            VALUES (ERR_CODE, ERR_MSG, V_DATE_ERR, USER);
            COMMIT;
            RETURN NULL;

            WHEN OTHERS THEN
                ERR_CODE := SQLCODE;
                ERR_MSG := SUBSTR(SQLERRM, 1, 100);
            
                INSERT INTO T_SS_ERRO(CD_ERRO, NM_ERRO, DT_OCORRENCIA, USUARIO)
                VALUES(ERR_CODE, ERR_MSG, V_DATE_ERR, USER);
                COMMIT;
                RETURN NULL;
    END FUNC_CALCULA_IDADE;
    PROCEDURE relatorio_usuarios_por_plano
        IS
            ERR_CODE NUMBER(5);
            ERR_MSG VARCHAR2(100);
            V_DATE_ERR DATE := SYSDATE;
            V_ID_USUARIO NUMBER(2);
            
            IDADE_EXCEPTION EXCEPTION;
            PRAGMA EXCEPTION_INIT(IDADE_EXCEPTION, -20002);
            
            CURSOR c_relatorio IS 
            SELECT p.DS_PLANO, u.NM_USUARIO, u.DT_NASCIMENTO, u.CD_USUARIO FROM T_SS_PLANO p
            JOIN T_SS_USUARIO u ON p.CD_PLANO = u.CD_PLANO
            ORDER BY p.DS_PLANO, u.NM_USUARIO;
        BEGIN
            FOR rec IN c_relatorio LOOP
                V_ID_USUARIO := rec.CD_USUARIO;
                
                IF FUNC_CALCULA_IDADE(V_ID_USUARIO) >= 18 THEN
                    DBMS_OUTPUT.PUT_LINE('Plano: ' || rec.DS_PLANO || ', Usuário: ' || rec.NM_USUARIO || ', Idade: '|| FUNC_CALCULA_IDADE(V_ID_USUARIO));
                ELSE
                    ERR_CODE := -20002;
                    RAISE IDADE_EXCEPTION;
                END IF;
            END LOOP;
        EXCEPTION
            WHEN IDADE_EXCEPTION THEN
                ERR_MSG := 'Idade inválida para o usuário';
                
                INSERT INTO T_SS_ERRO(CD_ERRO, NM_ERRO, DT_OCORRENCIA, USUARIO)
                VALUES(ERR_CODE, ERR_MSG, V_DATE_ERR, USER);
                COMMIT;
            WHEN OTHERS THEN
                ERR_CODE := SQLCODE;
                ERR_MSG := SUBSTR(SQLERRM, 1, 100);
                
                INSERT INTO T_SS_ERRO(CD_ERRO, NM_ERRO, DT_OCORRENCIA, USUARIO)
                VALUES(ERR_CODE, ERR_MSG, V_DATE_ERR, USER);
                COMMIT;
    END relatorio_usuarios_por_plano;
END PCT_USUARIO;

-- Fazendo o package funcionar

DECLARE
    V_CD_USUAIO NUMBER(2) := &CODIGO_DO_USUARIO;
BEGIN
    DBMS_OUTPUT.PUT_LINE(PCT_USUARIO.FUNC_CALCULA_IDADE(V_CD_USUAIO));
END;

BEGIN
    PCT_USUARIO.relatorio_usuarios_por_plano;
END;

CREATE OR REPLACE PACKAGE BODY PCT_PLANO_MENSAL
AS
    PROCEDURE relatorio_pagamentos_mensais
        IS
            ERR_CODE NUMBER(5);
            ERR_MSG VARCHAR2(100);
            V_DATE_ERR DATE := SYSDATE;
            PLANO_EXCEPTION EXCEPTION;
            PRAGMA EXCEPTION_INIT(PLANO_EXCEPTION, -20003);
            
            CURSOR c_relatorio IS
            SELECT u.NM_USUARIO, p.VL_PLANO_MENSAL FROM T_SS_USUARIO u
            JOIN T_SS_PLANO p ON u.CD_PLANO = p.CD_PLANO;
        BEGIN
            FOR rec IN c_relatorio LOOP
                BEGIN
                    IF rec.VL_PLANO_MENSAL IS NULL THEN
                        ERR_CODE := -20003;
                        RAISE PLANO_EXCEPTION;
                    END IF;
                
                    DBMS_OUTPUT.PUT_LINE('Usuário: ' || rec.NM_USUARIO || ', Pagamento mensal: R$' || rec.VL_PLANO_MENSAL);
                EXCEPTION
                    WHEN PLANO_EXCEPTION THEN
                        ERR_MSG := 'O plano mensal está nulo';
                        
                        INSERT INTO T_SS_ERRO(CD_ERRO, NM_ERRO, DT_OCORRENCIA, USUARIO)
                        VALUES(ERR_CODE, ERR_MSG, V_DATE_ERR, USER);
                        COMMIT;
                END;
            END LOOP;
        EXCEPTION
            WHEN OTHERS THEN
                ERR_CODE := SQLCODE;
                ERR_MSG := SUBSTR(SQLERRM, 1, 100);
                INSERT INTO T_SS_ERRO(CD_ERRO, NM_ERRO, DT_OCORRENCIA, USUARIO)
                VALUES(ERR_CODE, ERR_MSG, V_DATE_ERR, USER);
                COMMIT;
    END relatorio_pagamentos_mensais;
END PCT_PLANO_MENSAL;

-- Fazendo o package funcionar

BEGIN
    PCT_PLANO_MENSAL.relatorio_pagamentos_mensais;
END;

-- Triggers

-- Audite a operação de INSERT em uma tabela

CREATE OR REPLACE TRIGGER trg_monitorar_insert
AFTER INSERT ON T_SS_FORMA_DE_PAGAMENTO
FOR EACH ROW
DECLARE
    ERR_CODE NUMBER(5);
    ERR_MSG VARCHAR2(100);
    V_DATE_ERR DATE := SYSDATE;
BEGIN
    INSERT INTO T_SS_LOG_INSERT(DT_INSERT, CD_CARTAO)
    VALUES (SYSDATE, :NEW.CD_CARTAO);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ERR_CODE := SQLCODE;
        ERR_MSG := SUBSTR(SQLERRM, 1, 100);
        INSERT INTO T_SS_ERRO(CD_ERRO, NM_ERRO, DT_OCORRENCIA, USUARIO)
        VALUES(ERR_CODE, ERR_MSG, V_DATE_ERR, USER);
END;

-- Testar a trigger
BEGIN
    INSERT INTO T_SS_FORMA_DE_PAGAMENTO VALUES(6, 2, 'Bianca K', '6225 6157 4056 8440', 
    TO_DATE('02/10/2020', 'DD/MM/YYYY'), '221');
    COMMIT;
END;

-- Monitorar atualização de valores (requisito decidido pelo grupo)

CREATE OR REPLACE TRIGGER trg_monitorar_atualizacao
AFTER UPDATE ON T_SS_USUARIO 
FOR EACH ROW
DECLARE
    ERR_CODE NUMBER(5);
    ERR_MSG VARCHAR2(100);
    V_DATE_ERR DATE := SYSDATE;
BEGIN 
    INSERT INTO T_SS_LOG_ATUALIZACAO(CD_USUARIO, DT_ATUALIZACAO, VALOR_ANTIGO, VALOR_NOVO)
    VALUES (:OLD.CD_USUARIO, SYSDATE, :OLD.NR_TELEFONE, :NEW.NR_TELEFONE);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ERR_CODE := SQLCODE;
        ERR_MSG := SUBSTR(SQLERRM, 1, 100);
        INSERT INTO T_SS_ERRO(CD_ERRO, NM_ERRO, DT_OCORRENCIA, USUARIO)
        VALUES(ERR_CODE, ERR_MSG, V_DATE_ERR, USER);
END;

-- BLOCO ANONIMO PARA TESTAR A TRIGGER
BEGIN
    UPDATE T_SS_USUARIO SET NR_TELEFONE='069922612250' WHERE CD_USUARIO = 1;
    COMMIT;
END;
