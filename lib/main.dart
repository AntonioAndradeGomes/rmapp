import 'package:flutter/material.dart';
import 'package:rmapp/src/app_widget.dart';
import 'package:rmapp/src/dependencies/dependencies_injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(
    const AppWidget(),
  );
}
