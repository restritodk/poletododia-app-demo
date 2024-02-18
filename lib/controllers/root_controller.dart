import 'package:get/get.dart';

class RootController extends GetxController implements GetxService{
  bool _loading = false;
  bool get loading => _loading;

  void setLoading(){
    _loading = true;
    update();
  }

  void removeLoading(){
    _loading = false;
    update();
  }
}