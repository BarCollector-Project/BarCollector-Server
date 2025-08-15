-- Schema para o banco de dados BarCollector

-- Garante que o cliente (psql) está comunicando com o servidor em UTF-8.
-- Isso previne problemas de codificação com caracteres especiais no script.
SET client_encoding = 'UTF8';

-- Extensão para UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tabela de produtos
CREATE TABLE IF NOT EXISTS products (
    id VARCHAR(36) PRIMARY KEY DEFAULT uuid_generate_v4()::text,
    name VARCHAR(255) NOT NULL,
    barcode VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tipo para os papéis de usuário (roles)
CREATE TYPE user_role AS ENUM ('admin', 'common');

-- Tabela de usuário
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(36) PRIMARY KEY DEFAULT uuid_generate_v4()::text,
    name VARCHAR(255) NOT NULL UNIQUE,
    password TEXT NOT NULL,
    role user_role NOT NULL DEFAULT 'common',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_products_barcode ON products(barcode);

-- Tipos para a tabela de coleta
CREATE TYPE collect_reason AS ENUM (
    'inventory', -- Contagem de inventário
    'breakage',  -- Produto quebrado/danificado
    'expiration',-- Produto vencido
    'transfer',  -- Transferência entre locais
    'entry'      -- Entrada de novo estoque
);

CREATE TYPE collect_origin AS ENUM (
    'stock',     -- Estoque principal
    'shelf',     -- Prateleira/Gôndola
    'warehouse'  -- Armazém/Depósito
);

-- Tabela de registros de coleta (cabeçalho da coleta)
-- Cada registro representa uma "sessão" de coleta.
CREATE TABLE IF NOT EXISTS collect_registers (
    id VARCHAR(36) PRIMARY KEY DEFAULT uuid_generate_v4()::text,
    user_id VARCHAR(36) NOT NULL REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabela com os produtos de uma coleta
-- Cada linha é um produto dentro de uma sessão de coleta.
CREATE TABLE IF NOT EXISTS collect_register_items (
    id VARCHAR(36) PRIMARY KEY DEFAULT uuid_generate_v4()::text,
    collect_register_id VARCHAR(36) NOT NULL REFERENCES collect_registers(id) ON DELETE CASCADE,
    product_id VARCHAR(36) NOT NULL REFERENCES products(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    reason collect_reason NOT NULL,
    origin collect_origin NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_collect_registers_user_id ON collect_registers(user_id);
CREATE INDEX IF NOT EXISTS idx_collect_register_items_register_id ON collect_register_items(collect_register_id);

-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_products_updated_at 
    BEFORE UPDATE ON products 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_collect_registers_updated_at
    BEFORE UPDATE ON collect_registers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Dados de exemplo
INSERT INTO products (name, barcode, price) VALUES
    ('Leite Integral 1L', '7891000315101', 5.99),
    ('Café em Pó 500g', '7891000052402', 18.50),
    ('Arroz Branco 5kg', '7891000000001', 25.00),
    ('Feijão Preto 1kg', '7891000000002', 8.75),
    ('Açúcar Cristal 1kg', '7891000000003', 4.20)
ON CONFLICT (barcode) DO NOTHING;

-- Deve ser alterado posteriormente
INSERT INTO users (name, password, role) VALUES
    ('admin', '$2a$10$dJrccUgKLeBltNc5CdUsneoTaj1jEwPnAYlxIcN8w0euMWQ0tQ.ru', 'admin')
ON CONFLICT (name) DO NOTHING;