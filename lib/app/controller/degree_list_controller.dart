
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:politech_manager/domain/model/degree_bo.dart';
import '../../domain/error/degree_error.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/repository/data_repository.dart';
import 'base_controller.dart';

class DegreeListController extends BaseController {
  DegreeListController(
      {required this.dataRepository, required this.errorManager});

  dynamic argumentData = Get.arguments;

  final DataRepository dataRepository;

  final ErrorManager errorManager;

  final _degrees = Rx<List<DegreeBO>>([]);

  List<DegreeBO> get degrees => _degrees.value;

  @override
  void onInit() {
    _degrees.value = argumentData['degrees'];
    super.onInit();
  }

  void getDegrees() {
    hideError();
    showProgress();
    dataRepository.getDegrees().fold(
          (left) => _onGetDegreesKo(left),
          (right) => _onGetDegreesOk(right),
    );
  }

  void _onGetDegreesKo(DegreeError degreeError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertDegree(degreeError));
  }

  void _onGetDegreesOk(List<DegreeBO> degrees) {
    hideProgress();
    _degrees.value = degrees;
  }

  void updateDegree(DegreeBO degree) {
    hideError();
    showProgress();
    dataRepository.updateDegree(degree).fold(
          (left) => _onUpdateDegreeKo(left),
          (right) => _onUpdateDegreeOk(),
    );
  }

  void _onUpdateDegreeKo(DegreeError degreeError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertDegree(degreeError));
  }

  void _onUpdateDegreeOk() {
    hideProgress();
    getDegrees();
  }

  void deleteDegree(DegreeBO degree) {
    hideError();
    showProgress();
    dataRepository.deleteDegree(degree.id).fold(
          (left) => _onDeleteDegreeKo(left),
          (right) => _onDeleteDegreeOk(),
    );
  }

  void _onDeleteDegreeKo(DegreeError degreeError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertDegree(degreeError));
  }

  void _onDeleteDegreeOk() {
    hideProgress();
    getDegrees();
  }
}
