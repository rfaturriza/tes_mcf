import 'package:flutter/material.dart';
import 'package:tes_mcf/src/config/dio_config.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  configureDio();
  runApp(MyApp(settingsController: settingsController));
}
