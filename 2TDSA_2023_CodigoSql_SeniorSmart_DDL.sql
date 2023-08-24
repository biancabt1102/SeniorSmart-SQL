/*
Integrantes da SeniorSmart

Andressa Vitória Regina Santos - RM93995
Bianca Barrancos Teixeira - RM92831
Gabriel Ferla Martins dos Anjos - RM93344
Gerson dos Reis de Melo - RM96210
Jefferson de Andrade Chaves - RM96236
*/

-- DDL --

-- Drop table
/*
Drop table T_SS_USUARIO cascade constraints;
Drop table T_SS_PLANO cascade constraints;
Drop table T_SS_FORMA_DE_PAGAMENTO cascade constraints;
Drop table T_SS_PERGUNTAS cascade constraints;
Drop table T_SS_RESPOSTA cascade constraints;
Drop table T_SS_PERGUNTAS_USUARIO cascade constraints;
Drop table T_SS_ERRO cascade constraints;
Drop table T_SS_LOG_ATUALIZACAO cascade constraints;
*/

-- Create table
CREATE TABLE T_SS_USUARIO(
    CD_USUARIO NUMBER(5) NOT NULL,
    CD_PLANO NUMBER(5) NOT NULL,
    NM_USUARIO VARCHAR2(50) NOT NULL,
    DS_EMAIL VARCHAR2(40) NOT NULL,
    DS_SENHA VARCHAR2(10) NOT NULL,
    DT_NASCIMENTO DATE NOT NULL,
    NR_TELEFONE VARCHAR2(12) NOT NULL
);

ALTER TABLE T_SS_USUARIO
ADD CONSTRAINT PK_T_SS_USUARIO 
PRIMARY KEY(CD_USUARIO);

CREATE TABLE T_SS_PLANO(
    CD_PLANO NUMBER(5) NOT NULL,
    DS_PLANO CHAR(6) NOT NULL,
    VL_PLANO_MENSAL NUMBER(4,2),
    VL_PLANO_ANUAL NUMBER(5,2)
);

ALTER TABLE T_SS_PLANO
ADD CONSTRAINT PK_T_SS_PLANO
PRIMARY KEY (CD_PLANO);

CREATE TABLE T_SS_FORMA_DE_PAGAMENTO(
    CD_CARTAO NUMBER(5) NOT NULL,
    CD_PLANO NUMBER(5) NOT NULL,
    NM_CARTAO VARCHAR2(40) NOT NULL,
    NR_CARTAO VARCHAR(20) NOT NULL,
    DT_VENCIMENTO DATE NOT NULL,
    NR_CVV CHAR(3) NOT NULL
);

ALTER TABLE T_SS_FORMA_DE_PAGAMENTO
ADD CONSTRAINT PK_T_SS_FORMA_DE_PAGAMENTO
PRIMARY KEY (CD_CARTAO);

ALTER TABLE T_SS_FORMA_DE_PAGAMENTO
ADD CONSTRAINT UN_T_SS_FORMA_DE_PAGAMENTO
UNIQUE (NR_CVV);

CREATE TABLE T_SS_PERGUNTAS(
    CD_PERGUNTA NUMBER(5) NOT NULL,
    DS_PERGUNTA VARCHAR2(2049) NOT NULL
);

ALTER TABLE T_SS_PERGUNTAS
ADD CONSTRAINT PK_T_SS_PERGUNTAS
PRIMARY KEY (CD_PERGUNTA);

CREATE TABLE T_SS_RESPOSTA(
    CD_RESPOSTA NUMBER(5) NOT NULL,
    CD_PERGUNTA NUMBER(5) NOT NULL,
    DS_RESPOSTA VARCHAR2(2049) NOT NULL
);

ALTER TABLE T_SS_RESPOSTA
ADD CONSTRAINT PK_T_SS_RESPOSTA
PRIMARY KEY (CD_RESPOSTA);

CREATE TABLE T_SS_PERGUNTAS_USUARIO(
    CD_USUARIO NUMBER(5) NOT NULL,
    CD_PERGUNTA NUMBER(5) NOT NULL
);

