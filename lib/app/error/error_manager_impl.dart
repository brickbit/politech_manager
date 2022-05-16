
import 'package:get/get.dart';
import 'package:politech_manager/domain/error/change_password_error.dart';
import 'package:politech_manager/domain/error/change_password_error_type.dart';
import 'package:politech_manager/domain/error/classroom_error.dart';
import 'package:politech_manager/domain/error/classroom_error_type.dart';
import 'package:politech_manager/domain/error/degree_error.dart';
import 'package:politech_manager/domain/error/degree_error_type.dart';
import 'package:politech_manager/domain/error/delete_account_error.dart';
import 'package:politech_manager/domain/error/department_error.dart';
import 'package:politech_manager/domain/error/department_error_type.dart';
import 'package:politech_manager/domain/error/error_manager.dart';
import 'package:politech_manager/domain/error/exam_error.dart';
import 'package:politech_manager/domain/error/exam_error_type.dart';
import 'package:politech_manager/domain/error/login_error.dart';
import 'package:politech_manager/domain/error/login_error_type.dart';
import 'package:politech_manager/domain/error/recover_password_error.dart';
import 'package:politech_manager/domain/error/recover_password_error_type.dart';
import 'package:politech_manager/domain/error/set_new_password_error.dart';
import 'package:politech_manager/domain/error/sign_in_error.dart';
import 'package:politech_manager/domain/error/sign_in_error_type.dart';
import 'package:politech_manager/domain/error/subject_error.dart';
import 'package:politech_manager/domain/error/subject_error_type.dart';

import '../../domain/error/delete_account_error_type.dart';
import '../../domain/error/set_new_password_error_type.dart';

class ErrorManagerImpl extends ErrorManager {
  @override
  String convertLogin(LoginError error) {
      switch (error.errorType) {
        case LoginErrorType.wrongUser:
          return "wrongUserLogin".tr;
      }
  }

  @override
  String convertRecoverPwd(RecoverPasswordError error) {
    switch (error.errorType) {
      case RecoverPasswordErrorType.wrongUser:
        return "wrongUserRecoverPwd".tr;
    }
  }

  @override
  String convertNewRecoverPwd(SetNewPasswordError error) {
    switch (error.errorType) {
      case SetNewPasswordErrorType.wrongUser:
        return "wrongNewPwd".tr;
    }
  }

  @override
  String convertSignIn(SignInError error) {
    switch (error.errorType) {
      case SignInErrorType.wrongUser:
        return "wrongUserSignIn".tr;
      case SignInErrorType.passwordNotMatch:
        return "pwdNotMatch".tr;
      case SignInErrorType.incorrectPassword:
        return "incorrectPassword".tr;
      case SignInErrorType.unknownError:
        return "unknownError".tr;
    }
  }

  @override
  String convertChangePassword(ChangePasswordError error) {
    switch (error.errorType) {
      case ChangePasswordErrorType.wrongUser:
        return "errorChangingPassword".tr;
    }
  }

  @override
  String convertDeleteAccount(DeleteAccountError error) {
    switch (error.errorType) {
      case DeleteAccountErrorType.wrongUser:
        return "errorDeletingAccount".tr;
    }
  }

  @override
  String convertClassroom(ClassroomError error) {
    switch (error.errorType) {
      case ClassroomErrorType.wrongUser:
        return "errorGetClassrooms".tr;
    }
  }

  @override
  String convertDegree(DegreeError error) {
    switch (error.errorType) {
      case DegreeErrorType.wrongUser:
        return "errorGetDegrees".tr;
    }
  }

  @override
  String convertDepartment(DepartmentError error) {
    switch (error.errorType) {
      case DepartmentErrorType.wrongUser:
        return "errorGetDepartments".tr;
    }
  }

  @override
  String convertExam(ExamError error) {
    switch (error.errorType) {
      case ExamErrorType.wrongUser:
        return "errorGetExams".tr;
    }
  }

  @override
  String convertSubject(SubjectError error) {
    switch (error.errorType) {
      case SubjectErrorType.wrongUser:
        return "errorGetSubjects".tr;
    }
  }
}