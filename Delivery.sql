CREATE DATABASE delivery_app;
USE delivery_app;

CREATE TABLE clientes (
id_cliente INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
email VARCHAR(120) UNIQUE,
cidade VARCHAR(100),
data_cadastro DATE
);

CREATE TABLE restaurantes (
id_restaurante INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(120) NOT NULL,
cidade VARCHAR(100),
categoria VARCHAR(100)
);

CREATE TABLE produtos (
id_produto INT AUTO_INCREMENT PRIMARY KEY,
id_restaurante INT,
nome VARCHAR(120),
preco DECIMAL(10,2),
disponivel BOOLEAN DEFAULT TRUE,
FOREIGN KEY (id_restaurante) REFERENCES restaurantes(id_restaurante)
);

CREATE TABLE pedidos (
id_pedido INT AUTO_INCREMENT PRIMARY KEY,
id_cliente INT,
data_pedido DATETIME,
status VARCHAR(50),
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE itens_pedido (
id_item INT AUTO_INCREMENT PRIMARY KEY,
id_pedido INT,
id_produto INT,
quantidade INT,
preco_unitario DECIMAL(10,2),
FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

CREATE INDEX idx_cliente_email ON clientes(email);
CREATE INDEX idx_produto_restaurante ON produtos(id_restaurante);

INSERT INTO clientes (nome,email,cidade,data_cadastro) VALUES
('Lucas Martins','lucas@email.com','Rio de Janeiro','2024-01-10'),
('Ana Souza','ana@email.com','Sao Paulo','2024-02-02'),
('Carlos Lima','carlos@email.com','Rio de Janeiro','2024-03-05');

INSERT INTO restaurantes (nome,cidade,categoria) VALUES
('Burger House','Rio de Janeiro','Hamburgueria'),
('Pizza Express','Sao Paulo','Pizzaria'),
('Sushi Tokyo','Rio de Janeiro','Japonesa');

INSERT INTO produtos (id_restaurante,nome,preco,disponivel) VALUES
(1,'Burger Classic',35.00,TRUE),
(1,'Batata Frita',15.00,TRUE),
(2,'Pizza Calabresa',55.00,TRUE),
(3,'Combo Sushi',80.00,TRUE);

INSERT INTO pedidos (id_cliente,data_pedido,status) VALUES
(1,'2024-06-01 19:30:00','entregue'),
(2,'2024-06-02 20:00:00','entregue'),
(1,'2024-06-05 21:10:00','preparando');

INSERT INTO itens_pedido (id_pedido,id_produto,quantidade,preco_unitario) VALUES
(1,1,2,35.00),
(1,2,1,15.00),
(2,3,1,55.00),
(3,4,1,80.00);

UPDATE produtos
SET preco = 37.00
WHERE id_produto = 1;

DELETE FROM produtos
WHERE id_produto = 2;

ALTER TABLE restaurantes
ADD telefone VARCHAR(20);

UPDATE restaurantes
SET telefone = '2130000000'
WHERE id_restaurante = 1;

SELECT c.nome, p.id_pedido, p.status
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente;

SELECT c.nome, r.nome, pr.nome, i.quantidade
FROM itens_pedido i
JOIN pedidos p ON i.id_pedido = p.id_pedido
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN produtos pr ON i.id_produto = pr.id_produto
JOIN restaurantes r ON pr.id_restaurante = r.id_restaurante
WHERE c.cidade = 'Rio de Janeiro'
AND p.status = 'entregue';

CREATE VIEW relatorio_pedidos AS
SELECT
p.id_pedido,
c.nome AS cliente,
r.nome AS restaurante,
pr.nome AS produto,
i.quantidade,
i.preco_unitario,
(i.quantidade * i.preco_unitario) AS total_item
FROM itens_pedido i
JOIN pedidos p ON i.id_pedido = p.id_pedido
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN produtos pr ON i.id_produto = pr.id_produto
JOIN restaurantes r ON pr.id_restaurante = r.id_restaurante;

SELECT * FROM relatorio_pedidos;

DELIMITER //

CREATE FUNCTION calcular_total_item(qtd INT, preco DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
RETURN qtd * preco;
END //

DELIMITER ;

SELECT nome, calcular_total_item(2,preco)
FROM produtos;

START TRANSACTION;

UPDATE produtos
SET preco = preco + 5
WHERE id_restaurante = 1;

SAVEPOINT ajuste_preco;

UPDATE produtos
SET preco = preco + 3
WHERE id_restaurante = 3;

ROLLBACK TO ajuste_preco;

COMMIT;

SELECT * FROM clientes;
SELECT * FROM restaurantes;
SELECT * FROM produtos;
SELECT * FROM pedidos;
SELECT * FROM itens_pedido;
