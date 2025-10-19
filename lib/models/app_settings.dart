import 'package:objectbox/objectbox.dart';
import 'package:silkeborgcano/main.dart';

@Entity()
class AppSettings {
  @Id()
  int oid; // ObjectBox ID
  String filter;

  AppSettings({this.oid = 0, this.filter = 'all'});

  static AppSettings getSettings() {
    final box = objectbox.store.box<AppSettings>();
    final settingsList = box.getAll();
    if (settingsList.isEmpty) {
      final newSettings = AppSettings();
      box.put(newSettings);
      return newSettings;
    } else {
      return settingsList.first;
    }
  }

  void updateFilter(String newFilter) {
    filter = newFilter;
    objectbox.store.box<AppSettings>().put(this);
  }
}
