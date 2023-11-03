-- ENZO WEDER MOREIRA AMORIM - BD2 - 2023.1 - 32211BSI038 --

DROP TABLE IF EXISTS funcionario, departamento, projeto, trabalha_em CASCADE;


--------------------------------------------- 32211BSI038 - LISTA 4 ---------------------------------------------

CREATE TABLE funcionario (
	Cpf text NOT NULL PRIMARY KEY,
	Primeiro_nome text,
	Ultimo_nome text NOT NULL,
	Data_Nascimento text NOT NULL,
    salario real NOT NULL,
    Cpf_supervisor text,
    Numero_departamento int NOT NULL
);

CREATE TABLE departamento (
    Nome_departamento text NOT NULL, 
    Numero_departamento int NOT NULL PRIMARY KEY,
    Cpf_gerente text NOT NULL,
    Data_inicio_gerente text NOT NULL
);

CREATE TABLE projeto (
    Nome_projeto text NOT NULL,
    Numero_projeto int NOT NULL PRIMARY KEY,
    Local_projeto text NOT NULL, 
    Numero_departamento int NOT NULL
);

CREATE TABLE trabalha_em (
    Cpf_funcionario text NOT NULL,
    Numero_projeto int NOT NULL,
    Horas decimal
);

--------------------------------------------- 32211BSI038 - LISTA 4 - POPULAR ---------------------------------------------

INSERT INTO funcionario VALUES
('12345678966', 'João', 'Silva', '09/01/1965', 30000, '33344555587', 5),
('33344555587', 'Fernando', 'Wong', '08/12/1955', 40000, '88866555576', 5),
('99988777767', 'Alice', 'Zelaya', '19/01/1968', 25000, '98765432168', 4),
('98765432168', 'Jennifer', 'Souza', '20/06/1941', 43000, '88866555576', 4),
('66688444476', 'Ronaldo', 'Lima', '15/09/1962', 38000, '33344555587', 5),
('45345345376', 'Joice', 'Leite', '31/07/1972', 25000, '33344555587', 5),
('98798798733', 'André', 'Pereira', '29/03/1969', 25000, '98765432168', 4),
('88866555576', 'Jorge', 'Brito', '10/11/1937', 55000, NULL, 1);

INSERT INTO departamento VALUES
('Pesquisa', 5, '33344555587', '22/05/1988'),
('Administração', 4, '98765432168', '01/01/1995'),
('Matriz', 1, '88866555576', '19/06/1981');

INSERT INTO projeto VALUES
('ProdutoX', 1, 'Santo André', 5),
('ProdutoY', 2, 'Itu', 5),
('ProdutoZ', 3, 'São Paulo', 5),
('Informatização', 10, 'Mauá', 4),
('Reorganização', 20, 'São Paulo', 1),
('Novosbeneficios', 30, 'Mauá', 4);

INSERT INTO TRABALHA_EM VALUES
('12345678966', 1, 32.5),
('12345678966', 2, 7.5),
('66688444476', 3, 40),
('45345345376', 1, 20),
('45345345376', 2, 20),
('33344555587', 2, 10),
('33344555587', 3, 10),
('33344555587', 10, 10),
('33344555587', 20, 10),
('99988777767', 30, 10),
('99988777767', 10, 10),
('98798798733', 10, 35),
('98798798733', 30, 5),
('98765432168', 30, 20),
('98765432168', 20, 15),
('88866555576', 20, NULL);

--------------------------------------------- 32211BSI038 - LISTA 4 - CONSTRAINT ---------------------------------------------

ALTER TABLE funcionario ADD CONSTRAINT n_dpt_fkey FOREIGN KEY (Numero_departamento) REFERENCES departamento(Numero_departamento);
ALTER TABLE funcionario ADD CONSTRAINT cpf_supervisor_fkey FOREIGN KEY (Cpf_supervisor) REFERENCES funcionario(cpf);
ALTER TABLE departamento ADD CONSTRAINT cpf_gerente_fkey FOREIGN KEY (Cpf_gerente) REFERENCES funcionario(cpf);
ALTER TABLE projeto ADD CONSTRAINT Numero_departamento_fkey FOREIGN KEY (Numero_departamento) REFERENCES departamento(Numero_departamento);

