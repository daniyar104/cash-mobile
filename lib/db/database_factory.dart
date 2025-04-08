import 'package:flutter/foundation.dart' show kIsWeb;
import 'app_database_helper.dart';
import 'sembast_database_helper.dart';
import 'database_helper.dart';

AppDatabaseHelper getDatabaseHelper() {
  if (kIsWeb) {
    return SembastDatabaseHelper.instance;
  } else {
    return DataBaseHelper.instance;
  }
}
