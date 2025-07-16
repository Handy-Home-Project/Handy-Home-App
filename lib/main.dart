import 'package:flutter/material.dart';
import 'package:handy_home_app/app.dart';
import 'package:handy_home_app/commons/di/di.dart';
import 'package:handy_home_app/domain/repositories/shared_prefs_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _ensureInitializedApplication();

  runApp(const HandyHomeApplication());
}

Future<void> _ensureInitializedApplication() async {
  await DependencyInjection.configure();

  await DependencyInjection.getIt
      .get<SharedPreferencesRepository>()
      .initSharedPrefs();
}
