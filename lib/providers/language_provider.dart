import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_strings.dart';

class LanguageProvider with ChangeNotifier {
  static const String _localeKey = 'app_locale';
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString(_localeKey) ?? 'en';
    _locale = Locale(langCode);
    AppStrings.currentLanguage = langCode;
    notifyListeners();
  }

  Future<void> changeLanguage(Locale newLocale) async {
    if (_locale == newLocale) return;
    _locale = newLocale;
    AppStrings.currentLanguage = newLocale.languageCode;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, newLocale.languageCode);
    
    notifyListeners();
  }
}
