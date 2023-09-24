-- ENZO WEDER MOREIRA AMORIM - BD2 - 2023.1 - 32211BSI038 --

DROP TABLE IF EXISTS funcionario, departamento, projeto, trabalha_em CASCADE;


--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.a ---------------------------------------------

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

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1 - POPULAR ---------------------------------------------

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

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1 - CONSTRAINT ---------------------------------------------

ALTER TABLE funcionario ADD CONSTRAINT n_dpt_fkey FOREIGN KEY (Numero_departamento) REFERENCES departamento(Numero_departamento);
ALTER TABLE funcionario ADD CONSTRAINT cpf_supervisor_fkey FOREIGN KEY (Cpf_supervisor) REFERENCES funcionario(cpf);
ALTER TABLE departamento ADD CONSTRAINT cpf_gerente_fkey FOREIGN KEY (Cpf_gerente) REFERENCES funcionario(cpf);
ALTER TABLE projeto ADD CONSTRAINT Numero_departamento_fkey FOREIGN KEY (Numero_departamento) REFERENCES departamento(Numero_departamento);

ALTER TABLE trabalha_em ADD CONSTRAINT funcionario_projeto_Pkey PRIMARY KEY (Cpf_funcionario, Numero_projeto);
ALTER TABLE trabalha_em ADD CONSTRAINT Cpf_funcionario_fkey FOREIGN KEY (Cpf_funcionario) REFERENCES funcionario(cpf);
ALTER TABLE trabalha_em ADD CONSTRAINT Numero_projeto_fkey FOREIGN KEY (Numero_projeto) REFERENCES projeto(Numero_projeto);

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.a ---------------------------------------------

SELECT primeiro_nome, ultimo_nome, numero_departamento 
FROM funcionario;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.b ---------------------------------------------

SELECT nome_departamento, primeiro_nome, ultimo_nome 
FROM departamento, funcionario 
WHERE cpf_gerente = Cpf;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.c ---------------------------------------------

SELECT nome_projeto, nome_departamento 
FROM departamento, projeto 
WHERE projeto.numero_departamento = departamento.numero_departamento;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.d ---------------------------------------------

SELECT nome_projeto 
FROM departamento, projeto 
WHERE projeto.numero_departamento = departamento.numero_departamento 
AND departamento.numero_departamento = 1;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.e ---------------------------------------------

SELECT nome_projeto 
FROM departamento, projeto 
WHERE projeto.numero_departamento = departamento.numero_departamento 
AND departamento.numero_departamento = 1;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.f ---------------------------------------------

SELECT primeiro_nome, ultimo_nome, horas FROM departamento, projeto, trabalha_em, funcionario 
WHERE projeto.numero_departamento = departamento.numero_departamento 
AND cpf_funcionario = cpf 
AND projeto.numero_projeto = trabalha_em.numero_projeto
AND nome_projeto = 'Informatização';

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.g ---------------------------------------------

SELECT primeiro_nome, ultimo_nome, horas FROM departamento, projeto, trabalha_em, funcionario 
WHERE projeto.numero_departamento = departamento.numero_departamento 
AND cpf_funcionario = cpf 
AND projeto.numero_projeto = trabalha_em.numero_projeto
AND nome_projeto = 'Informatização'
ORDER BY horas DESC;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.h ---------------------------------------------

SELECT numero_projeto, COUNT(cpf_funcionario) AS qtd_funcionarios
FROM trabalha_em
GROUP BY numero_projeto
ORDER BY numero_projeto;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.i ---------------------------------------------

SELECT nome_projeto, soma_horas
FROM projeto, (
	SELECT numero_projeto, SUM(horas) AS soma_horas
	FROM trabalha_em
	GROUP BY numero_projeto
	ORDER BY numero_projeto ) AS horas
WHERE projeto.numero_projeto = horas.numero_projeto;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.j ---------------------------------------------

SELECT Primeiro_nome, Ultimo_nome, SUM(horas) as soma_horas
FROM funcionario, trabalha_em
WHERE trabalha_em.cpf_funcionario = cpf
GROUP BY cpf
ORDER BY soma_horas;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.k ---------------------------------------------

SELECT funcionario.primeiro_nome, funcionario.ultimo_nome, supervisores.primeiro_nome, supervisores.ultimo_nome
FROM funcionario, funcionario as supervisores
WHERE funcionario.cpf_supervisor = supervisores.cpf;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.l ---------------------------------------------

SELECT func.numero_departamento, MAX(salario)
FROM funcionario AS FUNC, departamento as DPT
WHERE func.numero_departamento = dpt.numero_departamento 
GROUP BY func.numero_departamento;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.m ---------------------------------------------

SELECT MAX(salario)
FROM funcionario;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.n ---------------------------------------------

SELECT MAX(salario), MIN(SALARIO), (MAX(salario) - MIN(SALARIO)) AS diferença
FROM funcionario;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.o ---------------------------------------------

