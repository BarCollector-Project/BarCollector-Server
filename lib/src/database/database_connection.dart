import 'package:postgres/postgres.dart';
import '../config/database_config.dart';
import '../config/env_loader.dart';

/// Gerenciador de conexão com o banco de dados PostgreSQL
class DatabaseConnection {
  static Connection? _connection;
  static bool _initialized = false;

  /// Garante que as variáveis de ambiente foram carregadas antes de prosseguir.
  static Future<void> _ensureInitialized() async {
    if (!_initialized) {
      // Carrega as variáveis do arquivo .env em um mapa.
      final envVars = await loadEnvFile();
      // Popula a classe de configuração com as variáveis carregadas.
      DatabaseConfig.load(envVars);
      // Isso só precisa ser feito uma vez.
      _initialized = true;
    }
  }

  /// Obtém a conexão com o banco (singleton)
  static Future<Connection> get connection async {
    await _ensureInitialized();
    if (_connection == null || !_connection!.isOpen) {
      await _connect();
    }
    return _connection!;
  }

  /// Estabelece conexão com o banco
  static Future<void> _connect() async {
    final endpoint = Endpoint(
      host: DatabaseConfig.host,
      port: DatabaseConfig.port,
      database: DatabaseConfig.database,
      username: DatabaseConfig.username,
      password: DatabaseConfig.password,
    );

    // Para ambientes de desenvolvimento sem SSL configurado no PostgreSQL,
    // é necessário desabilitar a exigência de SSL na conexão.
    const settings = ConnectionSettings(
      sslMode: SslMode.disable,
    );

    _connection = await Connection.open(endpoint, settings: settings);
  }

  /// Fecha a conexão com o banco
  static Future<void> close() async {
    if (_connection != null && _connection!.isOpen) {
      await _connection!.close();
    }
  }

  /// Executa uma query e retorna os resultados
  static Future<List<Map<String, dynamic>>> query(String sql, [List<dynamic>? params]) async {
    final conn = await connection;
    final result = await conn.execute(sql, parameters: params);
    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Executa uma query que não retorna resultados (INSERT, UPDATE, DELETE)
  static Future<int> execute(String sql, [List<dynamic>? params]) async {
    final conn = await connection;
    final result = await conn.execute(sql, parameters: params);
    return result.affectedRows;
  }
}
