
import 'package:politech_manager/domain/error/classroom_error.dart';
import 'package:politech_manager/domain/error/degree_error.dart';
import 'package:politech_manager/domain/error/delete_account_error.dart';
import 'package:politech_manager/domain/error/recover_password_error.dart';
import 'package:politech_manager/domain/error/set_new_password_error.dart';
import 'package:politech_manager/domain/error/sign_in_error.dart';
import 'package:politech_manager/domain/error/subject_error.dart';
import 'department_error.dart';
import 'exam_error.dart';
import 'login_error.dart';

abstract class ErrorManager {
  String convertLogin(LoginError error);
  String convertRecoverPwd(RecoverPasswordError error);
  String convertNewRecoverPwd(SetNewPasswordError error);
  String convertSignIn(SignInError error);
  String convertDeleteAccount(DeleteAccountError error);
  String convertClassroom(ClassroomError error);
  String convertDegree(DegreeError error);
  String convertDepartment(DepartmentError error);
  String convertSubject(SubjectError error);
  String convertExam(ExamError error);
}