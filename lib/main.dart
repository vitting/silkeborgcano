import 'package:flutter/material.dart';
import 'package:silkeborgcano/app_entry.dart';
import 'package:silkeborgcano/objectbox_store.dart';

late ObjectBox objectbox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();
  runApp(const AppEntry());
}
