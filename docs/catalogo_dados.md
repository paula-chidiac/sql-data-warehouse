# Catálogo de dados para a Camada Ouro

## Overview
A Camada Ouro é a representação dos dados no nível de negócio, estruturada para apoiar consultas analíticas e facilitar a elaboração de relatórios. Ela consiste em **tabelas dimensão** e **tabelas fato**.

### 1. **ouro.dim_customers**
- **Objetivo:** Fornece detalhes de clientes enriquecidos com dados demográficos e geográficos.

| Coluna          | Tipo do dado | Descrição                                                                                      |
|-----------------|--------------|------------------------------------------------------------------------------------------------|
| customer_key    | INT          | Chave que identifica de forma única cada registro de cliente na tabela de dimensão.            |
| customer_id     | INT          | Identificador numérico único atribuído a cada cliente.                                         |
| customer_number | TEXT         | Identificador alfanumérico que representa o cliente.                                           |
| first_name      | TEXT         | Primeiro nome do cliente.                                                                      |
| last_name       | TEXT         | Sobrenome do cliente.                                                                          |
| country         | TEXT         | País de residência do cliente (ex.: 'Australia').                                              |
| marital_status  | TEXT         | Estado civil do cliente (ex.: 'Married', 'Single').                                            |
| gender          | TEXT         | Gênero do cliente (ex.: 'Male', 'Female', 'n/a').                                              |
| birthdate       | DATE         | Data de nascimento do cliente, no formato YYYY-MM-DD (ex.: 1971-10-06).                        |
| create_date     | DATE         | Data e hora em que o registro do cliente foi criado no sistema.                                |

---

### 2. **ouro.dim_products**
- **Objetivo:** Fornece informações sobre produtos e seus atributos.

| Coluna               | Tipo do dado | Descrição                                                                                                  |
|----------------------|--------------|------------------------------------------------------------------------------------------------------------|
| product_key          | INT          | Chave substituta que identifica de forma única cada registro de produto na tabela de dimensão de produtos. |
| product_id           | INT          | Identificador único atribuído ao produto para rastreamento e referência internos.                          |
| product_number       | TEXT         | Código alfanumérico estruturado que representa o produto, usado para categorização ou controle de estoque. |
| product_name         | TEXT         | Nome descritivo do produto, incluindo detalhes como tipo, cor e tamanho.                                   |
| category_id          | TEXT         | Identificador único da categoria do produto, vinculando-o à sua classificação de alto nível.               |
| category             | TEXT         | Classificação mais ampla do produto (ex.: Bikes, Components) para agrupar itens relacionados.              |
| subcategory          | TEXT         | Classificação mais detalhada do produto dentro da categoria, como o tipo de produto.                       |
| maintenance_required | TEXT         | Indica se o produto requer manutenção (ex.: 'Yes', 'No').                                                  |
| cost                 | INT          | Custo ou preço base do produto, medido em unidades monetárias.                                             |
| product_line         | TEXT         | Linha ou série específica à qual o produto pertence (ex.: Road, Mountain).                                 |
| start_date           | DATE         | Data em que o produto passou a estar disponível para venda ou uso.                                         |

---

### 3. **ouro.fact_sales**

- **Objetivo:** Armazena dados transacionais para análises futuras.

| Coluna         | Tipo do dado | Descrição                                                                                       |
|----------------|--------------|-------------------------------------------------------------------------------------------------|
| order_number   | TEXT         | Identificador alfanumérico único para cada pedido de venda (ex.: 'SO54496').                    |
| product_key    | INT          | Chave substituta que vincula o pedido à tabela dimensão de produtos.                            |
| customer_key   | INT          | Chave substituta que vincula o pedido à tabela dimensão de clientes.                            |
| order_date     | DATE         | Data em que o pedido foi realizado.                                                             |
| shipping_date  | DATE         | Data em que o pedido foi enviado ao cliente.                                                    |
| due_date       | DATE         | Data de vencimento do pagamento do pedido.                                                      |
| sales_amount   | INT          | Valor monetário total da venda para o item da linha, em unidades monetárias inteiras (ex.: 25). |
| quantity       | INT          | Quantidade de unidades do produto solicitadas no item da linha (ex.: 1).                        |
| price          | INT          | Preço por unidade do produto no item da linha, em unidades monetárias inteiras (ex.: 25).       |
