import 'package:tracklet_pro/src/view_model/base_view_model.dart';

class SplashViewModel extends BaseViewModel {
  bool _isLoading = true;
  @override
  bool get isLoading => _isLoading;

  @override
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> checkAuthenticationStatus() async {
    try {
      setLoading(true);
      // Simulate checking authentication status
      await Future.delayed(const Duration(seconds: 2));
      setLoading(false);
      notifyListeners();
    } catch (e) {
      setLoading(false);
      notifyListeners();
      rethrow;
    }
  }
}