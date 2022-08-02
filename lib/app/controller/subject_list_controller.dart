import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:politech_manager/domain/error/subject_error_type.dart';
import 'package:politech_manager/domain/model/classroom_bo.dart';
import 'package:politech_manager/domain/model/degree_bo.dart';
import 'package:politech_manager/domain/model/department_bo.dart';
import 'package:politech_manager/domain/model/teacher_bo.dart';
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

  final _teachers = Rx<List<TeacherBO>>([]);

  List<TeacherBO> get teachers => _teachers.value;

  final _degrees = Rx<List<DegreeBO>>([]);

  List<DegreeBO> get degrees => _degrees.value;

  final _filterActive = false.obs;

  bool get filterActive => _filterActive.value;

  @override
  void onInit() {
    _subjects.value = argumentData['subjects'];
    _departments.value = argumentData['departments'];
    _teachers.value = argumentData['teachers'];
    _degrees.value = argumentData['degrees'];
    _classrooms.value = argumentData['classrooms'];
    super.onInit();
  }

  void getSubjects() {
    hideError();
    showProgress();
    dataRepository.getSubjects().fold(
          (left) => _onGetSubjectsKo(left),
          (right) => _onGetSubjectsOk(right),
        );
  }

  void _onGetSubjectsKo(SubjectError subjectError) {
    if (subjectError.errorType == SubjectErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => _onUpdateTokenError(), (right) => getSubjects());
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertSubject(subjectError));
    }
  }

  void _onGetSubjectsOk(List<SubjectBO> subjects) {
    hideProgress();
    _subjects.value = subjects;
  }

  void updateSubject(SubjectBO subject) {
    hideError();
    showProgress();
    dataRepository.updateSubject(subject).fold(
          (left) => _onUpdateSubjectKo(left, subject),
          (right) => _onUpdateSubjectOk(),
        );
  }

  void _onUpdateSubjectKo(SubjectError subjectError, SubjectBO subject) {
    if (subjectError.errorType == SubjectErrorType.expiredToken) {
      dataRepository.updateToken().fold(
          (left) => _onUpdateTokenError(), (right) => updateSubject(subject));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertSubject(subjectError));
    }
  }

  void _onUpdateSubjectOk() {
    hideProgress();
    getSubjects();
  }

  void deleteSubject(SubjectBO subject) {
    hideError();
    showProgress();
    dataRepository.deleteSubject(subject.id).fold(
          (left) => _onDeleteSubjectKo(left, subject),
          (right) => _onDeleteSubjectOk(),
        );
  }

  void _onDeleteSubjectKo(SubjectError subjectError, SubjectBO subject) {
    if (subjectError.errorType == SubjectErrorType.expiredToken) {
      dataRepository.updateToken().fold(
          (left) => _onUpdateTokenError(), (right) => deleteSubject(subject));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertSubject(subjectError));
    }
  }

  void _onDeleteSubjectOk() {
    hideProgress();
    getSubjects();
  }

  void getFilteredSubjects(filters) {
    var seminaryFilter = filters['seminary'] as bool?;
    var laboratoryFilter = filters['laboratory'] as bool?;
    var englishFilter = filters['english'] as bool?;
    var semesterFilter = filters['semester'] as String?;
    var classroomFilter = filters['classroom'] as ClassroomBO?;
    var departmentFilter = filters['department'] as DepartmentBO?;
    var degreeFilter = filters['degree'] as DegreeBO?;

    if (seminaryFilter != null) {
      _subjects.value = _subjects.value
          .where((element) => element.seminary == seminaryFilter)
          .toList();
    }
    if (laboratoryFilter != null) {
      _subjects.value = _subjects.value
          .where((element) => element.laboratory == laboratoryFilter)
          .toList();
    }
    if (englishFilter != null) {
      _subjects.value = _subjects.value
          .where((element) => element.english == englishFilter)
          .toList();
    }
    if (semesterFilter != null) {
      _subjects.value = _subjects.value
          .where((element) => element.semester == int.parse(semesterFilter))
          .toList();
    }
    if (classroomFilter != null) {
      _subjects.value = _subjects.value
          .where((element) => element.classroom.id == classroomFilter.id)
          .toList();
    }
    if (departmentFilter != null) {
      _subjects.value = _subjects.value
          .where((element) => element.department.id == departmentFilter.id)
          .toList();
    }
    if (degreeFilter != null) {
      _subjects.value = _subjects.value
          .where((element) => element.degree.id == degreeFilter.id)
          .toList();
    }
    _filterActive.value = true;
    update();
  }

  void eraseFilters() {
    getSubjects();
    _filterActive.value = false;
    update();
  }

  void _onUpdateTokenError() {
    hideProgress();
    showError();
    showErrorMessage('Unable to update token');
  }
}
