import 'dart:ui';

class L10n{
  static final all=[
    const Locale('en'),
    const Locale('ar'),
    const Locale('fr')
  ];
  static String getFlag(String code) {
    switch (code) {
      case 'ar':
        return '🇹🇳';
        case 'fr':
          return '🇫🇷';
      case 'en':
      default:
        return '🇺🇸';
    }
  }
}