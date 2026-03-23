import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:foodoid/app.dart';
import 'core/api/api.dart';
import 'core/engine/engine_initializer.dart';
import 'dependency_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const envFile = String.fromEnvironment(
    "ENV_FILE",
    defaultValue: ".env/.env.dev",
  );
  await dotenv.load(fileName: envFile);
  ApiConfig.apiKey = dotenv.get('API_KEY');
  await di.init();
  EngineInitializer.init();
  runApp(const MyApp());
}

//! For local development
  // flutter run --dart-define=ENV_FILE=.env/.env.dev
  // flutter run --dart-define=ENV_FILE=.env/.env.staging
  // flutter run --dart-define=ENV_FILE=.env/.env.prod

//! For build release
  //flutter build apk --dart-define=ENV_FILE=.env/.env.prod