SELECT funcionario.cpf, (supervisores.salario - funcionario.salario) AS diferenca
FROM funcionario, funcionario as supervisores
WHERE funcionario.cpf_supervisor = supervisores.cpf;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.p ---------------------------------------------

SELECT MAX(supervisores.salario - funcionario.salario)
FROM funcionario, funcionario as supervisores
WHERE funcionario.cpf_supervisor = supervisores.cpf;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.q ---------------------------------------------

SELECT numero_departamento, media
FROM (
	SELECT func.numero_departamento, AVG(salario) AS media
	FROM funcionario AS FUNC, departamento as DPT
	WHERE func.numero_departamento = dpt.numero_departamento
	GROUP BY func.numero_departamento
)
WHERE media > 33000;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.r ---------------------------------------------

SELECT primeiro_nome, ultimo_nome
FROM funcionario, trabalha_em, projeto
WHERE trabalha_em.cpf_funcionario = cpf
AND projeto.numero_projeto = trabalha_em.numero_projeto
AND funcionario.numero_departamento != projeto.numero_departamento;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.s ---------------------------------------------

SELECT DISTINCT primeiro_nome, ultimo_nome
FROM funcionario, trabalha_em, projeto
WHERE trabalha_em.cpf_funcionario = cpf
AND projeto.numero_projeto = trabalha_em.numero_projeto
AND funcionario.numero_departamento = projeto.numero_departamento;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.t ---------------------------------------------


SELECT primeiro_nome, ultimo_nome
FROM funcionario AS func
WHERE NOT EXISTS(
	SELECT primeiro_nome, ultimo_nome
	FROM funcionario, trabalha_em, projeto
	WHERE trabalha_em.cpf_funcionario = cpf
	AND projeto.numero_projeto = trabalha_em.numero_projeto
	AND funcionario.numero_departamento != projeto.numero_departamento
	AND cpf = func.cpf
);

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.u ---------------------------------------------

SELECT primeiro_nome, ultimo_nome, Data_Nascimento
FROM funcionario
WHERE Data_Nascimento LIKE '%/196%';

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 1.v ---------------------------------------------

SELECT *
FROM funcionario, departamento
WHERE funcionario.numero_departamento = departamento.numero_departamento
AND nome_departamento = 'Pesquisa'
AND salario >= 30000
AND salario <= 40000;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 2.a ---------------------------------------------

-- TODOS OS FUNCIONARIOS DO MES DE NOVEMBRO

SELECT primeiro_nome, ultimo_nome, Data_Nascimento
FROM funcionario
WHERE Data_Nascimento LIKE '%/11/%';

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 2.a ---------------------------------------------

-- TODOS OS FUNCIONARIOS DO MES DE NOVEMBRO

SELECT primeiro_nome, ultimo_nome, Data_Nascimento
FROM funcionario
WHERE Data_Nascimento LIKE '%/11/%';

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 2.b ---------------------------------------------

-- TODOS OS FUNCIONARIOS QUE TRABALHARAM MAIS DE 30 HORAS

SELECT Primeiro_nome, Ultimo_nome, soma_horas
FROM (
	SELECT Primeiro_nome, Ultimo_nome, SUM(horas) as soma_horas
	FROM funcionario, trabalha_em
	WHERE trabalha_em.cpf_funcionario = cpf
	GROUP BY cpf
	ORDER BY soma_horas
)
WHERE soma_horas > 30;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 2.c ---------------------------------------------

-- TODOS OS PROJETOS COM PELO MENOS 3 FUNCIONARIOS

SELECT numero_projeto
FROM (
	SELECT numero_projeto, COUNT(cpf_funcionario) AS qtd_funcionarios
	FROM trabalha_em
	GROUP BY numero_projeto
	ORDER BY numero_projeto
)
WHERE qtd_funcionarios >= 3;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 2.d ---------------------------------------------

-- TODOS OS DEPARTAMENTOS COM SALARIO MINIMO DE 30 MIL

SELECT numero_departamento, minimo
FROM (
	SELECT func.numero_departamento, MIN(salario) AS minimo
	FROM funcionario AS FUNC, departamento as DPT
	WHERE func.numero_departamento = dpt.numero_departamento
	GROUP BY func.numero_departamento
)
WHERE minimo >= 30000;

--------------------------------------------- 32211BSI038 - LISTA 3 - QUESTAO 2.e ---------------------------------------------

-- AS HORAS SEMANAIS DE TODOS OS FUNCIONARIOS DO DEPARTAMENTO 5

SELECT Primeiro_nome, Ultimo_nome, soma_horas
FROM (
	SELECT Primeiro_nome, Ultimo_nome, numero_departamento, SUM(horas) as soma_horas
	FROM funcionario, trabalha_em
	WHERE trabalha_em.cpf_funcionario = cpf
	GROUP BY cpf
	ORDER BY soma_horas
)
WHERE numero_departamento = 5;
