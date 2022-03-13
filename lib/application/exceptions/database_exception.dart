class DatabaseException implements Exception {
  String? message;
  Exception? excpetion;
  DatabaseException({
    this.message,
    this.excpetion,
  });

  @override
  String toString() =>
      'DatabaseException(message: $message, excpetion: $excpetion)';
}
