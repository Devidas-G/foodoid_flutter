import 'package:flutter/material.dart';
import 'package:foodoid/app.dart';
import 'core/engine/engine_initializer.dart';
import 'dependency_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  EngineInitializer.init();
  runApp(const MyApp());
}