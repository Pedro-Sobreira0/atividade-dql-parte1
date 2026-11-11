-- Banco de Dados I
-- Lista de exercícios - DQL Parte I
-- Base: mercado

-- Questão 01
-- Quantas linhas da tabela fato_vendas não têm cliente identificado?
SELECT COUNT(*) AS vendas_sem_cliente
FROM fato_vendas
WHERE id_cliente IS NULL;

-- Questão 02
-- Quantos clientes diferentes aparecem na tabela fato_vendas?
SELECT COUNT(DISTINCT id_cliente) AS clientes_diferentes
FROM fato_vendas;

-- Questão 03
-- Qual foi o faturamento total de todas as vendas de 2025?
SELECT SUM(valor_total) AS faturamento_2025
FROM fato_vendas
WHERE data_venda >= DATE '2025-01-01'
  AND data_venda < DATE '2026-01-01';

-- Questão 04
-- Liste, sem repetição e em ordem alfabética, as marcas da categoria Higiene.
SELECT DISTINCT marca
FROM dim_produto
WHERE categoria = 'Higiene'
ORDER BY marca ASC;

-- Questão 05
-- Qual é o valor médio de valor_total das vendas do canal Aplicativo?
SELECT AVG(valor_total) AS valor_medio_aplicativo
FROM fato_vendas
WHERE canal = 'Aplicativo';

-- Questão 06
-- Quantos produtos da categoria Bebidas têm preco_tabela acima de R$ 10,00?
SELECT COUNT(*) AS produtos_bebidas_acima_de_10
FROM dim_produto
WHERE categoria = 'Bebidas'
  AND preco_tabela > 10.00;

-- Questão 07
-- Mostre o nome, a marca e o preço de tabela do produto mais caro.
-- Em caso de empate no preço, escolha o primeiro nome em ordem alfabética.
SELECT nome_produto, marca, preco_tabela
FROM dim_produto
ORDER BY preco_tabela DESC, nome_produto ASC
LIMIT 1;

-- Questão 08
-- Quantos produtos existem em cada categoria?
SELECT categoria, COUNT(*) AS quantidade_produtos
FROM dim_produto
GROUP BY categoria
ORDER BY quantidade_produtos DESC, categoria ASC;

-- Questão 09
-- Qual é o preço médio de tabela de cada categoria?
SELECT categoria, AVG(preco_tabela) AS preco_medio
FROM dim_produto
GROUP BY categoria
ORDER BY preco_medio DESC, categoria ASC;

-- Questão 10
-- Quantos clientes há em cada cidade? Mostrar apenas cidades com pelo menos 60 clientes.
SELECT cidade, COUNT(*) AS quantidade_clientes
FROM dim_cliente
GROUP BY cidade
HAVING COUNT(*) >= 60
ORDER BY quantidade_clientes DESC, cidade ASC;

-- Questão 11
-- Quantos clientes não informaram e-mail?
SELECT COUNT(*) AS clientes_sem_email
FROM dim_cliente
WHERE email IS NULL;

-- Questão 12
-- Quantas clientes do sexo feminino nasceram entre 01/01/1990 e 31/12/1999?
SELECT COUNT(*) AS clientes_femininas_nascidas_nos_anos_1990
FROM dim_cliente
WHERE sexo = 'F'
  AND data_nascimento BETWEEN DATE '1990-01-01' AND DATE '1999-12-31';

-- Questão 13
-- Quantos clientes têm Ana como primeiro nome? Analu e Anabela não contam.
SELECT COUNT(*) AS clientes_com_primeiro_nome_ana
FROM dim_cliente
WHERE LOWER(SPLIT_PART(nome, ' ', 1)) = 'ana';

-- Questão 14
-- Quantas lojas existem em cada UF? Mostrar apenas UFs com mais de 3 lojas.
SELECT uf, COUNT(*) AS quantidade_lojas
FROM dim_loja
GROUP BY uf
HAVING COUNT(*) > 3
ORDER BY quantidade_lojas DESC, uf ASC;

