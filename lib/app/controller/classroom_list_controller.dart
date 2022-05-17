
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
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
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertClassroom(classroomError));
  }

  void _onGetClassroomsOk(List<ClassroomBO> classrooms) {
    hideProgress();
    _classrooms.value = classrooms;
  }

  void updateClassroom(ClassroomBO classroom) {
    hideError();
    showProgress();
    dataRepository.updateClassroom(classroom).fold(
          (left) => _onUpdateClassroomKo(left),
          (right) => _onUpdateClassroomOk(),
    );
  }

  void _onUpdateClassroomKo(ClassroomError classroomError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertClassroom(classroomError));
  }

  void _onUpdateClassroomOk() {
    hideProgress();
    getClassrooms();
  }

  void deleteClassroom(ClassroomBO classroom) {
    hideError();
    showProgress();
    dataRepository.deleteClassroom(classroom.id).fold(
          (left) => _onDeleteClassroomKo(left),
          (right) => _onDeleteClassroomOk(),
    );
  }

  void _onDeleteClassroomKo(ClassroomError classroomError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertClassroom(classroomError));
  }

  void _onDeleteClassroomOk() {
    hideProgress();
    getClassrooms();
  }
}
