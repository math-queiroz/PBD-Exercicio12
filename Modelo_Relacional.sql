------- Definição das Tabelas -------
-- Criando a tabela: Aluno
CREATE TABLE tb_aluno (
    ra INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cd_curso INTEGER NOT NULL
);

-- Criando a tabela: Curso
CREATE TABLE tb_curso (
    cd_curso INTEGER PRIMARY KEY,
    nome VARCHAR(200) NOT NULL
);

-- Criando a tabela: Disciplina
CREATE TABLE tb_disciplina (
    cd_disciplina INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(250) NOT NULL,
    cd_departamento INTEGER NOT NULL
);

-- Criando a tabela: Associativa de Curso-Disciplina
CREATE TABLE tb_curso_disciplina (
    cd_curso INTEGER NOT NULL,
    cd_disciplina INTEGER NOT NULL,
    CONSTRAINT pk_curso_disciplina PRIMARY KEY (cd_curso, cd_disciplina),
    CONSTRAINT fk_curso_assoc FOREIGN KEY (cd_curso) REFERENCES tb_curso(cd_curso),
    CONSTRAINT fk_disciplina_assoc FOREIGN KEY (cd_disciplina) REFERENCES tb_disciplina(cd_disciplina)
);

-- Criando a tabela: Associativa de Pré-Requisitos
CREATE TABLE tb_pre_requisitos (
    cd_disc_1 INTEGER NOT NULL,
    cd_disc_2 INTEGER NOT NULL,
    CONSTRAINT pk_pre_requisitos PRIMARY KEY (cd_disc_1, cd_disc_2),
    CONSTRAINT pk_disc_1 FOREIGN KEY (cd_disc_1) REFERENCES tb_disciplina(cd_disciplina),
    CONSTRAINT pk_disc_2 FOREIGN KEY (cd_disc_2) REFERENCES tb_disciplina(cd_disciplina)
);

