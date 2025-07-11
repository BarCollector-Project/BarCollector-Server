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

## Endpoints da API

### GET `/products`
Retorna todos os produtos

### GET `/products/{id}`
Retorna um produto específico pelo ID

### POST `/products`
Cria um novo produto

Body:
```json
{
  "name": "Nome do Produto",
  "barcode": "1234567890123",
  "price": 19.99
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
