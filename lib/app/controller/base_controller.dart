
import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  final Rx<bool> _loading = false.obs;
  final Rx<bool> _error = false.obs;
  final Rx<String> _errorMsg = "".obs;

  bool get loading => _loading.value;

  bool get error => _error.value;
  String get errorMsg => _errorMsg.value;

  void showProgress() {
    _loading.value = true;
  }

  void hideProgress() {
    _loading.value = false;
  }

  void showError() {
    _error.value = true;
  }

  void hideError() {
    _error.value = false;
  }

  void showErrorMessage(String msg) {
    _errorMsg.value = msg;
  }
}