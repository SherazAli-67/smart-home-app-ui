import 'package:flutter/material.dart';

class AppColors {
  static const black = Color(0xFF171F46);
  static const gray = Color(0xFF5D627E);
  static const white = Color(0xFFFFFFFF);
  static const cardBackground = Color(0xFFF8F8F8);
  static const primary = Color(0xFF246BFD);
  static const primaryLight = Color(0xFF5089FF);
  static const primarySoft = Color(0xFFE5EEFF);
  static const topGlow = Color(0xFF3778FF);
  static const badgeGreen = Color(0xFF00CC9A);
  static const badgeYellow = Color(0xFFFFC107);
  static const badgeOrange = Color(0xFFFF8A00);
  static const toggleOff = Color(0x4D171F46);
  static const overlayDark = Color(0x1A171F46);
  static const arOverlay = Color(0x33246BFD);
  static const shadowLight = Color(0x0A000000);
  static const shadowPrimary = Color(0x33246BFD);
  static const primaryGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [primary, primaryLight],
  );
}
