# Configuração do Banco de Dados PostgreSQL

## Pré-requisitos

1. PostgreSQL instalado e rodando
2. Dart Frog configurado

## Configuração

### 1. Configurar Variáveis de Ambiente

Copie o arquivo `.env.example` para `.env` e configure suas credenciais:

```bash
cp .env.example .env
```

Edite o arquivo `.env` com suas configurações:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=barcollector
DB_USER=postgres
DB_PASSWORD=sua_senha
JWT_SECRET=chave_secreta
```

### 2. Criar o Banco de Dados

Execute no PostgreSQL:

```sql
CREATE DATABASE barcollector;
```

### 3. Executar o Schema

Execute o arquivo de schema para criar as tabelas:

```bash
psql -U postgres -d barcollector -f database/schema.sql
```

Ou pelo cliente PostgreSQL:

```sql
\i database/schema.sql
```

## Estrutura do Banco

### Tabela `products`

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | VARCHAR(36) | ID único do produto (UUID) |
| name | VARCHAR(255) | Nome do produto |
| barcode | VARCHAR(100) | Código de barras (único) |
| price | DECIMAL(10,2) | Preço do produto |
| created_at | TIMESTAMP | Data de criação |
| updated_at | TIMESTAMP | Data da última atualização |

### Tabela `users`

| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | VARCHAR(36) | ID único do produto (UUID) |
| name | VARCHAR(255) | Nome do produto |
| password | TEXT | Senha hash do usuário |
| role | user_role | Regra 'admin' ou 'user' |
| created_at | TIMESTAMP | Data de criação |
| updated_at | TIMESTAMP | Data da última atualização |

## Endpoints da API

Abaixo estão os endpoint para comunicação com o banco de dados através do servidor.

## Endpoint `products`

### POST `/products`

Cria um novo produto

Body para envio:

```json
{
  "name": "Nome do Produto",
  "barcode": "1234567890123",
  "price": 19.99
}
```

### GET `/products`

Retorna todos os produtos como uma lista de objetos JSON

Respota do servidor:

```json
[
    {
        "id": "4654d216-e452-464c-a0b6-56c475bb4697",
        "name": "Açúcar Cristal 1kg",
        "barcode": "7891000000003",
        "price": 4.2
    },
    {
        "id": "a3b8972f-954b-43df-b251-ef5790350bd3",
        "name": "Arroz Branco 5kg",
        "barcode": "7891000000001",
        "price": 25.0
    },
    {
        "id": "94973fe0-fa85-4d54-9a28-55fb894eedb0",
        "name": "Café em Pó 500g",
        "barcode": "7891000052402",
        "price": 18.5
    },
    {
        "id": "2f286a47-30b6-4d13-8d8c-5e015fbc8df1",
        "name": "Feijão Preto 1kg",
        "barcode": "7891000000002",
        "price": 8.75
    },
    {
        "id": "726a0067-dd5c-4e9a-8d08-e2e3a505e390",
        "name": "Leite Integral 1L",
        "barcode": "7891000315101",
        "price": 5.99
    }
]
```

### GET `/products/{id}`

Retorna um produto específico pelo ID.

Resposta do servidor:

```json
{
    "id": "4654d216-e452-464c-a0b6-56c475bb4697",
    "name": "Açúcar Cristal 1kg",
    "barcode": "7891000000003",
    "price": 4.2
}
```

### GET `/products/barcode/{barcode}`

Retorna um produto específico pelo código de barras

Resposta do servidor:

```json
{
    "id": "4654d216-e452-464c-a0b6-56c475bb4697",
    "name": "Açúcar Cristal 1kg",
    "barcode": "7891000000003",
    "price": 4.2
}
```

### PUT `/products/{id}`

Atualiza um produto existente

### DELETE `/products/{id}`

Remove um produto

## Executar a API

```bash
dart_frog dev
```

A API estará disponível em `http://localhost:8080`

## Testando

```bash
# Listar todos os produtos
curl http://localhost:8080/products

# Buscar produto por ID
curl http://localhost:8080/products/{id}

# Criar produto
curl -X POST http://localhost:8080/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Produto Teste","barcode":"1234567890","price":10.50}'
```
