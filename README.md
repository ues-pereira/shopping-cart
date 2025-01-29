# Ecommerce-cart

## Descrição
API responsável pelo gerenciamento de carrinho de compras, permitindo registrar, adicionar, remover e listar itens de um carrinho.

## Pre-requisitos
  - Ruby
  - PostgreSQL
  - Redis

## Setup com Docker
Certifique-se de ter no seu sistema:
 - **Docker**: versao 24.0.5 ou superior
 - **Docker compose**: versao v2.24.6 ou superior

 Caso tenha um versao menor, será necessario incoporar o hífen e usar a forma: `docker-compose`

 Construir a imagem
 ```sh
  docker compose build
 ```

Iniciar a aplicacao
 ```sh
  docker compose up
 ```

 Abrir o shell dentro do container web
  ```sh
  docker compose run --rm web bash
 ```
Caso desejar iniciar o container `test` basta substituir

Rodar os testes
 ```sh
  docker compose up test
 ```

Os testes tambem podem ser executados dentro do container, para isso basta abrir o shell do container de `test` e executar
 ```sh
  bundle exec rspec
 ```


## API Documentation

## Endpoints Produtos

### 1. **Listar Todos os Produtos**

- **URL:** `/products`
- **Método:** `GET`
- **Descrição:** Retorna todos os produtos.
- **Resposta:**
  - Código de status: `200 OK`
  - Corpo da resposta:
    ```json
    [
      {
        "id": 1,
        "name": "Produto 1",
        "price": 100.00,
        "created_at": "2025-01-29T12:56:12.011-03:00",
        "updated_at": "2025-01-29T12:56:12.011-03:00"
      },
      {
        "id": 2,
        "name": "Produto 2",
        "price": 150.00,
        "created_at": "2025-01-29T12:56:12.011-03:00",
        "updated_at": "2025-01-29T12:56:12.011-03:00"
      }
    ]
    ```

### 2. **Visualizar um Produto Específico**

- **URL:** `/products/:id`
- **Método:** `GET`
- **Descrição:** Retorna os detalhes de um produto específico.
- **Parâmetros de URL:**
  - `id` (obrigatório) – O ID do produto que você deseja visualizar.
- **Resposta:**
  - Código de status: `200 OK`
  - Corpo da resposta:
    ```json
    {
      "id": 1,
      "name": "Produto 1",
      "price": 100.00,
      "created_at": "2025-01-29T12:56:12.011-03:00",
      "updated_at": "2025-01-29T12:56:12.011-03:00"
    }
    ```

### 3. **Criar um Novo Produto**

- **URL:** `/products`
- **Método:** `POST`
- **Descrição:** Cria um novo produto.
- **Corpo da Requisição:**
  ```json
  {
    "product": {
      "name": "Novo Produto",
      "price": 120.00
    }
  }

## Endpoints Carrinho

### 1. **Registrar um produto no carrinho**
   **Descrição**: Adiciona um produto ao carrinho. Caso não exista um carrinho para a sessão, um novo será criado, e o ID do carrinho será armazenado na sessão. O payload retornado incluirá a lista atualizada de produtos no carrinho e o valor total.

   - **Rota**: `POST /cart`
   - **Payload (Request Body)**:
     ```json
     {
       "product_id": 345,
       "quantity": 2
     }
     ```
   - **Response (Response Body)**:
     ```json
     {
       "id": 789,
       "products": [
         {
           "id": 645,
           "name": "Nome do produto",
           "quantity": 2,
           "unit_price": 1.99,
           "total_price": 3.98
         },
         {
           "id": 646,
           "name": "Nome do produto 2",
           "quantity": 2,
           "unit_price": 1.99,
           "total_price": 3.98
         }
       ],
       "total_price": 7.96
     }
     ```

### 2. **Listar itens do carrinho atual**
   **Descrição**: Lista todos os produtos presentes no carrinho atual. Retorna o ID do carrinho e os detalhes dos produtos, incluindo quantidade, preço unitário e total.

   - **Rota**: `GET /cart`
   - **Response (Response Body)**:
     ```json
     {
       "id": 789,
       "products": [
         {
           "id": 645,
           "name": "Nome do produto",
           "quantity": 2,
           "unit_price": 1.99,
           "total_price": 3.98
         },
         {
           "id": 646,
           "name": "Nome do produto 2",
           "quantity": 2,
           "unit_price": 1.99,
           "total_price": 3.98
         }
       ],
       "total_price": 7.96
     }
     ```

### 3. **Alterar a quantidade de produtos no carrinho**
   **Descrição**: Altera a quantidade de um produto no carrinho. Se o produto já estiver no carrinho, sua quantidade será ajustada. Caso contrário, ele será adicionado.

   - **Rota**: `POST /cart/add_item`
   - **Payload (Request Body)**:
     ```json
     {
       "product_id": 1230,
       "quantity": 1
     }
     ```
   - **Response (Response Body)**:
     ```json
     {
       "id": 1,
       "products": [
         {
           "id": 1230,
           "name": "Nome do produto X",
           "quantity": 2,
           "unit_price": 7.00,
           "total_price": 14.00
         },
         {
           "id": 01020,
           "name": "Nome do produto Y",
           "quantity": 1,
           "unit_price": 9.90,
           "total_price": 9.90
         }
       ],
       "total_price": 23.90
     }
     ```

### 4. **Remover um produto do carrinho**
   **Descrição**: Remove um produto do carrinho, com base no `product_id`.

   - **Rota**: `DELETE /cart/:product_id`
   - **Exemplo de URL**: `DELETE /cart/1230` (onde `1230` é o ID do produto a ser removido)
   - **Response (Response Body)**:
     ```json
     {
       "id": 789,
       "products": [
         {
           "id": 646,
           "name": "Nome do produto 2",
           "quantity": 2,
           "unit_price": 1.99,
           "total_price": 3.98
         }
       ],
       "total_price": 3.98
     }
     ```

---

### Resumo das Rotas:

| Método | Rota                | Descrição                                      |
|--------|---------------------|------------------------------------------------|
| POST   | `/cart`             | Registrar um produto no carrinho.             |
| GET    | `/cart`             | Listar todos os itens do carrinho.            |
| POST   | `/cart/add_item`    | Alterar a quantidade de um produto no carrinho.|
| DELETE | `/cart/:product_id` | Remover um produto do carrinho.               |


