// ignore_for_file: avoid_print

import 'package:logging/logging.dart' as logging;

class LoggingService {
  static LoggingService? _instance;

  factory LoggingService() {
    return _instance ??= LoggingService._();
  }

  LoggingService._();

  void initialize() {
    print('Initializing...');
    logging.Logger.root.level = logging.Level.ALL;
    logging.Logger.root.onRecord.listen((record) {
      print('${record.level.name} [${record.loggerName}] ${record.message}');

      if (record.error != null) {
        print(record.error);
      }
      if (record.stackTrace != null) {
        print(record.stackTrace);
      }
    });
  }
}