-- Questão 15
-- Liste lojas inauguradas antes de 01/01/2007, da mais antiga para a mais recente.
SELECT nome_loja, cidade, data_inauguracao
FROM dim_loja
WHERE data_inauguracao < DATE '2007-01-01'
ORDER BY data_inauguracao ASC, nome_loja ASC;

-- Questão 16
-- Qual foi o faturamento de cada canal de venda em 2025?
SELECT canal, SUM(valor_total) AS faturamento_2025
FROM fato_vendas
WHERE data_venda >= DATE '2025-01-01'
  AND data_venda < DATE '2026-01-01'
GROUP BY canal
ORDER BY faturamento_2025 DESC, canal ASC;

-- Questão 17
-- Para Loja física, mostre por forma de pagamento a quantidade de linhas e o faturamento.
SELECT forma_pagamento,
       COUNT(*) AS quantidade_linhas_venda,
       SUM(valor_total) AS faturamento
FROM fato_vendas
WHERE canal = 'Loja física'
GROUP BY forma_pagamento
ORDER BY faturamento DESC, forma_pagamento ASC;

-- Questão 18
-- Quais são os 10 produtos com mais unidades vendidas?
SELECT id_produto, SUM(quantidade) AS unidades_vendidas
FROM fato_vendas
GROUP BY id_produto
ORDER BY unidades_vendidas DESC, id_produto ASC
LIMIT 10;

-- Questão 19
-- Quais são as 5 lojas com maior faturamento em 2024?
SELECT id_loja, SUM(valor_total) AS faturamento_2024
FROM fato_vendas
WHERE data_venda >= DATE '2024-01-01'
  AND data_venda < DATE '2025-01-01'
GROUP BY id_loja
ORDER BY faturamento_2024 DESC, id_loja ASC
LIMIT 5;

-- Questão 20
-- Quantas linhas de venda cada loja tem? Mostrar apenas lojas com mais de 300 linhas.
SELECT id_loja, COUNT(*) AS quantidade_linhas_venda
FROM fato_vendas
GROUP BY id_loja
HAVING COUNT(*) > 300
ORDER BY quantidade_linhas_venda DESC, id_loja ASC;

-- Questão 21
-- Quais clientes têm 70 ou mais linhas de venda? Desconsiderar vendas sem cliente.
SELECT id_cliente, COUNT(*) AS quantidade_linhas_venda
FROM fato_vendas
WHERE id_cliente IS NOT NULL
GROUP BY id_cliente
HAVING COUNT(*) >= 70
ORDER BY quantidade_linhas_venda DESC, id_cliente ASC;

-- Questão 22
-- Quantas linhas tiveram desconto e qual foi o valor médio desses descontos?
SELECT COUNT(*) AS linhas_com_desconto,
       ROUND(AVG(desconto), 2) AS desconto_medio
FROM fato_vendas
WHERE desconto > 0;

-- Questão 23
-- Qual foi o menor e o maior valor_total de uma linha de venda em dezembro de 2025?
SELECT MIN(valor_total) AS menor_valor_total,
       MAX(valor_total) AS maior_valor_total
FROM fato_vendas
WHERE data_venda >= DATE '2025-12-01'
  AND data_venda < DATE '2026-01-01';

-- Questão 24
-- Quantas linhas de venda foram registradas em 24/12/2025 e qual foi o faturamento desse dia?
SELECT COUNT(*) AS quantidade_linhas_venda,
       SUM(valor_total) AS faturamento_dia
FROM fato_vendas
WHERE data_venda = DATE '2025-12-24';

-- Questão 25
-- Vendas do canal Site em 2025 com desconto: mostrar os 10 maiores percentuais de desconto.
SELECT id_venda,
       quantidade * preco_unitario AS valor_bruto,
       desconto,
       valor_total,
       ROUND((desconto * 100.0) / NULLIF(quantidade * preco_unitario, 0), 2) AS percentual_desconto
FROM fato_vendas
WHERE canal = 'Site'
  AND data_venda >= DATE '2025-01-01'
  AND data_venda < DATE '2026-01-01'
  AND desconto > 0
ORDER BY (desconto * 100.0) / NULLIF(quantidade * preco_unitario, 0) DESC,
         id_venda ASC
LIMIT 10;
