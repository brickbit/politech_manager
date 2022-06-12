import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:politech_manager/domain/error/classroom_error_type.dart';
import 'package:politech_manager/domain/model/classroom_bo.dart';
import '../../domain/error/classroom_error.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/repository/data_repository.dart';
import 'base_controller.dart';

class ClassroomListController extends BaseController {
  ClassroomListController(
      {required this.dataRepository, required this.errorManager});

  dynamic argumentData = Get.arguments;

  final DataRepository dataRepository;

  final ErrorManager errorManager;

  final _classrooms = Rx<List<ClassroomBO>>([]);

  List<ClassroomBO> get classrooms => _classrooms.value;

  @override
  void onInit() {
    _classrooms.value = argumentData['classrooms'];
    super.onInit();
  }

  void getClassrooms() {
    hideError();
    showProgress();
    dataRepository.getClassrooms().fold(
          (left) => _onGetClassroomsKo(left),
          (right) => _onGetClassroomsOk(right),
        );
  }

  void _onGetClassroomsKo(ClassroomError classroomError) {
    if (classroomError.errorType == ClassroomErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => _onUpdateTokenError(), (right) => getClassrooms());
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertClassroom(classroomError));
    }
  }

  void _onGetClassroomsOk(List<ClassroomBO> classrooms) {
    hideProgress();
    _classrooms.value = classrooms;
  }

  void updateClassroom(ClassroomBO classroom) {
    hideError();
    showProgress();
    dataRepository.updateClassroom(classroom).fold(
          (left) => _onUpdateClassroomKo(left, classroom),
          (right) => _onUpdateClassroomOk(),
        );
  }

  void _onUpdateClassroomKo(
      ClassroomError classroomError, ClassroomBO classroom) {
    if (classroomError.errorType == ClassroomErrorType.expiredToken) {
      dataRepository.updateToken().fold((left) => _onUpdateTokenError(),
          (right) => updateClassroom(classroom));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertClassroom(classroomError));
    }
  }

  void _onUpdateClassroomOk() {
    hideProgress();
    getClassrooms();
  }

  void deleteClassroom(ClassroomBO classroom) {
    hideError();
    showProgress();
    dataRepository.deleteClassroom(classroom.id).fold(
          (left) => _onDeleteClassroomKo(left, classroom),
          (right) => _onDeleteClassroomOk(),
        );
  }

  void _onDeleteClassroomKo(
      ClassroomError classroomError, ClassroomBO classroom) {
    if (classroomError.errorType == ClassroomErrorType.expiredToken) {
      dataRepository.updateToken().fold((left) => _onUpdateTokenError(),
          (right) => deleteClassroom(classroom));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertClassroom(classroomError));
    }
  }

  void _onDeleteClassroomOk() {
    hideProgress();
    getClassrooms();
  }

  void _onUpdateTokenError() {
    hideProgress();
    showError();
    showErrorMessage('Unable to update token');
  }
}
