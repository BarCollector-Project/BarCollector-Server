-- Schema para o banco de dados BarCollector

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
    name VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role user_role NOT NULL DEFAULT 'common',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_products_barcode ON products(barcode);
CREATE INDEX IF NOT EXISTS idx_users_name ON users(name);

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
    ('admin', '$2a$10$TseQRKfCVhZfkJTpJUgEGOfA3UHe7HtTAAh.SrIZ8fB29i/vnnuFq', 'admin')
ON CONFLICT DO NOTHING;