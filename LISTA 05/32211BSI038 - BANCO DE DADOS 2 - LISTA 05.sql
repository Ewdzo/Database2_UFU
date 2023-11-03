-- ENZO WEDER MOREIRA AMORIM - BD2 - 2023.1 - 32211BSI038 --

DROP TABLE IF EXISTS funcionario, departamento, projeto, trabalha_em, funcionarioLog, funcionarioLog2 CASCADE;


--------------------------------------------- 32211BSI038 - LISTA 5 ---------------------------------------------

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

--------------------------------------------- 32211BSI038 - LISTA 5 - POPULAR ---------------------------------------------

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

--------------------------------------------- 32211BSI038 - LISTA 5 - CONSTRAINT ---------------------------------------------

ALTER TABLE funcionario ADD CONSTRAINT n_dpt_fkey FOREIGN KEY (Numero_departamento) REFERENCES departamento(Numero_departamento);
ALTER TABLE funcionario ADD CONSTRAINT cpf_supervisor_fkey FOREIGN KEY (Cpf_supervisor) REFERENCES funcionario(cpf);
ALTER TABLE departamento ADD CONSTRAINT cpf_gerente_fkey FOREIGN KEY (Cpf_gerente) REFERENCES funcionario(cpf);
ALTER TABLE projeto ADD CONSTRAINT Numero_departamento_fkey FOREIGN KEY (Numero_departamento) REFERENCES departamento(Numero_departamento);

ALTER TABLE trabalha_em ADD CONSTRAINT funcionario_projeto_Pkey PRIMARY KEY (Cpf_funcionario, Numero_projeto);
ALTER TABLE trabalha_em ADD CONSTRAINT Cpf_funcionario_fkey FOREIGN KEY (Cpf_funcionario) REFERENCES funcionario(cpf);
ALTER TABLE trabalha_em ADD CONSTRAINT Numero_projeto_fkey FOREIGN KEY (Numero_projeto) REFERENCES projeto(Numero_projeto);

--------------------------------------------- 32211BSI038 - LISTA 5 - QUESTAO 1 ---------------------------------------------

CREATE OR REPLACE FUNCTION nome_departamento(int, text)
RETURNS void AS $$
UPDATE departamento SET nome_departamento = $2 WHERE numero_departamento = $1;
$$ LANGUAGE SQL;

--------------------------------------------- 32211BSI038 - LISTA 5 - QUESTAO 2 ---------------------------------------------

CREATE OR REPLACE FUNCTION salario_funcionario(text, real)
RETURNS void AS $$
UPDATE funcionario SET salario = $2 WHERE cpf = $1;
$$ LANGUAGE SQL;

--------------------------------------------- 32211BSI038 - LISTA 5 - QUESTAO 3 ---------------------------------------------

CREATE OR REPLACE FUNCTION salario_funcionario()
RETURNS trigger AS $$
	BEGIN
		UPDATE funcionario SET salario = 30000 WHERE salario < 30000;
		UPDATE funcionario SET salario = 50000 WHERE salario > 50000;
		RETURN NULL;
	END
$$ LANGUAGE plpgsql;

--------------------------------------------- 32211BSI038 - LISTA 5 - QUESTAO 4 ---------------------------------------------

CREATE TRIGGER checa_salario AFTER
	INSERT OR UPDATE
	ON funcionario FOR EACH ROW
	EXECUTE PROCEDURE salario_funcionario();

--------------------------------------------- 32211BSI038 - LISTA 5 - QUESTAO 5 ---------------------------------------------

CREATE OR REPLACE FUNCTION modifica_salario()
RETURNS trigger AS $$
	BEGIN
		IF(NEW.salario > OLD.salario * 1.5 OR OLD.salario > NEW.salario * 2) THEN
			RAISE EXCEPTION 'Mudança superior a 50%%';
		END IF;
		RETURN NEW;
	END
$$ LANGUAGE plpgsql;

CREATE TRIGGER mudanca_salario
BEFORE UPDATE
ON funcionario FOR EACH ROW
EXECUTE PROCEDURE modifica_salario();

--------------------------------------------- 32211BSI038 - LISTA 5 - QUESTAO 6 ---------------------------------------------

ALTER TABLE departamento ADD funcionarios int DEFAULT 0;

CREATE OR REPLACE FUNCTION atualiza_funcionario()
RETURNS trigger AS $$
	BEGIN
		UPDATE departamento AS dp
		SET funcionarios = (
			SELECT COUNT(*)
			FROM FUNCIONARIO AS F, DEPARTAMENTO AS D 
			WHERE f.numero_departamento = d.numero_departamento AND dp.numero_departamento = d.numero_departamento
			GROUP BY f.numero_departamento
		)
		WHERE numero_departamento = NEW.numero_departamento;
		RETURN NEW;
	END
