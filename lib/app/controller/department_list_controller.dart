
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import '../../domain/error/department_error.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/model/department_bo.dart';
import '../../domain/repository/data_repository.dart';
import 'base_controller.dart';

class DepartmentListController extends BaseController {
  DepartmentListController(
      {required this.dataRepository, required this.errorManager});

  dynamic argumentData = Get.arguments;

  final DataRepository dataRepository;

  final ErrorManager errorManager;

  final _departments = Rx<List<DepartmentBO>>([]);

  List<DepartmentBO> get departments => _departments.value;

  @override
  void onInit() {
    _departments.value = argumentData['departments'];
    super.onInit();
  }

  void getDepartments() {
    hideError();
    showProgress();
    dataRepository.getDepartments().fold(
          (left) => _onGetDepartmentsKo(left),
          (right) => _onGetDepartmentsOk(right),
    );
  }

  void _onGetDepartmentsKo(DepartmentError departmentError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertDepartment(departmentError));
  }

  void _onGetDepartmentsOk(List<DepartmentBO> departments) {
    hideProgress();
    _departments.value = departments;
  }

  void updateDepartment(DepartmentBO department) {
    hideError();
    showProgress();
    dataRepository.updateDepartment(department).fold(
          (left) => _onUpdateDepartmentKo(left),
          (right) => _onUpdateDepartmentOk(),
    );
  }

  void _onUpdateDepartmentKo(DepartmentError departmentError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertDepartment(departmentError));
  }

  void _onUpdateDepartmentOk() {
    hideProgress();
    getDepartments();
  }

  void deleteDepartment(DepartmentBO department) {
    hideError();
    showProgress();
    dataRepository.deleteDepartment(department.id).fold(
          (left) => _onDeleteDepartmentKo(left),
          (right) => _onDeleteDepartmentOk(),
    );
  }

  void _onDeleteDepartmentKo(DepartmentError departmentError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertDepartment(departmentError));
  }

  void _onDeleteDepartmentOk() {
    hideProgress();
    getDepartments();
  }
}
