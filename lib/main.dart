import 'package:flutter/material.dart';
import 'package:smart_home_app/constants/string_const.dart';
import 'package:smart_home_app/core/app_colors.dart';
import 'package:smart_home_app/routing/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: StringConst.appTitle,
      theme: ThemeData(brightness: .light, fontFamily: 'Urbanist', colorSchemeSeed: AppColors.primary),
      routerConfig: router,
      builder: (ctx, child) => child!,
    );
  }
}

