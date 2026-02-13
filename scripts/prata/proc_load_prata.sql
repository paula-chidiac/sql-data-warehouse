/*
===============================================================================
Criação de Procedure: Carregamento da camada Prata
===============================================================================

Objetivo: Essa procedure é destinada à camada Prata. Ela trunca as tabelas e insere dados vindos da camada bronze.

Parâmetros: Nenhum.

Exemplo de uso:
    CALL prata.load_prata();

ATENÇÃO: lembre-se de atualizar os destinos dos arquivos antes de rodar o script.
===============================================================================
*/

CREATE OR REPLACE PROCEDURE prata.load_prata()
LANGUAGE plpgsql
AS $$
BEGIN -- Início da procedure

	DECLARE
	  start_time TIMESTAMP;
	  end_time TIMESTAMP;
	  duration INT;
		batch_start_time TIMESTAMP;
		batch_end_time TIMESTAMP;

	BEGIN -- Início do "Try"

		batch_start_time := NOW();
		
		RAISE NOTICE '================================================';
		RAISE NOTICE 'Carregando a Camada Prata';
		RAISE NOTICE '================================================';
		
	    RAISE NOTICE '------------------------------------------------';
		RAISE NOTICE 'Carregando as tabelas CRM';
		RAISE NOTICE '------------------------------------------------';


		start_time := NOW();
		RAISE NOTICE '>> Truncando prata.crm_cust_info';
		TRUNCATE TABLE prata.crm_cust_info;
		RAISE NOTICE '>> Copiando dados para prata.crm_cust_info';
		
		INSERT INTO prata.crm_cust_info (
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_gndr,
		cst_marital_status,
		cst_create_date
	)
		SELECT 
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE 
				WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				ELSE 'N/A'
				END cst_gndr,
			CASE 
				WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
				WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
				ELSE 'N/A'
				END cst_marital_status,
			cst_create_date
		FROM
			(
			SELECT 
				*,
				ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_ultimo
			FROM bronze.crm_cust_info 
			)
		WHERE flag_ultimo = 1;
		
		end_time := NOW();
		duration := EXTRACT(EPOCH FROM (end_time - start_time))::INT;
		RAISE NOTICE '>> Duração do carregamento da tabela: % seconds', duration;

		start_time := NOW();
		RAISE NOTICE '>> Truncando prata.crm_prd_info';
		TRUNCATE TABLE prata.crm_prd_info;
		RAISE NOTICE '>> Copiando dados para prata.crm_prd_info';
		INSERT INTO prata.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		SELECT 
			prd_id,
			REPLACE(SUBSTRING (prd_key, 1, 5), '-','_') AS cat_id,
			SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
			prd_nm,
			COALESCE(prd_cost, 0) AS prd_cost,
			CASE UPPER(TRIM(prd_line))
					WHEN 'M' THEN 'Mountain'
					WHEN 'R' THEN 'Road'
					WHEN 'S' THEN 'Other Sales'
					WHEN 'T' THEN 'Touring'
					ELSE 'N/A'
					END AS prd_line,
			CAST (prd_start_dt AS DATE) AS prd_start_dt,
			CAST (LEAD (prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC)- INTERVAL '1 day' AS DATE) AS prd_end
		FROM prata.crm_prd_info;
		
		end_time := NOW();
		duration := EXTRACT(EPOCH FROM (end_time - start_time))::INT;
		RAISE NOTICE '>> Duração do carregamento da tabela: % seconds', duration;
		RAISE NOTICE '>> -------------';

		start_time:= NOW();
		RAISE NOTICE '>> Truncando prata.crm_sales_details';
		TRUNCATE TABLE prata.crm_sales_details;
		RAISE NOTICE '>> Copiando dados para prata.crm_sales_details';
		INSERT INTO prata.crm_sales_details (
					sls_ord_num,
					sls_prd_key,
					sls_cust_id,
					sls_order_dt,
					sls_ship_dt,
					sls_due_dt,
					sls_sales,
					sls_quantity,
					sls_price
		)
		SELECT 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE WHEN
				sls_order_dt = 0 OR LENGTH(sls_order_dt::TEXT) <> 8 THEN NULL
		    	ELSE TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')
				END AS sls_order_dt,
			CASE WHEN
				sls_ship_dt = 0 OR LENGTH(sls_ship_dt::TEXT) <> 8 THEN NULL
				ELSE TO_DATE(sls_ship_dt::TEXT, 'YYYYMMDD')
				END AS sls_ship_dt,
			CASE WHEN
				sls_due_dt = 0 OR LENGTH(sls_due_dt::TEXT) <> 8 THEN NULL
				ELSE TO_DATE(sls_due_dt::TEXT, 'YYYYMMDD')
				END AS sls_due_dt,
			CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales <> (sls_quantity * ABS(sls_price)) THEN sls_quantity * ABS(sls_price)
				ELSE sls_sales
				END AS sls_sales,
			sls_quantity,
			CASE WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
				ELSE sls_price
				END AS sls_price
		FROM bronze.crm_sales_details;
	    
		end_time := NOW();
		duration := EXTRACT(EPOCH FROM (end_time - start_time))::INT;
		RAISE NOTICE '>> Duração do carregamento da tabela: % seconds', duration;
		RAISE NOTICE '>> -------------';

		RAISE NOTICE '------------------------------------------------';
		RAISE NOTICE 'Carregando as tabelas ERP';
		RAISE NOTICE '------------------------------------------------';

		start_time:= NOW();
		RAISE NOTICE '>> Truncando prata.erp_cust_az12';
		TRUNCATE TABLE prata.erp_cust_az12;
		RAISE NOTICE '>> Copiando dados para prata.erp_cust_az12';
		INSERT INTO prata.erp_cust_az12 (
					cid,
					bdate,
					gen
				)
		SELECT
			CASE 
				WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
				ELSE cid
				END cid,
			CASE
				WHEN bdate > NOW() THEN NULL
				ELSE bdate
				END AS bdate,
			CASE 
				WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
				WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
				ELSE 'N/A'
				END AS gen
		FROM bronze.erp_cust_az12;

		end_time := NOW();
		duration := EXTRACT(EPOCH FROM (end_time - start_time))::INT;
		RAISE NOTICE '>> Duração do carregamento da tabela: % seconds', duration;
		RAISE NOTICE '>> -------------';

		start_time := NOW();
		RAISE NOTICE '>> Truncando prata.erp_loc_a101';
		TRUNCATE TABLE prata.erp_loc_a101;
		RAISE NOTICE '>> Copiando dados para prata.erp_loc_a101';
		INSERT INTO prata.erp_loc_a101 (cid, cntry)
		
		SELECT
			REPLACE(cid, '-','') cid,
			CASE
				WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'Germany'
				WHEN UPPER(TRIM(cntry)) IN ('US', 'USA') THEN 'United States'
				WHEN UPPER(TRIM(cntry)) = '' OR cntry IS NULL THEN 'N/A'
				ELSE TRIM(cntry)
				END AS cntry
		FROM bronze.erp_loc_a101;

		end_time := NOW();
		duration := EXTRACT(EPOCH FROM (end_time - start_time))::INT;
		RAISE NOTICE '>> Duração do carregamento da tabela: % seconds', duration;
		RAISE NOTICE '>> -------------';

		start_time := NOW();
		RAISE NOTICE '>> Truncando prata.erp_px_cat_g1v2';
		TRUNCATE TABLE prata.erp_px_cat_g1v2;
		RAISE NOTICE '>> Copiando dados para prata.erp_px_cat_g1v2';
		INSERT INTO prata.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
		
		SELECT
			TRIM(id) AS id,
			TRIM(cat) AS cat,
			TRIM(subcat) AS subcat,
			TRIM(maintenance) AS maintenance
		FROM bronze.erp_px_cat_g1v2;

		end_time := NOW();
		duration := EXTRACT(EPOCH FROM (end_time - start_time))::INT;
		RAISE NOTICE '>> Duração do carregamento da tabela: % seconds', duration;
		RAISE NOTICE '>> -------------';
		
		batch_end_time := NOW();
		duration := EXTRACT(EPOCH FROM (batch_end_time - batch_start_time))::INT;
		RAISE NOTICE '>> Duração total do carregamento da camada Prata: % seconds', duration;
    	RAISE NOTICE '>> -------------';
		
	EXCEPTION
		WHEN OTHERS THEN
			RAISE NOTICE 'Mensagem de erro: %', SQLERRM;
	END;
END;
$$;
