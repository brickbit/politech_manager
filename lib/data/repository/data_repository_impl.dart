import 'package:either_dart/src/either.dart';

import 'package:politech_manager/domain/error/classroom_error.dart';

import 'package:politech_manager/domain/error/degree_error.dart';

import 'package:politech_manager/domain/error/department_error.dart';

import 'package:politech_manager/domain/error/exam_error.dart';
import 'package:politech_manager/domain/error/schedule_error.dart';

import 'package:politech_manager/domain/error/subject_error.dart';

import 'package:politech_manager/domain/model/classroom_bo.dart';

import 'package:politech_manager/domain/model/degree_bo.dart';

import 'package:politech_manager/domain/model/department_bo.dart';

import 'package:politech_manager/domain/model/exam_bo.dart';
import 'package:politech_manager/domain/model/response_ok_bo.dart';
import 'package:politech_manager/domain/model/schedule_bo.dart';

import 'package:politech_manager/domain/model/subject_bo.dart';

import '../../domain/repository/data_repository.dart';
import '../datasource/network_datasource.dart';

class DataRepositoryImpl extends DataRepository {
  final NetworkDataSource network;

  DataRepositoryImpl(this.network);

  @override
  Future<Either<ClassroomError, List<ClassroomBO>>> getClassrooms() async {
    final response = await network.getClassrooms();
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<DegreeError, List<DegreeBO>>> getDegrees() async {
    final response = await network.getDegrees();
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<DepartmentError, List<DepartmentBO>>> getDepartments() async {
    final response = await network.getDepartments();
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<ExamError, List<ExamBO>>> getExams() async {
    final response = await network.getExams();
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<SubjectError, List<SubjectBO>>> getSubjects() async {
    final response = await network.getSubjects();
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<ScheduleError, List<ScheduleBO>>> getSchedules() async {
    final response = await network.getSchedules();
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<ClassroomError, ResponseOkBO>> postClassroom(
      ClassroomBO classroom) async {
    final response = await network.postClassroom(classroom);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<DegreeError, ResponseOkBO>> postDegree(DegreeBO degree) async {
    final response = await network.postDegree(degree);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<DepartmentError, ResponseOkBO>> postDepartment(
      DepartmentBO department) async {
    final response = await network.postDepartment(department);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<ExamError, ResponseOkBO>> postExam(ExamBO exam) async {
    final response = await network.postExam(exam);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<SubjectError, ResponseOkBO>> postSubject(
      SubjectBO subject) async {
    final response = await network.postSubject(subject);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<ScheduleError, ResponseOkBO>> postSchedule(ScheduleBO schedule) async {
    final response = await network.postSchedule(schedule);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<ClassroomError, ResponseOkBO>> updateClassroom(
      ClassroomBO classroom) async {
    final response = await network.updateClassroom(classroom);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<DegreeError, ResponseOkBO>> updateDegree(
      DegreeBO degree) async {
    final response = await network.updateDegree(degree);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<DepartmentError, ResponseOkBO>> updateDepartment(
      DepartmentBO department) async {
    final response = await network.updateDepartment(department);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<ExamError, ResponseOkBO>> updateExam(ExamBO exam) async {
    final response = await network.updateExam(exam);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<SubjectError, ResponseOkBO>> updateSubject(
      SubjectBO subject) async {
    final response = await network.updateSubject(subject);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<ScheduleError, ResponseOkBO>> updateSchedule(ScheduleBO schedule) async {
    final response = await network.updateSchedule(schedule);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<ClassroomError, ResponseOkBO>> deleteClassroom(
      int id) async {
    final response = await network.deleteClassroom(id);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<DegreeError, ResponseOkBO>> deleteDegree(
      int id) async {
    final response = await network.deleteDegree(id);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<DepartmentError, ResponseOkBO>> deleteDepartment(
      int id) async {
    final response = await network.deleteDepartment(id);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<ExamError, ResponseOkBO>> deleteExam(int id) async {
    final response = await network.deleteExam(id);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<SubjectError, ResponseOkBO>> deleteSubject(
      int id) async {
    final response = await network.deleteSubject(id);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

  @override
  Future<Either<ScheduleError, ResponseOkBO>> deleteSchedule(int id) async {
    final response = await network.deleteSchedule(id);
    if (response.isLeft) {
      return Left(response.left);
    } else {
      return Right(response.right);
    }
  }

}
