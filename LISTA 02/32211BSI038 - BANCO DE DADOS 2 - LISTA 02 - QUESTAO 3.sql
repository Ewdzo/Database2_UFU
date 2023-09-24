--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 2.b.1 + 2.c.1 ---------------------------------------------

INSERT INTO EMP VALUES ('16', 'Francisco', 'D3', 3000); 
-- Insere com sucesso.

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 2.b.2 + 2.c.2 ---------------------------------------------

INSERT INTO EMP VALUES ('17', 'João', 'D6', 4000);
-- Não existe D6, então não será inserido.

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 2.b.3 + 2.c.3 ---------------------------------------------

INSERT INTO DEP VALUES ('D7', 'Geografia', 30000000);
-- Insere com sucesso.

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 2.b.4 + 2.c.4 ---------------------------------------------

UPDATE EMP SET ENOME = 'Pedro' WHERE ENOME = 'Sérgio';
-- Atualiza com sucesso.

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 2.b.5 + 2.c.5 ---------------------------------------------

UPDATE DEP SET DNUM = 'D2' WHERE DNUM = 'D7';
-- Falha, já existe D2.

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 2.b.6 + 2.c.6 ---------------------------------------------

UPDATE EMP SET ENUM = '12' WHERE ENOME = 'Sérgio';
-- Falha, já existe funcionário 12.

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 2.b.7 + 2.c.7 ---------------------------------------------

UPDATE EMP SET DNUM = 'D9' WHERE ENOME = 'Sérgio';
-- Falha, não existe D9.

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 2.b.8 + 2.c.8 ---------------------------------------------

DELETE FROM TRABALHA WHERE EPNUM = '12' AND PNO = 'P2' AND HORAS = 20;
-- Deleta com sucesso.

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 2.b.9 + 2.c.9 ---------------------------------------------

UPDATE TRABALHA SET EPNUM = '11', PNO = 'P4' WHERE EPNUM = '13' AND PNO = 'P3';
-- Não atualiza pois não encontra EPNUM e PNO com os valores informados.

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 2.b.10 + 2.c.10 ---------------------------------------------

INSERT INTO TRABALHA VALUES ('13', 'P1', 40);
-- Insere com sucesso.

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 2.b.11 + 2.c.11 ---------------------------------------------

INSERT INTO TRABALHA VALUES ('10', 'P1', 40);
-- Insere com sucesso.

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 2.b.12 + 2.c.12 ---------------------------------------------

DELETE FROM PROJ WHERE DNUM = 'D1';
-- Falha por conta de integridade referencial.

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 2.b.13 + 2.c.13 ---------------------------------------------

UPDATE PROJ SET PNUM = 'P5' WHERE PNUM = 'P1';
-- Falha por conta de integridade referencial.

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 2.b.14 + 2.c.14 ---------------------------------------------

DELETE DEP WHERE ORCAM > 14000000;
-- Falha por conta de integridade referencial.