ALTER TABLE T_SS_PERGUNTAS_USUARIO
ADD CONSTRAINT PK_T_SS_PERGUNTAS_USUARIO
PRIMARY KEY (CD_USUARIO, CD_PERGUNTA);

CREATE TABLE T_SS_ERRO(
    CD_ERRO NUMBER(4),
    NM_ERRO VARCHAR2(100),
    DT_OCORRENCIA DATE,
    USUARIO VARCHAR2(30)
);

CREATE TABLE T_SS_LOG_ATUALIZACAO(
    CD_USUARIO NUMBER(2), 
    DT_ATUALIZACAO DATE,
    VALOR_ANTIGO VARCHAR2(12), 
    VALOR_NOVO VARCHAR2(12)
);


-- FK

ALTER TABLE T_SS_FORMA_DE_PAGAMENTO
ADD CONSTRAINT FK_T_SS_FORMA_DE_PAG_PLANO
FOREIGN KEY (CD_PLANO)
REFERENCES T_SS_PLANO (CD_PLANO);

ALTER TABLE T_SS_PERGUNTAS_USUARIO
ADD CONSTRAINT FK_T_SS_PERGUN_USU_PERGUNTAS
FOREIGN KEY (CD_PERGUNTA)
REFERENCES T_SS_PERGUNTAS (CD_PERGUNTA);

ALTER TABLE T_SS_PERGUNTAS_USUARIO
ADD CONSTRAINT FK_T_SS_PERGUN_USU_USUARIO 
FOREIGN KEY (CD_USUARIO)
REFERENCES T_SS_USUARIO (CD_USUARIO);

ALTER TABLE T_SS_RESPOSTA
ADD CONSTRAINT FK_T_SS_RESPOSTA_PERGUNTAS
FOREIGN KEY (CD_PERGUNTA)
REFERENCES T_SS_PERGUNTAS (CD_PERGUNTA);

ALTER TABLE T_SS_USUARIO
ADD CONSTRAINT FK_T_SS_USUARIO_PLANO
FOREIGN KEY (CD_PLANO)
REFERENCES T_SS_PLANO (CD_PLANO);

-- DML --

-- INSERT

INSERT INTO T_SS_PLANO VALUES(1, 'gratis', null, null);
INSERT INTO T_SS_PLANO VALUES(2, 'mensal',35, null);
INSERT INTO T_SS_PLANO VALUES(3, 'anual', null, 378);
INSERT INTO T_SS_PLANO VALUES(4, 'gratis', null, null);
INSERT INTO T_SS_PLANO VALUES(5, 'mensal', 35, null);

INSERT INTO T_SS_USUARIO VALUES(1, 1, 'Andressa', 'andressa03@gmail.com', 
    'dressa0327', TO_DATE('20/04/1950', 'DD/MM/YYYY'), '051934929506');
INSERT INTO T_SS_USUARIO VALUES(2, 2, 'Bianca', 'bianca_b@outlook.com.br', 
    'bianquinha', TO_DATE('01/01/1952', 'DD/MM/YYYY'), '084932903230');
INSERT INTO T_SS_USUARIO VALUES(3, 3, 'Gabriel', 'ga_768@yahoo.com.br', 
    'ferla0987', TO_DATE('15/06/1961', 'DD/MM/YYYY'), '031920937642');
INSERT INTO T_SS_USUARIO VALUES(4, 4, 'Gerson', 'gerson1122@ig.com.br', 
    'GSON13', TO_DATE('25/12/1966', 'DD/MM/YYYY'), '067927286419');
INSERT INTO T_SS_USUARIO VALUES(5, 5, 'Jefferson', 'jeff23@gmail.com', 
    'jeff45', TO_DATE('14/05/1958', 'DD/MM/YYYY'), '085935766246');

INSERT INTO T_SS_FORMA_DE_PAGAMENTO VALUES(1, 2, 'Bianca B T', '6225 6157 4056 8440', 
    TO_DATE('02/10/2020', 'DD/MM/YYYY'), '220');
