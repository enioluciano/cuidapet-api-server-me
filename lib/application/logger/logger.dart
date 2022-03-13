import 'package:logger/logger.dart' as log;

import 'i_logger.dart';

class Logger implements ILogger {
  List<String> messages = [];
  final logger = log.Logger();
  @override
  void debug(message, [error, StackTrace? stackTrace]) {
    logger.d(message, error, stackTrace);
  }

  @override
  void error(message, {error, StackTrace? stackTrace}) {
    logger.e(message, error, stackTrace);
  }

  @override
  void info(message, {error, StackTrace? stackTrace}) {
    logger.i(message, error, stackTrace);
  }

  @override
  void warning(message, {error, StackTrace? stackTrace}) {
    logger.w(message, error, stackTrace);
  }

  @override
  void append(message) {
    messages.add(message);
  }

  @override
  void closeAppend() {
    info(messages.join('\n'));
    messages = [];
  }
}
