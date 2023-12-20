// ignore: depend_on_referenced_packages
import 'package:stack_trace/stack_trace.dart';

import 'package:free_indeed/Managers/LoggerManager.dart';


class LoggerManagerImpl implements LoggerManager {
  final LogLevel _maxLevel;

  static  LoggerManagerImpl? _instance;

  static LoggerManagerImpl get instance {
    _instance ??= LoggerManagerImpl._private(
          LogLevel.Debug); // Should read max level from config
    return _instance!;
  }

  LoggerManagerImpl._private(LogLevel maxLevel) : _maxLevel = maxLevel;

  @override
  void log({required String message, LogLevel level = LogLevel.Debug}) {
    if (level.index <= _maxLevel.index) {
      Frame traceFrame = Trace.current().terse.frames.elementAt(1);
      print(
          "[ ${traceFrame.member} ${traceFrame.line}:${traceFrame.column} ] => $message");
    }
  }
}
