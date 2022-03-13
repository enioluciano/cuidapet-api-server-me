class DatabaseConnectionConfiguration {
  final String host;
  final String user;
  final String password;
  final String database;
  final int port;
  DatabaseConnectionConfiguration({
    required this.host,
    required this.user,
    required this.password,
    required this.database,
    required this.port,
  });
}
