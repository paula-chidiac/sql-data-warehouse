/*
===============================================================================
Testes de qualidade
===============================================================================
Objetivo: Este script verifica a qualidade dos dados na camada Prata. 

Notas: Utiize após carregar os dados na camada Prata.
===============================================================================
*/
-- ====================================================================
-- Verificando 'ouro.dim_customers'
-- ====================================================================

-- Checando duplicatas da coluna customer_key. Não deve retornar nenhum resultado.
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM ouro.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Verificando 'ouro.product_key'
-- ====================================================================

-- Checando duplicatas da coluna product_key. Não deve retornar nenhum resultado.
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM ouro.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'ouro.fact_sales'
-- ====================================================================

-- Checando conectividade entre tabelas fato e dimensão. Não deve retornar nenhum resultado.
SELECT * 
FROM ouro.fact_sales f
LEFT JOIN ouro.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN ouro.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL  
