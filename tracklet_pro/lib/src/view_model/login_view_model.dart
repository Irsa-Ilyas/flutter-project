import 'package:tracklet_pro/src/view_model/base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  String _email = '';
  String _password = '';
  bool _rememberMe = false;

  String get email => _email;
  String get password => _password;
  bool get rememberMe => _rememberMe;

  void updateEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }

  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    notifyListeners();
  }

  // The actual login logic is handled in the login screen
  // This ViewModel only manages the state of the login form
}