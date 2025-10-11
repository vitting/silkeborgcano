import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:silkeborgcano/app_entry.dart';
import 'package:silkeborgcano/objectbox_store.dart';

late ObjectBox objectbox;
late Admin admin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  if (Admin.isAvailable()) {
    // Keep a reference until no longer needed or manually closed.
    admin = Admin(objectbox.store);
  }

  runApp(const AppEntry());
}
