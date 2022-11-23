enum LogLevel {
  verbose,
  info,
  warning,
  error,
  success,
}

extension LogLevelExtension on LogLevel {
  static const Map<LogLevel, int> logLevelCodes = <LogLevel, int>{
    LogLevel.verbose: 0,
    LogLevel.info: 1,
    LogLevel.warning: 2,
    LogLevel.error: 3,
    LogLevel.success: 4,
  };

  int get code => logLevelCodes[this] ?? 4;
}
