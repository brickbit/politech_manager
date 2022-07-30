import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/extension/string_extension.dart';
import 'package:politech_manager/domain/error/classroom_error_type.dart';
import 'package:politech_manager/domain/error/degree_error_type.dart';
import 'package:politech_manager/domain/error/department_error_type.dart';
import 'package:politech_manager/domain/error/exam_error_type.dart';
import 'package:politech_manager/domain/error/subject_error_type.dart';
import 'package:politech_manager/domain/model/classroom_bo.dart';
import 'package:politech_manager/domain/model/degree_bo.dart';
import 'package:politech_manager/domain/model/department_bo.dart';
import 'package:politech_manager/domain/model/subject_bo.dart';
import '../../domain/error/classroom_error.dart';
import '../../domain/error/degree_error.dart';
import '../../domain/error/department_error.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/error/exam_error.dart';
import '../../domain/error/subject_error.dart';
import '../../domain/error/teacher_error.dart';
import '../../domain/error/teacher_error_type.dart';
import '../../domain/model/exam_bo.dart';
import '../../domain/model/teacher_bo.dart';
import '../../domain/repository/data_repository.dart';
import 'base_controller.dart';

class DataController extends BaseController {
  DataController({required this.dataRepository, required this.errorManager});

  final DataRepository dataRepository;

  final ErrorManager errorManager;

  final _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  final _degrees = Rx<List<DegreeBO>>([]);

  List<DegreeBO> get degrees => _degrees.value;

  final _classrooms = Rx<List<ClassroomBO>>([]);

  List<ClassroomBO> get classrooms => _classrooms.value;

  final _departments = Rx<List<DepartmentBO>>([]);

  List<DepartmentBO> get departments => _departments.value;

  final _teachers = Rx<List<TeacherBO>>([]);

  List<TeacherBO> get teachers => _teachers.value;

  final _subjects = Rx<List<SubjectBO>>([]);

  List<SubjectBO> get subjects => _subjects.value;

  final _exams = Rx<List<ExamBO>>([]);

  List<ExamBO> get exams => _exams.value;

  final _filterActive = false.obs;

  bool get filterActive => _filterActive.value;

  final section = <int>[0, 1, 2, 3, 4];

  void changeSection(int index) {
    _currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    getClassrooms();
  }

  void getClassrooms() {
    hideError();
    showProgress();
    dataRepository.getClassrooms().fold(
          (left) => _onGetClassroomsKo(left),
          (right) => _onGetClassroomsOk(right),
        );
  }

