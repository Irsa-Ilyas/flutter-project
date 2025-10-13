import 'package:tracklet_pro/src/view_model/base_view_model.dart';

class NavigationViewModel extends BaseViewModel {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void navigateToIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}