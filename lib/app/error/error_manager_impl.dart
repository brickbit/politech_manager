
import 'package:get/get.dart';
import 'package:politech_manager/domain/error/calendar_error.dart';
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
import 'package:politech_manager/domain/error/schedule_error.dart';
import 'package:politech_manager/domain/error/set_new_password_error.dart';
import 'package:politech_manager/domain/error/sign_in_error.dart';
import 'package:politech_manager/domain/error/sign_in_error_type.dart';
import 'package:politech_manager/domain/error/subject_error.dart';
import 'package:politech_manager/domain/error/subject_error_type.dart';

import '../../domain/error/calendar_error_type.dart';
import '../../domain/error/delete_account_error_type.dart';
import '../../domain/error/schedule_error_type.dart';
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
      case ChangePasswordErrorType.expiredToken:
        return '';//Managed, do not show it
    }
  }

  @override
  String convertDeleteAccount(DeleteAccountError error) {
    switch (error.errorType) {
      case DeleteAccountErrorType.wrongUser:
        return "errorDeletingAccount".tr;
      case DeleteAccountErrorType.expiredToken:
        return '';//Managed, do not show it
    }
  }

  @override
  String convertClassroom(ClassroomError error) {
    switch (error.errorType) {
      case ClassroomErrorType.wrongUser:
        return "errorGetClassrooms".tr;
      case ClassroomErrorType.expiredToken:
        return '';//Managed, do not show it
    }
  }

  @override
  String convertDegree(DegreeError error) {
    switch (error.errorType) {
      case DegreeErrorType.wrongUser:
        return "errorGetDegrees".tr;
      case DegreeErrorType.expiredToken:
        return '';//Managed, do not show it
    }
  }

  @override
  String convertDepartment(DepartmentError error) {
    switch (error.errorType) {
      case DepartmentErrorType.wrongUser:
        return "errorGetDepartments".tr;
      case DepartmentErrorType.expiredToken:
        return '';//Managed, do not show it
    }
  }

  @override
  String convertExam(ExamError error) {
    switch (error.errorType) {
      case ExamErrorType.wrongUser:
        return "errorGetExams".tr;
      case ExamErrorType.expiredToken:
        return '';//Managed, do not show it
    }
  }

  @override
  String convertSubject(SubjectError error) {
    switch (error.errorType) {
      case SubjectErrorType.wrongUser:
        return "errorGetSubjects".tr;
      case SubjectErrorType.expiredToken:
        return '';//Managed, do not show it
    }
  }

  @override
  String convertSchedule(ScheduleError error) {
    switch (error.errorType) {
      case ScheduleErrorType.wrongUser:
        return "errorGetSchedules".tr;
      case ScheduleErrorType.expiredToken:
        return '';//Managed, do not show it
    }
  }

  @override
  String convertCalendar(CalendarError error) {
    switch (error.errorType) {
      case CalendarErrorType.wrongUser:
        return "errorGetSchedules".tr;
      case CalendarErrorType.expiredToken:
        return '';//Managed, do not show it
    }
  }
}