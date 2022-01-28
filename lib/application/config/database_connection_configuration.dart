class DatabaseConnectionConfiguration {
  final String host;
  final String user;
  final String password;
  final int port;
  final String databaseName;

  DatabaseConnectionConfiguration({
    required this.host,
    required this.user,
    required this.password,
    required this.port,
    required this.databaseName,
  });
}
