CREATE DATABASE clinica_medica;
USE clinica_medica;

CREATE TABLE pacientes (
id_paciente INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(120) NOT NULL,
email VARCHAR(120),
telefone VARCHAR(20),
data_nascimento DATE
);

CREATE TABLE medicos (
id_medico INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(120) NOT NULL,
especialidade VARCHAR(120),
crm VARCHAR(30) UNIQUE
);

CREATE TABLE consultas (
id_consulta INT AUTO_INCREMENT PRIMARY KEY,
id_paciente INT,
id_medico INT,
data_consulta DATETIME,
status VARCHAR(50),
FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
);

CREATE TABLE receitas (
id_receita INT AUTO_INCREMENT PRIMARY KEY,
id_consulta INT,
descricao TEXT,
data_receita DATE,
FOREIGN KEY (id_consulta) REFERENCES consultas(id_consulta)
);

CREATE INDEX idx_paciente_email ON pacientes(email);
CREATE INDEX idx_medico_especialidade ON medicos(especialidade);

INSERT INTO pacientes (nome,email,telefone,data_nascimento) VALUES
('Fernanda Costa','fernanda@email.com','21988880000','1995-03-10'),
('Lucas Almeida','lucas@email.com','21977770000','1990-07-20'),
('Amanda Souza','amanda@email.com','21966660000','1988-11-05');

INSERT INTO medicos (nome,especialidade,crm) VALUES
('Dr Ricardo Alves','Cardiologia','CRM12345'),
('Dra Juliana Mendes','Dermatologia','CRM54321'),
('Dr Paulo Martins','Clinico Geral','CRM67890');

INSERT INTO consultas (id_paciente,id_medico,data_consulta,status) VALUES
(1,1,'2024-06-01 09:00:00','realizada'),
(2,2,'2024-06-02 10:30:00','realizada'),
(3,3,'2024-06-03 11:00:00','agendada');

INSERT INTO receitas (id_consulta,descricao,data_receita) VALUES
(1,'Medicamento para controle de pressão','2024-06-01'),
(2,'Pomada dermatológica','2024-06-02');

UPDATE pacientes
SET telefone = '21999990000'
WHERE id_paciente = 1;

DELETE FROM receitas
WHERE id_receita = 2;

ALTER TABLE pacientes
ADD endereco VARCHAR(200);

UPDATE pacientes
SET endereco = 'Rua Central 123'
WHERE id_paciente = 2;

SELECT p.nome, m.nome, c.data_consulta, c.status
FROM consultas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico;

SELECT p.nome, m.especialidade, c.data_consulta
FROM consultas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico
WHERE m.especialidade = 'Cardiologia'
AND c.status = 'realizada';

CREATE VIEW relatorio_consultas AS
SELECT
c.id_consulta,
p.nome AS paciente,
m.nome AS medico,
m.especialidade,
c.data_consulta,
c.status
FROM consultas c
JOIN pacientes p ON c.id_paciente = p.id_paciente
JOIN medicos m ON c.id_medico = m.id_medico;

SELECT * FROM relatorio_consultas;

DELIMITER //

CREATE FUNCTION calcular_idade(data_nascimento DATE)
RETURNS INT
DETERMINISTIC
BEGIN
RETURN TIMESTAMPDIFF(YEAR,data_nascimento,CURDATE());
END //

DELIMITER ;

SELECT nome, calcular_idade(data_nascimento)
FROM pacientes;

START TRANSACTION;

UPDATE consultas
SET status = 'realizada'
WHERE id_consulta = 3;

SAVEPOINT consulta_atualizada;

UPDATE consultas
SET status = 'cancelada'
WHERE id_consulta = 2;

ROLLBACK TO consulta_atualizada;

COMMIT;

SELECT * FROM pacientes;
SELECT * FROM medicos;
SELECT * FROM consultas;
SELECT * FROM receitas;
