
import 'package:get/get.dart';

abstract class BaseController extends FullLifeCycleController with FullLifeCycleMixin {
  final Rx<bool> _loading = false.obs;
  final Rx<bool> _error = false.obs;
  final Rx<String> _errorMsg = "".obs;

  bool get loading => _loading.value;

  bool get error => _error.value;
  String get errorMsg => _errorMsg.value;

  @override
  void onDetached() {
    print('Base - onDetached called');
  }

  // Mandatory
  @override
  void onInactive() {
    print('Base - onInative called');
  }

  // Mandatory
  @override
  void onPaused() {
    print('Base - onPaused called');
  }

  // Mandatory
  @override
  void onResumed() {
    print('Base - onResumed called');
  }

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
    _errorMsg.value = '';
  }

  void showErrorMessage(String msg) {
    _errorMsg.value = msg;
  }
}