import 'package:barcollector/src/auth/model/user.dart';
import 'package:barcollector/src/database/database_connection.dart';
import 'package:bcrypt/bcrypt.dart';

class UsersRepository {
  /// Busca um usuário pelo nome de usuário.
  Future<User?> findByUsername(String username) async {
    // A query SQL fica mais legível em múltiplas linhas.
    // Usamos @name como placeholder, que é o padrão para o pacote `postgres`.
    // Note que no seu schema.sql, a coluna se chama 'name', não 'username'.
    const sql = '''
      SELECT id, name AS username, password, role::text 
      FROM users 
      WHERE name = @name
      LIMIT 1
    ''';

    final results = await DatabaseConnection.query(sql, {'name': username});

    if (results.isEmpty) {
      return null;
    }

    return User.fromMap(results.first);
  }

  /// Gera um hash bcrypt para uma senha, pronto para ser armazenado no banco.
  /// O salt é gerado e incluído no próprio hash.
  String hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  /// Valida se as credenciais do usuário são corretas usando bcrypt.
  Future<bool> isValidUser(String username, String password) async {
    final user = await findByUsername(username);
    if (user == null) return false;

    // A função `checkpw` compara a senha em texto plano com o hash do banco.
    // Ela extrai o salt do hash armazenado e faz a comparação de forma segura.
    // O hash vindo do banco (user.password) deve ser uma string limpa.
    // Se você encontrar problemas como espaços ou caracteres nulos,
    // a causa provável está na inserção ou recuperação dos dados, não aqui.
    return BCrypt.checkpw(password, user.password);
  }
}