ALTER TABLE trabalha_em ADD CONSTRAINT funcionario_projeto_Pkey PRIMARY KEY (Cpf_funcionario, Numero_projeto);
ALTER TABLE trabalha_em ADD CONSTRAINT Cpf_funcionario_fkey FOREIGN KEY (Cpf_funcionario) REFERENCES funcionario(cpf);
ALTER TABLE trabalha_em ADD CONSTRAINT Numero_projeto_fkey FOREIGN KEY (Numero_projeto) REFERENCES projeto(Numero_projeto);

--------------------------------------------- 32211BSI038 - LISTA 4 - QUESTAO 1 ---------------------------------------------

-- Uma visão é uma abordagem utilizada para o armazenamento de seleções que são frequentemente utilizadas, o intuito da criação é facilitar e permitir a manipulação de seleções pertinentes ao uso do banco de dados.

--------------------------------------------- 32211BSI038 - LISTA 4 - QUESTAO 2.a ---------------------------------------------

CREATE OR REPLACE VIEW GERENTES AS 
	SELECT nome_departamento, primeiro_nome, ultimo_nome, salario 
	FROM DEPARTAMENTO, FUNCIONARIO 
	WHERE CPF = CPF_GERENTE;

--------------------------------------------- 32211BSI038 - LISTA 4 - QUESTAO 2.b ---------------------------------------------

CREATE OR REPLACE VIEW FUNCIONARIOS_PESQUISA AS ( 
	SELECT F.primeiro_nome, F.ultimo_nome, F.salario, S.primeiro_nome AS S_nome, S.ultimo_nome AS S_sobrenome 
	FROM DEPARTAMENTO AS D, FUNCIONARIO AS F, FUNCIONARIO AS S 
	WHERE D.numero_departamento = F.numero_departamento AND nome_departamento = 'Pesquisa' AND F.cpf_supervisor = S.cpf );

--------------------------------------------- 32211BSI038 - LISTA 4 - QUESTAO 2.c ---------------------------------------------

CREATE OR REPLACE VIEW ProjetoHoras AS
	SELECT nome_departamento, nome_projeto, funcionarios, soma_horas
	FROM projeto AS pj, (
		SELECT numero_projeto, SUM(horas) AS soma_horas, COUNT(*) AS funcionarios
		FROM trabalha_em
		GROUP BY numero_projeto
		ORDER BY numero_projeto ) AS horas,
		departamento AS d
	WHERE 
		pj.numero_projeto = horas.numero_projeto AND
		d.numero_departamento = pj.numero_departamento;

--------------------------------------------- 32211BSI038 - LISTA 4 - QUESTAO 2.d ---------------------------------------------

CREATE OR REPLACE VIEW ProjetoHorasFuncionarios AS
	SELECT nome_departamento, nome_projeto, funcionarios, soma_horas
		FROM projeto AS pj, (
			SELECT numero_projeto, SUM(horas) AS soma_horas, COUNT(*) AS funcionarios
			FROM trabalha_em
			GROUP BY numero_projeto
			ORDER BY numero_projeto ) AS horas,
			departamento AS d
		WHERE 
			pj.numero_projeto = horas.numero_projeto AND
			d.numero_departamento = pj.numero_departamento AND
			funcionarios > 1;

--------------------------------------------- 32211BSI038 - LISTA 4 - QUESTAO 2.e ---------------------------------------------

CREATE OR REPLACE VIEW ProjetoHorasFuncionarios AS
	SELECT * 
	FROM ProjetoHoras 
	WHERE funcionarios > 1;
	
--------------------------------------------- 32211BSI038 - LISTA 4 - QUESTAO 3s ---------------------------------------------

