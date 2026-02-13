# **Convenções de Nomenclatura**

Este documento descreve as convenções de nomenclatura utilizadas para schemas, tabelas, views, colunas e outros objetos no data warehouse.

## **Sumário**

1. [Princípios Gerais](#princípios-gerais)
2. [Convenções de Nomenclatura para Tabelas](#convenções-de-nomenclatura-para-tabelas)
   - [Regras da Bronze](#regras-da-bronze)
   - [Regras da Silver](#regras-da-silver)
   - [Regras da Gold](#regras-da-gold)
3. [Convenções de Nomenclatura para Colunas](#convenções-de-nomenclatura-para-colunas)
   - [Chaves Substitutas](#chaves-substitutas)
   - [Colunas Técnicas](#colunas-técnicas)
4. [Procedures](#procedures)
---

## **Princípios Gerais**

- **Convenção de Nomes**: Utilizar snake_case, com letras minúsculas e underscores (`_`) para separar palavras.
- **Idioma**: Utilizar inglês para todos os nomes.
- **Evitar Palavras Reservadas**: Não utilizar palavras reservadas do SQL como nomes de objetos.

---

## **Convenções de Nomenclatura para Tabelas**

### **Regras da Bronze**
- Todos os nomes devem começar com o nome do sistema de origem, e as tabelas devem manter exatamente o nome original, sem renomeação.
- **`<sourcesystem>_<entity>`**  
  - `<sourcesystem>`: Nome do sistema de origem (ex.: `crm`, `erp`).  
  - `<entity>`: Nome exato da tabela no sistema de origem.  
  - Exemplo: `crm_customer_info` → Informações de clientes provenientes do sistema CRM.

---

### **Regras da Prata**
- Todos os nomes devem começar com o nome do sistema de origem, e as tabelas devem manter exatamente o nome original, sem renomeação.
- **`<sourcesystem>_<entity>`**  
  - `<sourcesystem>`: Nome do sistema de origem (ex.: `crm`, `erp`).  
  - `<entity>`: Nome exato da tabela no sistema de origem.  
  - Exemplo: `crm_customer_info` → Informações de clientes provenientes do sistema CRM.

---

### **Regras da Ouro**
- Todos os nomes devem utilizar nomes significativos e alinhados ao negócio, iniciando com o prefixo da categoria.
- **`<category>_<entity>`**  
  - `<category>`: Descreve o papel da tabela, como `dim` (dimensão) ou `fact` (fato).  
  - `<entity>`: Nome descritivo da tabela, alinhado ao domínio de negócio (ex.: `customers`, `products`, `sales`).  
  - Exemplos:
    - `dim_customers` → Tabela dimensão com dados de clientes.  
    - `fact_sales` → Tabela fato contendo transações de vendas.  

---

#### **Glossário de Padrões de Categoria**

| Padrão    | Significado                | Exemplo(s)                                  |
|------------|---------------------------|----------------------------------------------|
| `dim_`     | Tabela dimensão           | `dim_customer`, `dim_product`               |
| `fact_`    | Tabela fato               | `fact_sales`                                |
| `report_`  | Tabela de relatório       | `report_customers`, `report_sales_monthly`  |

---

## **Convenções de Nomenclatura para Colunas**

### **Chaves Substitutas**
- Todas as chaves primárias em tabelas dimensão devem utilizar o sufixo `_key`.
- **`<table_name>_key`**  
  - `<table_name>`: Refere-se ao nome da tabela ou entidade à qual a chave pertence.  
  - `_key`: Sufixo que indica que a coluna é uma chave substituta (surrogate key).
  - Exemplo: `customer_key` → Chave substituta na tabela `dim_customers`.

---

### **Colunas Técnicas**
- Todas as colunas técnicas devem começar com o prefixo `dwh_`, seguido de um nome descritivo que indique sua finalidade.
- **`dwh_<column_name>`**  
  - `dwh`: Prefixo exclusivo para metadados gerados pelo sistema.  
  - `<column_name>`: Nome descritivo que indica a finalidade da coluna.  
  - Exemplo: `dwh_load_date` → Coluna gerada pelo sistema para armazenar a data em que o registro foi carregado.

---

## **Procedures**

- Todas as stored procedures utilizadas para carregamento de dados devem seguir o padrão:
- **`load_<layer>`**

  - `<layer>`: Representa a camada que está sendo carregada, como `bronze`, `silver` ou `gold`.
  - Exemplos:
    - `load_bronze` → Stored procedure para carregar dados na camada Bronze.
    - `load_silver` → Stored procedure para carregar dados na camada Silver.