-- Criando a tabela: Departamento
CREATE TABLE tb_departamento (
    cd_departamento INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

------- Chaves Estrangeiras -------
-- Chave estrangeira: Curso em Aluno
ALTER TABLE tb_aluno ADD CONSTRAINT fk_curso_aluno FOREIGN KEY (cd_curso) REFERENCES tb_curso(cd_curso);

-- Chave estrangeira: Departamento em Disciplina
ALTER TABLE tb_disciplina ADD CONSTRAINT fk_departamento_disciplina FOREIGN KEY (cd_departamento) REFERENCES tb_departamento(cd_departamento);

------------- Valores ------------
INSERT INTO tb_curso VALUES (1, 'Informática');
INSERT INTO tb_curso VALUES (2, 'Marketing');
INSERT INTO tb_curso VALUES (3, 'Filosofia');

INSERT INTO tb_aluno VALUES (1, 'Ana', 3);
INSERT INTO tb_aluno VALUES (2, 'Bob', 2);
INSERT INTO tb_aluno VALUES (3, 'Carlos', 1);

INSERT INTO tb_departamento VALUES (1, 'Departamento 1');
INSERT INTO tb_departamento VALUES (2, 'Departamento 2');
INSERT INTO tb_departamento VALUES (3, 'Departamento 3');

INSERT INTO tb_disciplina VALUES (1, 'Programação', 'Disciplina para desenvolver raciocínio lógico.', 1);
INSERT INTO tb_disciplina VALUES (2, 'Filosofia', 'Disciplina para desenvolver o ferramental retórico.', 1);
INSERT INTO tb_disciplina VALUES (3, 'Propaganda', 'Disciplina voltada para a teoria de propaganda', 3);

INSERT INTO tb_curso_disciplina VALUES (1, 1);
INSERT INTO tb_curso_disciplina VALUES (1, 2);
INSERT INTO tb_curso_disciplina VALUES (2, 2);

INSERT INTO tb_pre_requisitos VALUES (1, 2);
INSERT INTO tb_pre_requisitos VALUES (3, 2);

----------- Procedures -----------
SET SERVEROUTPUT ON;

-- Exercío 1.1
CREATE OR REPLACE PROCEDURE exibir_disciplina(id NUMBER) IS
    nome_disciplina VARCHAR(100);
BEGIN 
    SELECT nome INTO nome_disciplina FROM tb_disciplina WHERE cd_disciplina = id;
    dbms_output.put_line('O nome da disciplina de id igual a '|| id ||' é '|| nome_disciplina);
END;
EXECUTE exibir_disciplina(2);

-- Exercío 1.2 -> ERRO
CREATE OR REPLACE FUNCTION exibir_curso_do_aluno(ra NUMBER) RETURN VARCHAR IS
    id_curso NUMBER;
    nome_curso VARCHAR(200);
BEGIN 
    SELECT cd_curso INTO id_curso FROM tb_aluno WHERE ra = ra;
    SELECT nome INTO nome_curso FROM tb_curso WHERE cd_curso = id_curso;
    RETURN nome_curso;
END;
BEGIN 
    dbms_output.put_line('O curso do aluno de ra 2 é '|| exibir_curso_do_aluno(2)); 
END;

-- Exercío 1.3
CREATE SEQUENCE aluno_seq START WITH 1001 INCREMENT BY 7 CACHE 20;
CREATE TRIGGER t_pk_aluno BEFORE INSERT ON tb_aluno FOR EACH ROW BEGIN :NEW.ra := aluno_seq.NEXTVAL; END;
DROP SEQUENCE aluno_seq;
DROP TRIGGER t_pk_aluno; 

CREATE SEQUENCE curso_seq START WITH 1 INCREMENT BY 2 CACHE 20;
CREATE TRIGGER t_pk_curso BEFORE INSERT ON tb_curso FOR EACH ROW BEGIN :NEW.cd_curso := curso_seq.NEXTVAL; END;

CREATE SEQUENCE disciplina_seq START WITH 1 INCREMENT BY 1 CACHE 20;
CREATE TRIGGER t_pk_disciplina BEFORE INSERT ON tb_disciplina FOR EACH ROW BEGIN :NEW.cd_disciplina := disciplina_seq.NEXTVAL; END;

CREATE SEQUENCE depto_seq START WITH 1 INCREMENT BY 1 CACHE 20;
CREATE TRIGGER t_pk_depto BEFORE INSERT ON tb_departamento FOR EACH ROW BEGIN :NEW.cd_departamento := depto_seq.NEXTVAL; END;

-- Exercío 1.4
CREATE TABLE tb_log (data_hora TIMESTAMP, tipo VARCHAR(15));

CREATE TRIGGER t_registra_log_i_alu AFTER INSERT ON tb_aluno FOR EACH ROW BEGIN INSERT INTO tb_log VALUES (CURRENT_TIMESTAMP, 'INSERT'); END;
CREATE TRIGGER t_registra_log_i_cur AFTER INSERT ON tb_curso FOR EACH ROW BEGIN INSERT INTO tb_log VALUES (CURRENT_TIMESTAMP, 'INSERT'); END;
CREATE TRIGGER t_registra_log_i_dis AFTER INSERT ON tb_disciplina FOR EACH ROW BEGIN INSERT INTO tb_log VALUES (CURRENT_TIMESTAMP, 'INSERT'); END;
CREATE TRIGGER t_registra_log_i_dep AFTER INSERT ON tb_departamento FOR EACH ROW BEGIN INSERT INTO tb_log VALUES (CURRENT_TIMESTAMP, 'INSERT'); END;

CREATE TRIGGER t_registra_log_u_alu AFTER UPDATE ON tb_aluno FOR EACH ROW BEGIN INSERT INTO tb_log VALUES (CURRENT_TIMESTAMP, 'UPDATE'); END;
CREATE TRIGGER t_registra_log_u_cur AFTER UPDATE ON tb_curso FOR EACH ROW BEGIN INSERT INTO tb_log VALUES (CURRENT_TIMESTAMP, 'UPDATE'); END;
CREATE TRIGGER t_registra_log_u_dis AFTER UPDATE ON tb_disciplina FOR EACH ROW BEGIN INSERT INTO tb_log VALUES (CURRENT_TIMESTAMP, 'UPDATE'); END;
CREATE TRIGGER t_registra_log_u_dep AFTER UPDATE ON tb_departamento FOR EACH ROW BEGIN INSERT INTO tb_log VALUES (CURRENT_TIMESTAMP, 'UPDATE'); END;

CREATE TRIGGER t_registra_log_d_alu AFTER DELETE ON tb_aluno FOR EACH ROW BEGIN INSERT INTO tb_log VALUES (CURRENT_TIMESTAMP, 'DELETE'); END;
CREATE TRIGGER t_registra_log_d_cur AFTER DELETE ON tb_curso FOR EACH ROW BEGIN INSERT INTO tb_log VALUES (CURRENT_TIMESTAMP, 'DELETE'); END;
CREATE TRIGGER t_registra_log_d_dis AFTER DELETE ON tb_disciplina FOR EACH ROW BEGIN INSERT INTO tb_log VALUES (CURRENT_TIMESTAMP, 'DELETE'); END;
CREATE TRIGGER t_registra_log_d_dep AFTER DELETE ON tb_departamento FOR EACH ROW BEGIN INSERT INTO tb_log VALUES (CURRENT_TIMESTAMP, 'DELETE'); END;