$$ LANGUAGE plpgsql;

CREATE TRIGGER att_func
AFTER INSERT OR UPDATE
ON funcionario FOR EACH ROW
EXECUTE PROCEDURE atualiza_funcionario();

--------------------------------------------- 32211BSI038 - LISTA 5 - QUESTAO 7 ---------------------------------------------

CREATE OR REPLACE FUNCTION atualiza_horas()
RETURNS trigger AS $$
	BEGIN
		UPDATE TRABALHA_EM SET horas = 10 WHERE horas < 10;
		RETURN NULL;
	END
$$ LANGUAGE plpgsql;

CREATE TRIGGER att_horas
AFTER INSERT OR UPDATE
ON trabalha_em FOR EACH ROW
EXECUTE PROCEDURE atualiza_horas();


--------------------------------------------- 32211BSI038 - LISTA 5 - QUESTAO 8 ---------------------------------------------

-- REMOVE CONSTRAINT - Sem a desabilitar as constraints o 'DROP CASCADE' via trigger não será possível no caso deste banco de dados.

-- ALTER TABLE funcionario DROP CONSTRAINT n_dpt_fkey;
-- ALTER TABLE funcionario DROP CONSTRAINT cpf_supervisor_fkey;
-- ALTER TABLE departamento DROP CONSTRAINT cpf_gerente_fkey;
-- ALTER TABLE projeto DROP CONSTRAINT Numero_departamento_fkey;
-- ALTER TABLE trabalha_em DROP CONSTRAINT funcionario_projeto_Pkey;
-- ALTER TABLE trabalha_em DROP CONSTRAINT Cpf_funcionario_fkey;
-- ALTER TABLE trabalha_em DROP CONSTRAINT Numero_projeto_fkey;

CREATE OR REPLACE FUNCTION deleta_funcionario()
RETURNS trigger AS $$
	BEGIN
		DELETE FROM funcionario WHERE cpf_supervisor = OLD.cpf;
		DELETE FROM trabalha_em AS t_em WHERE t_em.cpf_funcionario = OLD.cpf;
		DELETE FROM departamento as d WHERE d.cpf_gerente = OLD.cpf;
	RETURN NEW;
	END
$$ LANGUAGE plpgsql;

CREATE TRIGGER deleta_func
AFTER DELETE
ON funcionario FOR EACH ROW
EXECUTE PROCEDURE deleta_funcionario();

--------------------------------------------- 32211BSI038 - LISTA 5 - QUESTAO 9 ---------------------------------------------

CREATE OR REPLACE FUNCTION checa_cpf()
RETURNS trigger AS $$
	BEGIN
		IF(NEW.cpf_supervisor = NEW.cpf) THEN
			RAISE EXCEPTION 'Um funcionário não pode ser supervisor dele mesmo.';
		END IF;
		RETURN NEW;
	END
$$ LANGUAGE plpgsql;

CREATE TRIGGER atualiza_funcionario
BEFORE INSERT OR UPDATE
ON funcionario FOR EACH ROW
EXECUTE PROCEDURE checa_cpf();

--------------------------------------------- 32211BSI038 - LISTA 5 - QUESTAO 10 ---------------------------------------------

DROP FUNCTION IF EXISTS checa_nascimento(text);

CREATE OR REPLACE FUNCTION checa_nascimento(text)
RETURNS text AS $$
	DECLARE nascimento text;
	DECLARE idade int;
	BEGIN
			SELECT funcionario.data_nascimento
			INTO nascimento
			FROM funcionario WHERE cpf = $1;
			
			SELECT DATE_PART('YEAR', AGE(CURRENT_DATE, TO_DATE(nascimento, 'DD-MM-YYYY'))) 
			INTO idade;
		RETURN idade;
	END
$$ LANGUAGE plpgsql;

--------------------------------------------- 32211BSI038 - LISTA 5 - QUESTAO 11 ---------------------------------------------

CREATE TABLE funcionarioLog (
		op text,
		Cpf text,
		Primeiro_nome text,
		Ultimo_nome text,
		Data_Nascimento text,
		salario real,
		Cpf_supervisor text,
		Numero_departamento int,
		tstamp timestamp DEFAULT now()
);

