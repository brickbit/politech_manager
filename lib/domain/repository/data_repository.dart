import 'package:either_dart/either.dart';
import 'package:politech_manager/domain/error/classroom_error.dart';
import 'package:politech_manager/domain/error/degree_error.dart';
import 'package:politech_manager/domain/error/department_error.dart';
import 'package:politech_manager/domain/error/exam_error.dart';
import 'package:politech_manager/domain/error/subject_error.dart';
import 'package:politech_manager/domain/model/response_ok_bo.dart';
import '../error/schedule_error.dart';
import '../model/classroom_bo.dart';
import '../model/degree_bo.dart';
import '../model/department_bo.dart';
import '../model/exam_bo.dart';
import '../model/schedule_bo.dart';
import '../model/subject_bo.dart';

abstract class DataRepository {
  Future<Either<ClassroomError, List<ClassroomBO>>> getClassrooms();
  Future<Either<DegreeError, List<DegreeBO>>> getDegrees();
  Future<Either<DepartmentError, List<DepartmentBO>>> getDepartments();
  Future<Either<SubjectError, List<SubjectBO>>> getSubjects();
  Future<Either<ExamError, List<ExamBO>>> getExams();
  Future<Either<ScheduleError, List<ScheduleBO>>> getSchedules();
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
  Future<Either<ScheduleError, ResponseOkBO>> deleteSchedule(int id);
  Future<Either<ScheduleError, ResponseOkBO>> downloadSchedule(ScheduleBO schedule);
}
