import 'package:hive_flutter/hive_flutter.dart';
import '../../models/user.dart';

class HiveService {
  static const String usersBoxName = 'usersBox';
  static const String sessionBoxName = 'sessionBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }

    try {
      await Hive.openBox<User>(usersBoxName);
      await Hive.openBox<String>(sessionBoxName);
    } catch (e) {
      // If there's a schema mismatch, delete old boxes and recreate
      print('Error opening Hive boxes: $e');
      print('Clearing old Hive data...');
      await Hive.deleteBoxFromDisk(usersBoxName);
      await Hive.deleteBoxFromDisk(sessionBoxName);
      await Hive.openBox<User>(usersBoxName);
      await Hive.openBox<String>(sessionBoxName);
    }
  }

  static Box<User> usersBox() => Hive.box<User>(usersBoxName);
  static Box<String> sessionBox() => Hive.box<String>(sessionBoxName);
}
