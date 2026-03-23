import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:foodoid/app.dart';
import 'core/api/api.dart';
import 'core/engine/engine_initializer.dart';
import 'dependency_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  ApiConfig.apiKey = dotenv.get('API_KEY');
  await di.init();
  EngineInitializer.init();
  runApp(const MyApp());
}