CREATE OR REPLACE FUNCTION add_log() 
RETURNS trigger AS $$
       BEGIN
         IF TG_OP = 'INSERT' THEN 
		 	INSERT INTO funcionarioLog VALUES ( 
				TG_OP,
				NEW.Cpf,
				NEW.Primeiro_nome,
				NEW.Ultimo_nome,
				NEW.Data_Nascimento,
				NEW.salario,
				NEW.CPF_supervisor,
				NEW.Numero_departamento );
         	RETURN NEW;
         ELSIF  TG_OP = 'UPDATE' THEN
		 	INSERT INTO funcionarioLog VALUES (
				TG_OP,
				OLD.cpf,
				OLD.Primeiro_nome,
				OLD.Ultimo_nome,
				OLD.Data_Nascimento,
				OLD.salario,
				OLD.CPF_supervisor,
				OLD.Numero_departamento );
         	RETURN NEW;
         ELSIF TG_OP = 'DELETE' THEN
		 	INSERT INTO funcionarioLog VALUES (
				TG_OP,			
				OLD.cpf,
				OLD.Primeiro_nome,
				OLD.Ultimo_nome,
				OLD.Data_Nascimento,
				OLD.salario,
				OLD.CPF_supervisor,
				OLD.Numero_departamento
          	);
            RETURN OLD;
         END IF;
       END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER log_funcionario
BEFORE INSERT OR UPDATE OR DELETE
ON funcionario FOR EACH ROW
EXECUTE PROCEDURE  add_log();

--------------------------------------------- 32211BSI038 - LISTA 5 - QUESTAO 12 ---------------------------------------------

ALTER TABLE departamento ADD orcamento int DEFAULT 300000;

CREATE OR REPLACE FUNCTION checa_orcamento()
RETURNS trigger AS $$
	DECLARE custo real;
	BEGIN
		SELECT SUM(salario)
		INTO custo
		FROM FUNCIONARIO AS f, DEPARTAMENTO AS d 
		WHERE f.numero_departamento = d.numero_departamento AND d.numero_departamento = OLD.numero_departamento
		GROUP BY f.numero_departamento;
		
		IF(custo > 0.6 * (SELECT orcamento FROM departamento WHERE numero_departamento = old.numero_departamento )) THEN
			RAISE EXCEPTION 'Custo atingiria 60%% do orçamento com essa mudança';
		END IF;
		RETURN NEW;
	END
$$ LANGUAGE plpgsql;

CREATE TRIGGER orcamento_check
AFTER INSERT OR UPDATE
ON funcionario FOR EACH ROW
EXECUTE PROCEDURE checa_orcamento();

--------------------------------------------- 32211BSI038 - LISTA 5 - QUESTAO 13 ---------------------------------------------

DROP FUNCTION get_orcamentos();
CREATE OR REPLACE FUNCTION get_orcamentos()
RETURNS TABLE(txt1 text,
			  numero_departamento int,
			  txt2 text,
			  porcentagem double precision) AS $$
	BEGIN
		RETURN QUERY
		SELECT  'Departamento: ', d.numero_departamento, ' - Porcentagem: ', ((SUM(salario) / orcamento) * 100) AS porcentagem
		FROM DEPARTAMENTO AS d, FUNCIONARIO AS f
		WHERE f.numero_departamento = d.numero_departamento
		GROUP BY d.numero_departamento;
	END
$$ LANGUAGE plpgsql;


--------------------------------------------- 32211BSI038 - LISTA 5 - QUESTAO 14 ---------------------------------------------

CREATE TABLE funcionarioLog2 (
		Cpf text,
		salario_antigo real,
		salario_novo real,
		Numero_departamento_antigo int,
		Numero_departamento_novo int,
		Cpf_supervisor_antigo text,
		Cpf_supervisor_novo text,
		tstamp timestamp DEFAULT now()
);

CREATE OR REPLACE FUNCTION add_log2() 
RETURNS trigger AS $$
       BEGIN
		INSERT INTO funcionarioLog2 VALUES ( 
			NEW.Cpf,
			OLD.salario,
			NEW.salario,
			OLD.Numero_departamento,
			NEW.Numero_departamento,
			OLD.CPF_supervisor,
			NEW.CPF_supervisor
		);
		
		UPDATE funcionarioLog2 SET salario_antigo = NULL, salario_novo = NULL WHERE OLD.salario = NEW.salario;
		UPDATE funcionarioLog2 SET Numero_departamento_antigo = NULL, Numero_departamento_novo = NULL WHERE OLD.Numero_departamento = NEW.Numero_departamento;
		UPDATE funcionarioLog2 SET Cpf_supervisor_antigo = NULL, Cpf_supervisor_novo = NULL WHERE OLD.Cpf_supervisor = NEW.Cpf_supervisor;
		
		RETURN NEW;
       END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER log2_funcionario
BEFORE UPDATE
ON funcionario FOR EACH ROW
EXECUTE PROCEDURE  add_log2();