import 'package:barcollector/src/database/database_connection.dart';
import 'package:barcollector_sdk/types/register/data/collect_register.dart';

class RegisterRepository {
  Future<void> insertCollectRegister(CollectRegister register) async {
    const sql = '';
    final result = await DatabaseConnection.execute(sql);
  }
}
