import 'package:barcollector_sdk/types/register/system_tables.dart';

class APIEndpoints {
  static const String baseUrl = ''; // Altere para o IP do seu servidor, se necessário
  static const String login = '$baseUrl/login';
  static const String products = '$baseUrl/products';
  static const String register = '$baseUrl/register';
  static const String adminUpload = '$baseUrl/admin/upload';
  static const String validity = '$baseUrl/register/validity';

  /// Esta rota é a rota principal, onde a rota seguinte deve ser o nome da tablea, ou seja,
  /// .../system_table/<NOME_TABELA>, por exemplo .../system_table/st_motivocoleta.
  /// Estes nomes podem ser obtidos em [SystemTables].
  static const String systemTables = '$baseUrl/system_table';
}
