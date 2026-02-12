/*
===============================================================================
Criação de Procedure: Carregamento da camada bronze
===============================================================================

Objetivo: Essa procedure é destinada à camada Bronze. Ela trunca as tabelas e copia dados de arquivos CSV armazenados localmente para elas. 

Parâmetros: Nenhum.

Exemplo de uso:
    CALL bronze.load_bronze();

ATENÇÃO: lembre-se de atualizar os destinos dos arquivos antes de rodar o script.
===============================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
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
		RAISE NOTICE 'Carregando a Camada Bronze';
		RAISE NOTICE '================================================';
		
	    RAISE NOTICE '------------------------------------------------';
		RAISE NOTICE 'Carregando as tabelas CRM';
		RAISE NOTICE '------------------------------------------------';

		start_time := NOW();
		RAISE NOTICE '>> Truncando bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		RAISE NOTICE '>> Copiando dados para bronze.crm_cust_info';
		COPY bronze.crm_cust_info
		FROM 'CAMINHO_DO_ARQUIVO'
		DELIMITER ','
		CSV HEADER;
		end_time := NOW();
		duration := EXTRACT(EPOCH FROM (end_time - start_time))::INT;
		RAISE NOTICE '>> Duração do carregamento da tabela: % seconds', duration;
    	RAISE NOTICE '>> -------------';
		
		start_time := NOW();
		RAISE NOTICE '>> Truncando bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		RAISE NOTICE '>> Copiando dados para bronze.crm_prd_info';
		COPY bronze.crm_prd_info
		FROM 'CAMINHO_DO_ARQUIVO'
		DELIMITER ','
		CSV HEADER;
		end_time := NOW();
		duration := EXTRACT(EPOCH FROM (end_time - start_time))::INT;
		RAISE NOTICE '>> Duração do carregamento da tabela: % seconds', duration;
    	RAISE NOTICE '>> -------------';

		start_time := NOW();
		RAISE NOTICE '>> Truncando bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		RAISE NOTICE '>> Copiando dados para bronze.crm_sales_details';
		COPY bronze.crm_sales_details
		FROM 'CAMINHO_DO_ARQUIVO'
		DELIMITER ','
		CSV HEADER;
		end_time := NOW();
		duration := EXTRACT(EPOCH FROM (end_time - start_time))::INT;
		RAISE NOTICE '>> Duração do carregamento da tabela: % seconds', duration;
    	RAISE NOTICE '>> -------------';


	    RAISE NOTICE '------------------------------------------------';
		RAISE NOTICE 'Carregando as tabelas ERM';
		RAISE NOTICE '------------------------------------------------';

		start_time := NOW();
		RAISE NOTICE '>> Truncando bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		RAISE NOTICE '>> Copiando dados para bronze.erp_loc_a101';
		COPY bronze.erp_loc_a101
		FROM 'CAMINHO_DO_ARQUIVO'
		DELIMITER ','
		CSV HEADER;
		end_time := NOW();
		duration := EXTRACT(EPOCH FROM (end_time - start_time))::INT;
		RAISE NOTICE '>> Duração do carregamento da tabela: % seconds', duration;
    	RAISE NOTICE '>> -------------';

		start_time := NOW();
		RAISE NOTICE '>> Truncando bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		RAISE NOTICE '>> Copiando dados para bronze.erp_cust_az12';
		COPY bronze.erp_cust_az12
		FROM 'CAMINHO_DO_ARQUIVO'
		DELIMITER ','
		CSV HEADER;
		end_time := NOW();    	
		duration := EXTRACT(EPOCH FROM (end_time - start_time))::INT;
		RAISE NOTICE '>> Duração do carregamento da tabela: % seconds', duration;
    	RAISE NOTICE '>> -------------';

		start_time := NOW();
		RAISE NOTICE '>> Truncando tabela bronze.px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		RAISE NOTICE '>> Copiando dados para bronze.px_cat_g1v2';
		COPY bronze.erp_px_cat_g1v2
		FROM 'CAMINHO_DO_ARQUIVO'
		DELIMITER ','
		CSV HEADER;
		end_time := NOW();
		duration := EXTRACT(EPOCH FROM (end_time - start_time))::INT;
		RAISE NOTICE '>> Duração do carregamento da tabela: % seconds', duration;
    	RAISE NOTICE '>> -------------';

		batch_end_time := NOW();
		duration := EXTRACT(EPOCH FROM (batch_end_time - batch_start_time))::INT;
		RAISE NOTICE '>> Duração total do carregamento da camada Bronze: % seconds', duration;
    	RAISE NOTICE '>> -------------';
		
	EXCEPTION
		WHEN OTHERS THEN
			RAISE NOTICE 'Mensagem de erro: %', SQLERRM;
	END;
END;
$$;
