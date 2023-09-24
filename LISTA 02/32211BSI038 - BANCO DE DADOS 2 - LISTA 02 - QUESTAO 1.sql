DROP TABLE IF EXISTS filme, ator, atua_em CASCADE;


--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 1.a ---------------------------------------------

CREATE TABLE filme (
	cod_filme text PRIMARY KEY,
	titulo text NOT NULL,
	diretor text NOT NULL,
	idioma text NOT NULL
	anoProducao int NOT NULL,
	genero text NOT NULL,
);

CREATE TABLE ator (
	cod_ator int PRIMARY KEY,
	nome text NOT NULL,
	nacionalidade text NOT NULL,
	anoNascimento int NOT NULL
);

CREATE TABLE atua_em (
	cod_ator int PRIMARY KEY,
    cod_filme int PRIMARY KEY,
	horas_gravacao int NOT NULL,
	salario real NOT NULL
);

ALTER TABLE atua_em ADD CONSTRAINT cod_ator_fk FOREIGN KEY (cod_ator) REFERENCES ator(cod_ator);
ALTER TABLE atua_em ADD CONSTRAINT cod_filme_fk FOREIGN KEY (cod_filme) REFERENCES filme(cod_filme);

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 1.b ---------------------------------------------

INSERT INTO ator VALUES (1200, 'Julia Roberts', 'Norte-Americano', 1970)

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 1.c ---------------------------------------------

INSERT INTO filme VALUES ('X400', 'Beleza Americana', 'Sam Mendes', 'Ingles', 1999, 'Comedia')

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 1.d ---------------------------------------------

DELETE FROM filme WHERE diretor == 'Steven Spielberg';

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 1.e ---------------------------------------------

DELETE FROM ator WHERE anoNascimento < 1950;

--------------------------------------------- 32211BSI038 - LISTA 2 - QUESTAO 1.f ---------------------------------------------

UPDATE ator SET salario = 500 WHERE salario < 300;