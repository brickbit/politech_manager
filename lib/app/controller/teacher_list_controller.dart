import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:politech_manager/domain/model/teacher_bo.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/error/teacher_error.dart';
import '../../domain/error/teacher_error_type.dart';
import '../../domain/model/department_bo.dart';
import '../../domain/repository/data_repository.dart';
import 'base_controller.dart';

class TeacherListController extends BaseController {
  TeacherListController(
      {required this.dataRepository, required this.errorManager});

  dynamic argumentData = Get.arguments;

  final DataRepository dataRepository;

  final ErrorManager errorManager;

  final _teachers = Rx<List<TeacherBO>>([]);

  List<TeacherBO> get teachers => _teachers.value;

  final _departments = Rx<List<DepartmentBO>>([]);

  List<DepartmentBO> get departments => _departments.value;

  @override
  void onInit() {
    _teachers.value = argumentData['teachers'];
    _departments.value = argumentData['departments'];
    super.onInit();
  }

  void getTeachers() {
    hideError();
    showProgress();
    dataRepository.getTeachers().fold(
          (left) => _onGetTeachersKo(left),
          (right) => _onGetTeachersOk(right),
    );
  }

  void _onGetTeachersKo(TeacherError teacherError) {
    if (teacherError.errorType == TeacherErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => _onUpdateTokenError(), (right) => getTeachers());
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertTeacher(teacherError));
    }
  }

  void _onGetTeachersOk(List<TeacherBO> teachers) {
    hideProgress();
    _teachers.value = teachers;
  }

  void updateTeacher(TeacherBO teacher) {
    hideError();
    showProgress();
    dataRepository.updateTeacher(teacher).fold(
          (left) => _onUpdateTeacherKo(left, teacher),
          (right) => _onUpdateTeacherOk(),
    );
  }

  void _onUpdateTeacherKo(
      TeacherError teacherError, TeacherBO teacher) {
    if (teacherError.errorType == TeacherErrorType.expiredToken) {
      dataRepository.updateToken().fold((left) => _onUpdateTokenError(),
              (right) => updateTeacher(teacher));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertTeacher(teacherError));
    }
  }

  void _onUpdateTeacherOk() {
    hideProgress();
    getTeachers();
  }

  void deleteTeacher(TeacherBO teacher) {
    hideError();
    showProgress();
    dataRepository.deleteTeacher(teacher.id).fold(
          (left) => _onDeleteTeacherKo(left, teacher),
          (right) => _onDeleteTeacherOk(),
    );
  }

  void _onDeleteTeacherKo(
      TeacherError teacherError, TeacherBO teacher) {
    if (teacherError.errorType == TeacherErrorType.expiredToken) {
      dataRepository.updateToken().fold((left) => _onUpdateTokenError(),
              (right) => deleteTeacher(teacher));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertTeacher(teacherError));
    }
  }

  void _onDeleteTeacherOk() {
    hideProgress();
    getTeachers();
  }

  void _onUpdateTokenError() {
    hideProgress();
    showError();
    showErrorMessage('Unable to update token');
  }
}
