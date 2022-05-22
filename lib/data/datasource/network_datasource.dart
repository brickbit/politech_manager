import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:politech_manager/domain/error/login_error.dart';
import 'package:politech_manager/domain/error/recover_password_error.dart';
import 'package:politech_manager/domain/error/sign_in_error.dart';
import 'package:politech_manager/domain/model/response_login_bo.dart';
import '../../domain/error/calendar_error.dart';
import '../../domain/error/change_password_error.dart';
import '../../domain/error/classroom_error.dart';
import '../../domain/error/degree_error.dart';
import '../../domain/error/delete_account_error.dart';
import '../../domain/error/department_error.dart';
import '../../domain/error/exam_error.dart';
import '../../domain/error/schedule_error.dart';
import '../../domain/error/set_new_password_error.dart';
import '../../domain/error/subject_error.dart';
import '../../domain/model/calendar_bo.dart';
import '../../domain/model/classroom_bo.dart';
import '../../domain/model/degree_bo.dart';
import '../../domain/model/department_bo.dart';
import '../../domain/model/exam_bo.dart';
import '../../domain/model/response_ok_bo.dart';
import '../../domain/model/schedule_bo.dart';
import '../../domain/model/subject_bo.dart';

abstract class NetworkDataSource {
  Future<Either<LoginError, ResponseLoginBO>> login(
      String username, String password);
  Future<Either<RecoverPasswordError, ResponseOkBO>> recoverPassword(
      String email);
  Future<Either<SetNewPasswordError, ResponseOkBO>> resetPassword(
      String password, String token);
  Future<Either<SignInError, ResponseOkBO>> signIn(
      String user, String email, String password, String repeatPassword);
  void logout();
  Future<Either<DeleteAccountError, ResponseOkBO>> deleteUser();
  Future<Either<ClassroomError, List<ClassroomBO>>> getClassrooms();
  Future<Either<DegreeError, List<DegreeBO>>> getDegrees();
  Future<Either<DepartmentError, List<DepartmentBO>>> getDepartments();
  Future<Either<SubjectError, List<SubjectBO>>> getSubjects();
  Future<Either<ExamError, List<ExamBO>>> getExams();
  Future<Either<ScheduleError, List<ScheduleBO>>> getSchedules();
  Future<Either<CalendarError, List<CalendarBO>>> getCalendars();
  Future<Either<ClassroomError, ResponseOkBO>> postClassroom(
      ClassroomBO classroom);
  Future<Either<DegreeError, ResponseOkBO>> postDegree(DegreeBO degree);
  Future<Either<DepartmentError, ResponseOkBO>> postDepartment(
      DepartmentBO department);
  Future<Either<SubjectError, ResponseOkBO>> postSubject(SubjectBO subject);
  Future<Either<ExamError, ResponseOkBO>> postExam(ExamBO exam);
  Future<Either<ScheduleError, ResponseOkBO>> postSchedule(ScheduleBO schedule);
  Future<Either<ClassroomError, ResponseOkBO>> updateClassroom(
      ClassroomBO classroom);
  Future<Either<DegreeError, ResponseOkBO>> updateDegree(DegreeBO degree);
  Future<Either<DepartmentError, ResponseOkBO>> updateDepartment(
      DepartmentBO department);
  Future<Either<SubjectError, ResponseOkBO>> updateSubject(SubjectBO subject);
  Future<Either<ExamError, ResponseOkBO>> updateExam(ExamBO exam);
  Future<Either<ScheduleError, ResponseOkBO>> updateSchedule(ScheduleBO schedule);
  Future<Either<ClassroomError, ResponseOkBO>> deleteClassroom(int id);
  Future<Either<DegreeError, ResponseOkBO>> deleteDegree(int id);
  Future<Either<DepartmentError, ResponseOkBO>> deleteDepartment(int id);
  Future<Either<SubjectError, ResponseOkBO>> deleteSubject(int id);
  Future<Either<ExamError, ResponseOkBO>> deleteExam(int id);
  Future<Either<ChangePasswordError, ResponseOkBO>> changePassword(String oldPassword, String newPassword);
  Future<Either<ScheduleError, ResponseOkBO>> deleteSchedule(int id);
  Future<Either<CalendarError, ResponseOkBO>> deleteCalendar(int id);
  Future<Either<ScheduleError, Uint8List>> downloadSchedule(ScheduleBO schedule);
}
