
CREATE DATABASE sistema_vendas;
USE sistema_vendas;

CREATE TABLE clientes (
id_cliente INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100),
cidade VARCHAR(100)
);

CREATE TABLE produtos (
id_produto INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100),
preco DECIMAL(10,2),
estoque INT
);

CREATE TABLE pedidos (
id_pedido INT AUTO_INCREMENT PRIMARY KEY,
id_cliente INT,
data_pedido DATE,
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE itens_pedido (
id_item INT AUTO_INCREMENT PRIMARY KEY,
id_pedido INT,
id_produto INT,
quantidade INT,
FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);


INSERT INTO clientes (nome,cidade) VALUES
('Ana Souza','Rio de Janeiro'),
('Carlos Lima','São Paulo'),
('Mariana Alves','Belo Horizonte');

INSERT INTO produtos (nome,preco,estoque) VALUES
('Notebook Dell',4500.00,10),
('Mouse Gamer',150.00,50),
('Teclado Mecânico',350.00,30),
('Monitor LG',1200.00,15);

INSERT INTO pedidos (id_cliente,data_pedido) VALUES
(1,'2024-05-01'),
(2,'2024-05-03'),
(1,'2024-05-05');

INSERT INTO itens_pedido (id_pedido,id_produto,quantidade) VALUES
(1,1,1),
(1,2,2),
(2,3,1),
(3,4,1);

UPDATE produtos
SET preco = 140
WHERE nome = 'Mouse Gamer';


DELETE FROM clientes
WHERE id_cliente = 3;


ALTER TABLE clientes
ADD telefone VARCHAR(20);


UPDATE clientes
SET telefone = '21999999999'
WHERE id_cliente = 1;


ALTER TABLE clientes
DROP telefone;


SELECT clientes.nome, pedidos.id_pedido, pedidos.data_pedido
FROM clientes
JOIN pedidos
ON clientes.id_cliente = pedidos.id_cliente;


SELECT clientes.nome AS cliente,
produtos.nome AS produto,
itens_pedido.quantidade,
produtos.preco
FROM itens_pedido
JOIN pedidos ON itens_pedido.id_pedido = pedidos.id_pedido
JOIN clientes ON pedidos.id_cliente = clientes.id_cliente
JOIN produtos ON itens_pedido.id_produto = produtos.id_produto
WHERE clientes.cidade = 'Rio de Janeiro'
AND produtos.preco > 100;


CREATE VIEW relatorio_vendas AS
SELECT clientes.nome AS cliente,
produtos.nome AS produto,
itens_pedido.quantidade,
produtos.preco
FROM itens_pedido
JOIN pedidos ON itens_pedido.id_pedido = pedidos.id_pedido
JOIN clientes ON pedidos.id_cliente = clientes.id_cliente
JOIN produtos ON itens_pedido.id_produto = produtos.id_produto;


SELECT * FROM relatorio_vendas;


DELIMITER //

CREATE FUNCTION calcular_desconto(preco DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
RETURN preco * 0.9;
END //

DELIMITER ;


SELECT nome, preco, calcular_desconto(preco) AS preco_com_desconto
FROM produtos;


START TRANSACTION;

UPDATE produtos
SET estoque = estoque - 1
WHERE id_produto = 1;

SAVEPOINT estoque1;

UPDATE produtos
SET estoque = estoque - 2
WHERE id_produto = 2;

ROLLBACK TO estoque1;

COMMIT;

SELECT * FROM clientes;
SELECT * FROM produtos;
SELECT * FROM pedidos;
SELECT * FROM itens_pedido;
