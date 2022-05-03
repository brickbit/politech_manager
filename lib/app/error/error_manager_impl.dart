
import 'package:get/get.dart';
import 'package:politech_manager/domain/error/error_manager.dart';
import 'package:politech_manager/domain/error/login_error.dart';
import 'package:politech_manager/domain/error/login_error_type.dart';

class ErrorManagerImpl extends ErrorManager {
  @override
  String convert(LoginError error) {
      switch (error.errorType) {
        case LoginErrorType.wrongUser:
          return "wrongUserLogin".tr;
      }
  }

}