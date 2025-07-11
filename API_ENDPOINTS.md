# API Endpoints - BarCollector

## Controle Completo do Banco via API

Agora você tem **controle total** do PostgreSQL via API REST!

### 📋 Listar Produtos
```bash
GET /products
```
**Resposta:**
```json
[
  {
    "id": "uuid-do-produto",
    "name": "Leite Integral 1L",
    "barcode": "7891000315101",
    "price": 5.99
  }
]
```

### 🔍 Buscar Produto por ID
```bash
GET /products/{id}
```
**Exemplo:**
```bash
curl http://localhost:8080/products/12345-uuid
```

### 🔍 Buscar Produto por Código de Barras
```bash
GET /products/barcode/{barcode}
```
**Exemplo:**
```bash
curl http://localhost:8080/products/barcode/7891000315101
```

### ➕ Criar Produto
```bash
POST /products
Content-Type: application/json

{
  "name": "Produto Novo",
  "barcode": "1234567890123",
  "price": 19.99
}
```
**Exemplo:**
```bash
curl -X POST http://localhost:8080/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Chocolate 100g","barcode":"7891000001234","price":4.50}'
```

### ✏️ Atualizar Produto
```bash
PUT /products/{id}
Content-Type: application/json

{
  "name": "Nome Atualizado",
  "barcode": "1234567890123",
  "price": 25.99
}
```
**Exemplo:**
```bash
curl -X PUT http://localhost:8080/products/12345-uuid \
  -H "Content-Type: application/json" \
  -d '{"name":"Leite Desnatado 1L","barcode":"7891000315101","price":6.50}'
```

### 🗑️ Deletar Produto
```bash
DELETE /products/{id}
```
**Exemplo:**
```bash
curl -X DELETE http://localhost:8080/products/12345-uuid
```

## 🚀 Exemplo de Uso Completo

### 1. Criar produtos:
```bash
curl -X POST http://localhost:8080/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Biscoito Recheado","barcode":"7891000001111","price":3.99}'
```

### 2. Listar todos:
```bash
curl http://localhost:8080/products
```

### 3. Buscar por código de barras:
```bash
curl http://localhost:8080/products/barcode/7891000001111
```

### 4. Atualizar preço:
```bash
curl -X PUT http://localhost:8080/products/{id} \
  -H "Content-Type: application/json" \
  -d '{"name":"Biscoito Recheado","barcode":"7891000001111","price":4.50}'
```

### 5. Deletar:
```bash
curl -X DELETE http://localhost:8080/products/{id}
```

## 📊 Códigos de Resposta

- **200** - Sucesso
- **201** - Criado com sucesso
- **204** - Deletado com sucesso
- **400** - Dados inválidos
- **404** - Produto não encontrado
- **405** - Método não permitido

## 🔧 Executar a API

```bash
dart_frog dev
```

**Servidor rodando em:** `http://localhost:8080`

**Você agora tem controle total do PostgreSQL via API REST!**