  void uploadClassroom(ClassroomBO classroom) {
    hideError();
    showProgress();
    dataRepository.postClassroom(classroom).fold(
          (left) => _onPostClassroomKo(left, classroom),
          (right) => _onPostClassroomOk(),
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
    getDegrees();
  }

  void _onPostClassroomKo(
      ClassroomError classroomError, ClassroomBO classroom) {
    if (classroomError.errorType == ClassroomErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => null, (right) => uploadClassroom(classroom));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertClassroom(classroomError));
    }
  }

  void _onPostClassroomOk() {
    hideProgress();
    getClassrooms();
  }

  void getDegrees() {
    hideError();
    showProgress();
    dataRepository.getDegrees().fold(
          (left) => _onGetDegreesKo(left),
          (right) => _onGetDegreesOk(right),
        );
  }

  void uploadDegree(DegreeBO degree) {
    hideError();
    showProgress();
    dataRepository.postDegree(degree).fold(
          (left) => _onPostDegreeKo(left, degree),
          (right) => _onPostDegreeOk(),
        );
  }

  void _onGetDegreesKo(DegreeError degreeError) {
    if (degreeError.errorType == DegreeErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => _onUpdateTokenError(), (right) => getDegrees());
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertDegree(degreeError));
    }
  }

  void _onGetDegreesOk(List<DegreeBO> degrees) {
    hideProgress();
    _degrees.value = degrees;
    getDepartments();
  }

  void _onPostDegreeKo(DegreeError degreeError, DegreeBO degree) {
    if (degreeError.errorType == DegreeErrorType.expiredToken) {
      dataRepository.updateToken().fold(
          (left) => _onUpdateTokenError(), (right) => uploadDegree(degree));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertDegree(degreeError));
    }
  }

  void _onPostDegreeOk() {
    hideProgress();
    getDegrees();
  }

  void getDepartments() {
    hideError();
    showProgress();
    dataRepository.getDepartments().fold(
          (left) => _onGetDepartmentsKo(left),
          (right) => _onGetDepartmentsOk(right),
        );
  }

  void uploadDepartment(DepartmentBO department) {
    hideError();
    showProgress();
    dataRepository.postDepartment(department).fold(
          (left) => _onPostDepartmentKo(left, department),
          (right) => _onPostDepartmentOk(),
        );
  }

  void _onGetDepartmentsKo(DepartmentError departmentError) {
    if (departmentError.errorType == DepartmentErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => _onUpdateTokenError(), (right) => getDepartments());
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertDepartment(departmentError));
    }
  }

  void _onGetDepartmentsOk(List<DepartmentBO> departments) {
    hideProgress();
    _departments.value = departments;
    getTeachers();
  }

  void _onPostDepartmentKo(
      DepartmentError departmentError, DepartmentBO department) {
    if (departmentError.errorType == DepartmentErrorType.expiredToken) {
      dataRepository.updateToken().fold((left) => _onUpdateTokenError(),
          (right) => uploadDepartment(department));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertDepartment(departmentError));
    }
  }

  void _onPostDepartmentOk() {
    hideProgress();
    getDepartments();
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
    if (teacherError.errorType == DepartmentErrorType.expiredToken) {
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
    getSubjects();
  }


  void uploadTeacher(TeacherBO teacher) {
    hideError();
    showProgress();
    dataRepository.postTeacher(teacher).fold(
          (left) => _onPostTeacherKo(left, teacher),
          (right) => _onPostTeacherOk(),
    );
  }

  void _onPostTeacherKo(
      TeacherError teacherError, TeacherBO teacher) {
    if (teacherError.errorType == TeacherErrorType.expiredToken) {
      dataRepository.updateToken().fold((left) => _onUpdateTokenError(),
              (right) => uploadTeacher(teacher));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertTeacher(teacherError));
    }
  }

  void _onPostTeacherOk() {
    hideProgress();
    getTeachers();
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

  void getSubjects() {
    hideError();
    showProgress();
    dataRepository.getSubjects().fold(
          (left) => _onGetSubjectsKo(left),
          (right) => _onGetSubjectsOk(right),
        );
  }

  void uploadSubject(SubjectBO subject) {
    hideError();
    showProgress();
    dataRepository.postSubject(subject).fold(
          (left) => _onPostSubjectKo(left, subject),
          (right) => _onPostSubjectOk(),
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
    getExams();
  }

  void _onPostSubjectKo(SubjectError subjectError, SubjectBO subject) {
    if (subjectError.errorType == SubjectErrorType.expiredToken) {
      dataRepository.updateToken().fold(
          (left) => _onUpdateTokenError(), (right) => uploadSubject(subject));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertSubject(subjectError));
    }
  }

  void _onPostSubjectOk() {
    hideProgress();
    getSubjects();
  }

  void getExams() {
    hideError();
    showProgress();
    dataRepository.getExams().fold(
          (left) => _onGetExamsKo(left),
          (right) => _onGetExamsOk(right),
        );
  }

  void uploadExam(ExamBO exam) {
    hideError();
    showProgress();
    dataRepository.postExam(exam).fold(
          (left) => _onPostExamKo(left, exam),
          (right) => _onPostExamOk(),
        );
  }

  void _onGetExamsKo(ExamError examError) {
    if (examError.errorType == ExamErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => _onUpdateTokenError(), (right) => getExams());
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertExam(examError));
    }
  }

  void _onGetExamsOk(List<ExamBO> exams) {
    hideProgress();
    _exams.value = exams;
  }

  void _onPostExamKo(ExamError examError, ExamBO exam) {
    if (examError.errorType == ExamErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => _onUpdateTokenError(), (right) => uploadExam(exam));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertExam(examError));
    }
  }

  void _onPostExamOk() {
    hideProgress();
    getExams();
  }

  void updateDegree(DegreeBO degree) {
    hideError();
    showProgress();
    dataRepository.updateDegree(degree).fold(
          (left) => _onUpdateDegreeKo(left, degree),
          (right) => _onUpdateDegreeOk(),
        );
  }

  void _onUpdateDegreeKo(DegreeError degreeError, DegreeBO degree) {
    if (degreeError.errorType == DegreeErrorType.expiredToken) {
      dataRepository.updateToken().fold(
          (left) => _onUpdateTokenError(), (right) => updateDegree(degree));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertDegree(degreeError));
    }
  }

  void _onUpdateDegreeOk() {
    hideProgress();
    getDegrees();
  }

  void deleteDegree(DegreeBO degree) {
    hideError();
    showProgress();
    dataRepository.deleteDegree(degree.id).fold(
          (left) => _onDeleteDegreeKo(left, degree),
          (right) => _onDeleteDegreeOk(),
        );
  }

  void _onDeleteDegreeKo(DegreeError degreeError, DegreeBO degree) {
    if (degreeError.errorType == DepartmentErrorType.expiredToken) {
      dataRepository.updateToken().fold(
          (left) => _onUpdateTokenError(), (right) => deleteDegree(degree));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertDegree(degreeError));
    }
  }

  void _onDeleteDegreeOk() {
    hideProgress();
    getDegrees();
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
          (right) => updateClassroom(classroom));
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

  void updateDepartment(DepartmentBO department) {
    hideError();
    showProgress();
    dataRepository.updateDepartment(department).fold(
          (left) => _onUpdateDepartmentKo(left, department),
          (right) => _onUpdateDepartmentOk(),
        );
  }

  void _onUpdateDepartmentKo(
      DepartmentError departmentError, DepartmentBO department) {
    if (departmentError.errorType == DepartmentErrorType.expiredToken) {
      dataRepository.updateToken().fold((left) => _onUpdateTokenError(),
          (right) => updateDepartment(department));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertDepartment(departmentError));
    }
  }

  void _onUpdateDepartmentOk() {
    hideProgress();
    getDepartments();
  }

  void deleteDepartment(DepartmentBO department) {
    hideError();
    showProgress();
    dataRepository.deleteDepartment(department.id).fold(
          (left) => _onDeleteDepartmentKo(left, department),
          (right) => _onDeleteDepartmentOk(),
        );
  }

  void _onDeleteDepartmentKo(
      DepartmentError departmentError, DepartmentBO department) {
    if (departmentError.errorType == DepartmentErrorType.expiredToken) {
      dataRepository.updateToken().fold((left) => _onUpdateTokenError(),
          (right) => deleteDepartment(department));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertDepartment(departmentError));
    }
  }

  void _onDeleteDepartmentOk() {
    hideProgress();
    getDepartments();
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

  void updateExam(ExamBO exam) {
    hideError();
    showProgress();
    dataRepository.updateExam(exam).fold(
          (left) => _onUpdateExamKo(left, exam),
          (right) => _onUpdateExamOk(),
        );
  }

  void _onUpdateExamKo(ExamError examError, ExamBO exam) {
    if (examError.errorType == ExamErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => _onUpdateTokenError(), (right) => updateExam(exam));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertExam(examError));
    }
  }

  void _onUpdateExamOk() {
    hideProgress();
    getExams();
  }

  void deleteExam(ExamBO exam) {
    hideError();
    showProgress();
    dataRepository.deleteExam(exam.id).fold(
          (left) => _onDeleteExamKo(left, exam),
          (right) => _onDeleteExamOk(),
        );
  }

  void _onDeleteExamKo(ExamError examError, ExamBO exam) {
    if (examError.errorType == ExamErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => _onUpdateTokenError(), (right) => deleteExam(exam));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertExam(examError));
    }
  }

  void _onDeleteExamOk() {
    hideProgress();
    getExams();
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

  void getFilteredExams(filters) {
    var semesterFilter = filters['semester'] as int?;
    var callFilter = filters['call'] as String?;
    var turnFilter = filters['turn'] as String?;
    var subjectFilter = filters['subject'] as SubjectBO?;

    if (semesterFilter != null) {
      _exams.value = _exams.value
          .where((element) => element.semester == semesterFilter)
          .toList();
    }
    if (callFilter != null) {
      _exams.value = _exams.value
          .where((element) => element.call == callFilter.getCall())
          .toList();
    }
    if (turnFilter != null) {
      _exams.value = _exams.value
          .where((element) => element.turn == turnFilter.getTurn())
          .toList();
    }
    if (subjectFilter != null) {
      _exams.value = _exams.value
          .where((element) => element.subject.id == subjectFilter.id)
          .toList();
    }
    _filterActive.value = true;
    update();
  }

  void eraseSubjectFilters() {
    getSubjects();
    _filterActive.value = false;
    update();
  }

  void eraseExamFilters() {
    getExams();
    _filterActive.value = false;
    update();
  }

  void _onUpdateTokenError() {
    hideProgress();
    showError();
    showErrorMessage('Unable to update token');
  }
}
