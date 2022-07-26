import 'package:get/get.dart';

class DashBoardController extends GetxController implements GetxService {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    update();
  }
}
