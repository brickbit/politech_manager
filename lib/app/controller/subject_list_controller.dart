
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:politech_manager/domain/model/classroom_bo.dart';
import 'package:politech_manager/domain/model/degree_bo.dart';
import 'package:politech_manager/domain/model/department_bo.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/error/subject_error.dart';
import '../../domain/model/subject_bo.dart';
import '../../domain/repository/data_repository.dart';
import 'base_controller.dart';

class SubjectListController extends BaseController {
  SubjectListController(
      {required this.dataRepository, required this.errorManager});

  dynamic argumentData = Get.arguments;

  final DataRepository dataRepository;

  final ErrorManager errorManager;

  final _subjects = Rx<List<SubjectBO>>([]);

  List<SubjectBO> get subjects => _subjects.value;

  final _classrooms = Rx<List<ClassroomBO>>([]);

  List<ClassroomBO> get classrooms => _classrooms.value;

  final _departments = Rx<List<DepartmentBO>>([]);

  List<DepartmentBO> get departments => _departments.value;

  final _degrees = Rx<List<DegreeBO>>([]);

  List<DegreeBO> get degrees => _degrees.value;

  @override
  void onInit() {
    _subjects.value = argumentData['subjects'];
    _departments.value = argumentData['departments'];
    _degrees.value = argumentData['degrees'];
    _classrooms.value = argumentData['classrooms'];
    super.onInit();
  }

  void _getSubjects() {
    hideError();
    showProgress();
    dataRepository.getSubjects().fold(
          (left) => _onGetSubjectsKo(left),
          (right) => _onGetSubjectsOk(right),
    );
  }

  void _onGetSubjectsKo(SubjectError subjectError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertSubject(subjectError));
  }

  void _onGetSubjectsOk(List<SubjectBO> subjects) {
    hideProgress();
    _subjects.value = subjects;
  }

  void updateSubject(SubjectBO subject) {
    hideError();
    showProgress();
    dataRepository.updateSubject(subject).fold(
          (left) => _onUpdateSubjectKo(left),
          (right) => _onUpdateSubjectOk(),
    );
  }

  void _onUpdateSubjectKo(SubjectError subjectError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertSubject(subjectError));
  }

  void _onUpdateSubjectOk() {
    hideProgress();
    _getSubjects();
  }

  void deleteSubject(SubjectBO subject) {
    hideError();
    showProgress();
    dataRepository.deleteSubject(subject.id).fold(
          (left) => _onDeleteSubjectKo(left),
          (right) => _onDeleteSubjectOk(),
    );
  }

  void _onDeleteSubjectKo(SubjectError subjectError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertSubject(subjectError));
  }

  void _onDeleteSubjectOk() {
    hideProgress();
    _getSubjects();
  }
}
