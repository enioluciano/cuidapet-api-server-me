import 'package:injectable/injectable.dart';
import 'package:mysql1/src/single_connection.dart';

import '../config/database_connection_configuration.dart';
import './i_database_connection_database.dart';

@LazySingleton(as: IDatabaseConnection)
class DatabaseConnectionDatabase implements IDatabaseConnection {
  final DatabaseConnectionConfiguration _configuration;
  DatabaseConnectionDatabase(this._configuration);
  @override
  Future<MySqlConnection> openConnection() {
    return MySqlConnection.connect(ConnectionSettings(
        host: _configuration.host,
        port: _configuration.port,
        user: _configuration.user,
        password: _configuration.password,
        db: _configuration.database));
  }
}
