CREATE DATABASE sistema_escola;
USE sistema_escola;

CREATE TABLE alunos (
id_aluno INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100),
idade INT,
email VARCHAR(100)
);

CREATE TABLE professores (
id_professor INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100),
especialidade VARCHAR(100)
);

CREATE TABLE cursos (
id_curso INT AUTO_INCREMENT PRIMARY KEY,
nome_curso VARCHAR(100),
carga_horaria INT,
id_professor INT,
FOREIGN KEY (id_professor) REFERENCES professores(id_professor)
);

CREATE TABLE matriculas (
id_matricula INT AUTO_INCREMENT PRIMARY KEY,
id_aluno INT,
id_curso INT,
data_matricula DATE,
FOREIGN KEY (id_aluno) REFERENCES alunos(id_aluno),
FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
);

INSERT INTO alunos (nome,idade,email) VALUES
('Lucas Pereira',20,'lucas@email.com'),
('Mariana Silva',22,'mariana@email.com'),
('Joao Costa',19,'joao@email.com');

INSERT INTO professores (nome,especialidade) VALUES
('Ricardo Alves','Programacao'),
('Juliana Mendes','Banco de Dados');

INSERT INTO cursos (nome_curso,carga_horaria,id_professor) VALUES
('Introducao ao SQL',30,2),
('JavaScript Basico',40,1),
('Logica de Programacao',35,1);

INSERT INTO matriculas (id_aluno,id_curso,data_matricula) VALUES
(1,1,'2024-06-01'),
(2,2,'2024-06-02'),
(3,3,'2024-06-03'),
(1,3,'2024-06-05');

UPDATE alunos
SET idade = 21
WHERE id_aluno = 1;

DELETE FROM matriculas
WHERE id_matricula = 4;

ALTER TABLE alunos
ADD telefone VARCHAR(20);

UPDATE alunos
SET telefone = '21988888888'
WHERE id_aluno = 2;

ALTER TABLE alunos
DROP telefone;

SELECT alunos.nome, cursos.nome_curso, matriculas.data_matricula
FROM matriculas
JOIN alunos ON matriculas.id_aluno = alunos.id_aluno
JOIN cursos ON matriculas.id_curso = cursos.id_curso;

SELECT alunos.nome, cursos.nome_curso
FROM matriculas
JOIN alunos ON matriculas.id_aluno = alunos.id_aluno
JOIN cursos ON matriculas.id_curso = cursos.id_curso
WHERE alunos.idade > 20
AND cursos.carga_horaria >= 30;

CREATE VIEW relatorio_matriculas AS
SELECT alunos.nome AS aluno,
cursos.nome_curso AS curso,
matriculas.data_matricula
FROM matriculas
JOIN alunos ON matriculas.id_aluno = alunos.id_aluno
JOIN cursos ON matriculas.id_curso = cursos.id_curso;

SELECT * FROM relatorio_matriculas;

DELIMITER //

CREATE FUNCTION bonus_carga(carga INT)
RETURNS INT
DETERMINISTIC
BEGIN
RETURN carga + 5;
END //

DELIMITER ;

SELECT nome_curso, bonus_carga(carga_horaria)
FROM cursos;

START TRANSACTION;

UPDATE cursos
SET carga_horaria = carga_horaria + 10
WHERE id_curso = 1;

SAVEPOINT ponto1;

UPDATE cursos
SET carga_horaria = carga_horaria + 5
WHERE id_curso = 2;

ROLLBACK TO ponto1;

COMMIT;

SELECT * FROM alunos;
SELECT * FROM professores;
SELECT * FROM cursos;
SELECT * FROM matriculas;
