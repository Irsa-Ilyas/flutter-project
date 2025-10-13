import 'package:tracklet_pro/src/view_model/base_view_model.dart';

/// WidgetViewModel - Yeh class widgets ke state management ke liye hai
/// Har widget jo state manage karna chahta hai, yeh class extend kar sakta hai
class WidgetViewModel extends BaseViewModel {
  // Loading state - jab koi operation chal raha ho
  bool _isLoading = false;
  @override
  bool get isLoading => _isLoading;

  // Error state - jab koi error aaye
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Success state - jab operation successful ho
  String _successMessage = '';
  String get successMessage => _successMessage;

  // Loading state set karna
  @override
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Error message set karna
  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Success message set karna
  void setSuccessMessage(String message) {
    _successMessage = message;
    notifyListeners();
  }

  // State ko clear karna
  void clearState() {
    _errorMessage = '';
    _successMessage = '';
    notifyListeners();
  }
}