CREATE OR REPLACE VIEW RESUMO_DEPARTAMENTO (numero, qtd_funcionario, Total_sal, Media_sal)
AS SELECT Numero_departamento, COUNT(*), SUM(Salario), AVG (Salario)
FROM FUNCIONARIO
GROUP BY Numero_departamento;

--------------------------------------------- 32211BSI038 - LISTA 4 - QUESTAO 3.a ---------------------------------------------

SELECT * FROM RESUMO_DEPARTAMENTO;

-- Funciona sem problema algum.

--------------------------------------------- 32211BSI038 - LISTA 4 - QUESTAO 3.b ---------------------------------------------

SELECT numero, qtd_funcionario
FROM RESUMO_DEPARTAMENTO
WHERE total_sal > 100000;

-- Funciona sem problema algum.

--------------------------------------------- 32211BSI038 - LISTA 4 - QUESTAO 3.c ---------------------------------------------

SELECT numero, media_sal
FROM RESUMO_DEPARTAMENTO
WHERE qtd_funcionario > ( SELECT qtd_funcionario FROM RESUMO_DEPARTAMENTO
WHERE numero = 1);

-- Funciona sem problema algum.

--------------------------------------------- 32211BSI038 - LISTA 4 - QUESTAO 3.d ---------------------------------------------

--UPDATE RESUMO_DEPARTAMENTO
--SET numero = 3
--WHERE numero = 4;

-- Não é aceito. A atualização envolve a alteração de um atributo envolvido em uma função de agregação.

--------------------------------------------- 32211BSI038 - LISTA 4 - QUESTAO 3.e ---------------------------------------------

--DELETE FROM RESUMO_DEPARTAMENTO
--WHERE qtd_funcionario>4;

-- Não é aceito. A deleção envolve a alteração de um atributo envolvido em uma função de agregação.

--------------------------------------------- 32211BSI038 - LISTA 4 - QUESTAO 4 ---------------------------------------------

CREATE OR REPLACE VIEW RESUMO_DEPARTAMENTO (numero, qtd_funcionario, Total_sal, Media_sal)
AS SELECT Numero_departamento, COUNT(*), SUM(Salario), AVG (Salario)
FROM FUNCIONARIO
GROUP BY Numero_departamento;

CREATE OR REPLACE VIEW GERACAO_Z AS
	SELECT primeiro_nome, ultimo_nome, Data_Nascimento
	FROM funcionario
	WHERE Data_Nascimento LIKE '%/199%' OR Data_Nascimento LIKE '%/200%' OR Data_Nascimento LIKE '%/201%' OR Data_Nascimento LIKE '%/202%';

CREATE OR REPLACE VIEW DISPARIDADE_SALARIAL AS 
	SELECT funcionario.primeiro_nome, funcionario.ultimo_nome, (supervisores.salario - funcionario.salario) AS DIFERENCA
	FROM funcionario, funcionario as supervisores
	WHERE funcionario.cpf_supervisor = supervisores.cpf;
	
CREATE OR REPLACE VIEW FUNCIONARIOS_MATRIZ AS (
	SELECT F.primeiro_nome, F.ultimo_nome, F.salario, S.primeiro_nome AS S_nome, S.ultimo_nome AS S_sobrenome 
	FROM DEPARTAMENTO AS D, FUNCIONARIO AS F, FUNCIONARIO AS S 
	WHERE D.numero_departamento = F.numero_departamento AND nome_departamento = 'Matriz' AND F.cpf_supervisor = S.cpf );
	
CREATE OR REPLACE VIEW DEPARTAMENTO_CARO AS (
	SELECT numero_departamento, minimo
	FROM (
		SELECT func.numero_departamento, MIN(salario) AS minimo
		FROM funcionario AS FUNC, departamento as DPT
		WHERE func.numero_departamento = dpt.numero_departamento
		GROUP BY func.numero_departamento
	)
	WHERE minimo >= 30000);