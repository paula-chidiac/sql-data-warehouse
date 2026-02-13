/*
===============================================================================
Testes de qualidade
===============================================================================
Objetivo: Este script verifica a qualidade dos dados na camada Prata. 

Notas: Utiize após carregar os dados na camada Prata.
===============================================================================
*/

-- ====================================================================
-- Verificando 'prata.crm_cust_info'
-- ====================================================================

-- Checando existência de nulos ou duplicatas na primary key. Não deve retornar nenhum resultado.
SELECT 
    cst_id,
    COUNT(*) 
FROM prata.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Checando se há espaços vazios. Não deve retornar resultados.
SELECT 
    cst_key 
FROM prata.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Padronização dos dados
SELECT DISTINCT 
    cst_marital_status 
FROM prata.crm_cust_info;

-- ====================================================================
-- Verificando 'prata.crm_prd_info'
-- ====================================================================

-- Checando existência de nulos ou duplicatas na primary key. Não deve retornar nenhum resultado.
SELECT 
    prd_id,
    COUNT(*) 
FROM prata.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Checando se há espaços vazios indesejados. Não deve retornar resultados.
SELECT 
    prd_nm 
FROM prata.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Checando existência de nulos ou valores negativos no custo. Não deve retornar nenhum resultado.
SELECT 
    prd_cost 
FROM prata.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Padronização e consistência dos dados
SELECT DISTINCT 
    prd_line 
FROM prata.crm_prd_info;

-- Checando se há datas inválidas (data de início > data de finalização). Não deve retornar nenhum resultado.
SELECT 
    * 
FROM prata.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Verificando 'prata.crm_sales_details'
-- ====================================================================

-- Checando se há datas futuras. Não deve retornar nenhum resultado.
SELECT 
    *
FROM prata.crm_sales_details
WHERE sls_due_dt IS NULL
   OR sls_due_dt > DATE '2050-01-01';

-- Checando se há datas de pedido inválidas. Não deve retornar nenhum resultado.
SELECT 
    * 
FROM prata.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Checando consistência: Sales deve ser o resultado de Quantity * Price. Não deve retornar nenhum resultado.
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM prata.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- Verificando 'prata.erp_cust_az12'
-- ====================================================================

-- Identificar datas de nascimento futuras. Não deve retornar nenhum resultado.
SELECT DISTINCT 
    bdate 
FROM prata.erp_cust_az12
WHERE bdate > NOW();

-- Padronização e consistência dos dados
SELECT DISTINCT 
    gen 
FROM prata.erp_cust_az12;

-- ====================================================================
-- Verificando 'prata.erp_loc_a101'
-- ====================================================================

-- Padronização e consistência dos dados
SELECT DISTINCT 
    cntry 
FROM prata.erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- Verificando 'prata.erp_px_cat_g1v2'
-- ====================================================================

-- Checando se há espaços vazios indesejados. Não deve retornar resultados.
SELECT 
    * 
FROM prata.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Padronização e consistência dos dados
SELECT DISTINCT 
    maintenance 
FROM prata.erp_px_cat_g1v2;
