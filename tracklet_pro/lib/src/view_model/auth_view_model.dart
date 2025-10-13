import 'package:tracklet_pro/src/view_model/base_view_model.dart';

class AuthViewModel extends BaseViewModel {
  
  bool _isLoading = false;
  @override
  bool get isLoading => _isLoading;

  @override
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      setLoading(true);
      // In a real implementation, you would use the auth repository
      // For now, we'll simulate the login process
      await Future.delayed(const Duration(seconds: 1));
      setLoading(false);
      notifyListeners();
    } catch (e) {
      setLoading(false);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      setLoading(true);
      // Perform logout operations
      await Future.delayed(const Duration(milliseconds: 500));
      setLoading(false);
      notifyListeners();
    } catch (e) {
      setLoading(false);
      notifyListeners();
      rethrow;
    }
  }
}