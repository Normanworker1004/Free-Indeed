
import 'dart:core';

abstract class LoggerManager {
  void log({required String message, LogLevel level = LogLevel.Debug});
}

enum LogLevel {
  Emergency,
  Alerts,
  Critical,
  Errors,
  Warnings,
  Notification,
  Information,
  Debug
}
