import 'dart:io';

/// Carrega as variáveis de ambiente de um arquivo .env e as retorna como um Map.
///
/// Este método não modifica o [Platform.environment] global.
Future<Map<String, String>> loadEnvFile() async {
  final envFile = File('.env');
  final envMap = <String, String>{};

  if (!await envFile.exists()) {
    return envMap;
  }

  final lines = await envFile.readAsLines();
  for (final line in lines) {
    // Ignora comentários e linhas em branco
    final trimmedLine = line.trim();
    if (trimmedLine.isEmpty || trimmedLine.startsWith('#')) {
      continue;
    }

    final parts = trimmedLine.split('=');
    if (parts.length >= 2) {
      final key = parts.first.trim();
      final value = parts.sublist(1).join('=').trim().replaceAll("'", '').replaceAll('"', '');
      envMap[key] = value;
    }
  }
  return envMap;
}
