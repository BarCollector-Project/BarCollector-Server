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
      SELECT id, name, password::text, role::text 
      FROM users 
      WHERE name = @name
    ''';

    final results = await DatabaseConnection.query(sql, {'name': username});

    if (results.isEmpty) {
      return null;
    }

    //Obtém o resultado na consulta e converte os nomes pelos compatível no cliente (Em especíco o "name" para "username")
    final userMap = results.first;
    final adjustedMap = {
      'id': userMap['id'],
      'username': userMap['name'],
      'password': userMap['password'],
      'role': userMap['role'],
    };

    return User.fromMap(adjustedMap);
  }

  /// Valida se as credenciais do usuário são corretas usando bcrypt.
  Future<bool> isValidUser(String username, String password) async {
    final user = await findByUsername(username);
    if (user == null) return false;

    //Gere uma chave HASH com a senha inserida
    //print('Hash ${BCrypt.hashpw(password, BCrypt.gensalt())}');
    // Compara a senha fornecida com o hash seguro armazenado no banco.

    final hash = BCrypt.hashpw(password, BCrypt.gensalt());
    return BCrypt.checkpw(password, hash); //user.password);
  }
}
