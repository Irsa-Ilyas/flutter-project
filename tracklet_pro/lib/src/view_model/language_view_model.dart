import 'package:tracklet_pro/src/view_model/base_view_model.dart';

class LanguageViewModel extends BaseViewModel {
  String _selectedLanguage = 'en'; // Default to English
  String get selectedLanguage => _selectedLanguage;

  void selectLanguage(String languageCode) {
    _selectedLanguage = languageCode;
    notifyListeners();
  }
}