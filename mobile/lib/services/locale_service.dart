import 'dart:io';
import 'package:flutter/foundation.dart';
import '../constants/strings.dart';

class LocaleService {
  static final ValueNotifier<bool> isHindiNotifier = ValueNotifier<bool>(false);

  static Future<void> init() async {
    try {
      final file = File('${Directory.systemTemp.path}/agribridge_locale.txt');
      if (await file.exists()) {
        final content = await file.readAsString();
        isHindiNotifier.value = content.trim() == 'hi';
        AppStrings.isHindi = isHindiNotifier.value;
      }
    } catch (_) {
      // In-memory fallback
    }
  }

  static Future<void> toggleLanguage() async {
    isHindiNotifier.value = !isHindiNotifier.value;
    AppStrings.isHindi = isHindiNotifier.value;
    try {
      final file = File('${Directory.systemTemp.path}/agribridge_locale.txt');
      await file.writeAsString(isHindiNotifier.value ? 'hi' : 'en');
    } catch (_) {
      // Ignored
    }
  }

  static void setLanguage(bool hindi) async {
    isHindiNotifier.value = hindi;
    AppStrings.isHindi = hindi;
    try {
      final file = File('${Directory.systemTemp.path}/agribridge_locale.txt');
      await file.writeAsString(hindi ? 'hi' : 'en');
    } catch (_) {
      // Ignored
    }
  }
}
