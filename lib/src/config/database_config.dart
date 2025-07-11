import 'dart:async';
import 'dart:io';

/// Configuração do banco de dados PostgreSQL
class DatabaseConfig {
  // Mapa privado para armazenar variáveis carregadas do arquivo .env
  static final Map<String, String> _env = {};

  /// Carrega as variáveis de um mapa (do .env) para a configuração.
  static void load(Map<String, String> envVars) {
    _env.addAll(envVars);
  }

  // Os getters agora verificam o mapa privado primeiro, depois as variáveis
  // de ambiente do sistema e, por fim, usam um valor padrão.
  static String get host => _env['DB_HOST'] ?? Platform.environment['DB_HOST'] ?? 'localhost';
  static int get port => int.parse(_env['DB_PORT'] ?? Platform.environment['DB_PORT'] ?? '5432');
  static String get database => _env['DB_NAME'] ?? Platform.environment['DB_NAME'] ?? 'barcollector';
  static String get username => _env['DB_USER'] ?? Platform.environment['DB_USER'] ?? 'postgres';
  static String get password => _env['DB_PASSWORD'] ?? Platform.environment['DB_PASSWORD'] ?? 'password';

  static String get connectionString => 'postgresql://$username:$password@$host:$port/$database';

  /// Configurações de conexão
  static Map<String, dynamic> get connectionSettings => {
        'host': host,
        'port': port,
        'database': database,
        'username': username,
        'password': password,
      };
}
