# Ecommerce-cart

## Descrição
API responsavel pelo gerenciamento de carrinho de compras, sendo possivel registrar/adicionar/remover/listar itens de um carrinho

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
