# Configurar PostgreSQL em Rede Local

## 1. Configurar PostgreSQL no PC do Banco

### No PC onde está o PostgreSQL:

#### 1.1. Editar postgresql.conf
Localize o arquivo `postgresql.conf` (geralmente em `C:\Program Files\PostgreSQL\15\data\` no Windows)

Altere a linha:
```
#listen_addresses = 'localhost'
```

Para:
```
listen_addresses = '*'
```

#### 1.2. Editar pg_hba.conf
No mesmo diretório, edite o arquivo `pg_hba.conf` e adicione:

```
# Permitir conexões da rede local
host    all             all             192.168.1.0/24          md5
host    all             all             192.168.0.0/24          md5
host    all             all             10.0.0.0/8              md5
```

#### 1.3. Reiniciar PostgreSQL
- Windows: Reinicie o serviço PostgreSQL no "Serviços"
- Linux: `sudo systemctl restart postgresql`

## 2. Configurar Firewall

### Windows:
1. Abra o "Firewall do Windows"
2. Vá em "Configurações avançadas"
3. Crie uma nova regra de entrada:
   - Tipo: Porta
   - Protocolo: TCP
   - Porta: 5432
   - Ação: Permitir conexão
   - Perfil: Todos
   - Nome: "PostgreSQL"

### Linux:
```bash
sudo ufw allow 5432/tcp
```

## 3. Descobrir o IP do PC

### Windows:
```cmd
ipconfig
```

### Linux:
```bash
ip addr show
```

Anote o IP da rede (ex: 192.168.1.100)

## 4. Configurar sua Aplicação

Crie um arquivo `.env` baseado no `.env.example`:

```env
# Substitua pelo IP real do PC do banco
DB_HOST=192.168.1.100
DB_PORT=5432
DB_NAME=barcollector
DB_USER=postgres
DB_PASSWORD=sua_senha
```

## 5. Testar Conexão

### Do PC da aplicação, teste:

```bash
# Teste de ping
ping 192.168.1.100

# Teste de conexão PostgreSQL
psql -h 192.168.1.100 -U postgres -d barcollector
```

Se conectar, está funcionando!

## 6. Executar Schema

Do PC da aplicação:
```bash
psql -h 192.168.1.100 -U postgres -d barcollector -f database/schema.sql
```

## Troubleshooting

### Erro "Connection refused":
- Verifique se PostgreSQL está rodando
- Confirme se as portas estão abertas no firewall
- Verifique se `listen_addresses = '*'` está correto

### Erro "Authentication failed":
- Verifique usuário/senha
- Confirme configuração do `pg_hba.conf`

### Erro "Connection timeout":
- Verifique conectividade de rede
- Confirme se o IP está correto
- Teste com `ping` e `telnet IP 5432`

## Exemplo de Configuração Completa

**PC do banco (192.168.1.100):**
- PostgreSQL instalado e rodando
- Firewall liberado na porta 5432
- Configurações de rede aplicadas

**PC da aplicação (192.168.1.50):**
- Arquivo `.env` com `DB_HOST=192.168.1.100`
- Dart Frog executando

```bash
# Teste final
dart_frog dev
curl http://localhost:8080/products
```