INSERT INTO T_SS_FORMA_DE_PAGAMENTO VALUES(2, 1, 'Andressa R S', '4514 1656 7557 1659', 
    TO_DATE('02/08/2027', 'DD/MM/YYYY'), '844');
INSERT INTO T_SS_FORMA_DE_PAGAMENTO VALUES(3, 4, 'Gerson R M', '5359 7155 7835 4192', 
    TO_DATE('20/09/2032', 'DD/MM/YYYY'), '208');
INSERT INTO T_SS_FORMA_DE_PAGAMENTO VALUES(4, 3, 'Gabriel F', '6224 4782 1490 0313', 
    TO_DATE('29/11/2026', 'DD/MM/YYYY'), '581');
INSERT INTO T_SS_FORMA_DE_PAGAMENTO VALUES(5, 5, 'Jefferson A C', '5285 1339 4534 5779', 
    TO_DATE('20/05/2027', 'DD/MM/YYYY'), '441');

INSERT INTO T_SS_PERGUNTAS VALUES(1, 'Como faço para instalar um aplicativo?');
INSERT INTO T_SS_PERGUNTAS VALUES(2,'Como utilizo o WhatsApp?');
INSERT INTO T_SS_PERGUNTAS VALUES(3,'Como pago minhas contas no app do banco?');
INSERT INTO T_SS_PERGUNTAS VALUES(4,'Como adiciono um contato na lista telefonica do celular?');
INSERT INTO T_SS_PERGUNTAS VALUES(5,'Como tiro uma foto?');

INSERT INTO T_SS_RESPOSTA VALUES(1, 1, 
    'Vai ate a loja de aplicativo do seu celular, pode ser o AppStore ou Play Store, vai na barra de pesquisa e digite o nome do aplicativo que esta querendo instalar. Apos isso clique na opcao e mande instalar.');
INSERT INTO T_SS_RESPOSTA VALUES(2, 2, 
    'Abra o aplicativo, clica no icone de chat, e procure por um contato que voce ja tem cadastrado no celular, apos achar, clique no contato e ai voce ja pode começar a mandar mensagem.');
INSERT INTO T_SS_RESPOSTA VALUES(3, 3, 
    'Apos abrir o aplicativo voce deve digitar a agencia e a conta de seu banco, apos escrever ele vai pedir a senha do internet bank, a senha que o banco fala para voce cadastrar no caixa eletronico, logo apos clique no botao de autenticar e pronto voce ja entrou no aplicativo.');
INSERT INTO T_SS_RESPOSTA VALUES(4, 4, 
    'Para adicionar um novo contato, voce deve apertar no aplicativo "Contatos" no canto superior possui um simbolo de "+" apos clicar voce define onde quer salvar o contato, se é no chip ou em sua conta Google, logo apos, de digitar o numero de celular e o nome, clique em adicionar. Pronto, voce ja fez o cadastro dessa pessoa nos seus contatos.');
INSERT INTO T_SS_RESPOSTA VALUES(5, 5, 
    'Para tirar uma foto, voce deve procurar um aplicativo chamado "Camera" e depois clicar nesse aplicativo, logo apos verifique se a camera esta na posicao frontal para tirar uma "selfie" ou se esta no modo paisagem. Para fazer a alteracao da posicao da camera voce deve clicar na opcao, com umas setas e uma camera fotografica. Apos isso, posicione o celular e clique no botao central de cor branca. Apos clicar, pronto, voce ja tirou sua primeira foto em seu smartphone!');

INSERT INTO T_SS_PERGUNTAS_USUARIO VALUES(1, 2);
INSERT INTO T_SS_PERGUNTAS_USUARIO VALUES(2, 1);
INSERT INTO T_SS_PERGUNTAS_USUARIO VALUES(3, 5);
INSERT INTO T_SS_PERGUNTAS_USUARIO VALUES(4, 3);
INSERT INTO T_SS_PERGUNTAS_USUARIO VALUES(5, 4);