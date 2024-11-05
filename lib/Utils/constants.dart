import 'dart:ui';
import 'package:flutter/material.dart';

class RapiditoConstants {
  static const String appName = 'Rapidito';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Rapidito es una aplicacion para encontrar las entidades mas cercanas a ti y garantizar tu licencia e conducir.';
  static const String appTermsAndConditions =
      'By using this app, you agree to our terms and conditions.';
  static const String appPrivacyPolicy =
      'By using this app, you agree to our privacy policy.';
  static const String appContactEmail = '';
}

class RapiditoColors {
  static const Color primaryColor = Colors.red;
  static const Color secondaryColor = Color.fromARGB(255, 246, 100, 100);
  static const Color tertiaryColor = Color(0xFFBBDEFB);
  static const Color primaryTextColor = Color(0xFF212121);
  static const Color secondaryTextColor = Color(0xFF757575);
  static const Color tertiaryTextColor = Colors.white;
  static const Color primaryButtonColor = Colors.red;
  static const Color secondaryButtonColor = Color.fromARGB(255, 246, 100, 100);
  static const Color tertiaryButtonColor = Color(0xFFBBDEFB);
  static const Color primaryButtonTextColor = Color(0xFFFFFFFF);
  static const Color secondaryButtonTextColor = Color(0xFF212121);
  static const Color tertiaryButtonTextColor = Color(0xFF212121);
  static const Color primaryCardColor = Color(0xFFFFFFFF);
  static const Color secondaryCardColor = Color(0xFFEEEEEE);
  static const Color tertiaryCardColor = Color(0xFFE0E0E0);
  static const Color primaryIconColor = Color(0xFF212121);
  static const Color secondaryIconColor = Color(0xFF757575);
  static const Color tertiaryIconColor = Color(0xFF9E9E9E);
}

class RapiditoApi {
  static const String baseUrl = 'https://endpoint2-blond.vercel.app';
  static const String entidades = '/entidades';
}
