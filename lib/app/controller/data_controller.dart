
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
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
import '../../domain/model/exam_bo.dart';
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

  final _subjects = Rx<List<SubjectBO>>([]);

  List<SubjectBO> get subjects => _subjects.value;

  final _exams = Rx<List<ExamBO>>([]);

  List<ExamBO> get exams => _exams.value;

  final section = <int>[0, 1, 2, 3, 4];

  void changeSection(int index) {
    _currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    _getClassrooms();
  }

  void _getClassrooms() {
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
          (left) => _onPostClassroomKo(left),
          (right) => _onPostClassroomOk(),
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
    _getDegrees();
  }

  void _onPostClassroomKo(ClassroomError classroomError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertClassroom(classroomError));
  }

  void _onPostClassroomOk() {
    hideProgress();
    _getClassrooms();
  }

  void _getDegrees() {
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
          (left) => _onPostDegreeKo(left),
          (right) => _onPostDegreeOk(),
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
    _getDepartments();
  }

  void _onPostDegreeKo(DegreeError degreeError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertDegree(degreeError));
  }

  void _onPostDegreeOk() {
    hideProgress();
    _getDegrees();
  }

  void _getDepartments() {
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
          (left) => _onPostDepartmentKo(left),
          (right) => _onPostDepartmentOk(),
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
    _getSubjects();
  }

  void _onPostDepartmentKo(DepartmentError departmentError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertDepartment(departmentError));
  }

  void _onPostDepartmentOk() {
    hideProgress();
    _getDepartments();
  }

  void _getSubjects() {
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
          (left) => _onPostSubjectKo(left),
          (right) => _onPostSubjectOk(),
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
    _getExams();
  }

  void _onPostSubjectKo(SubjectError subjectError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertSubject(subjectError));
  }

  void _onPostSubjectOk() {
    hideProgress();
    _getSubjects();
  }

  void _getExams() {
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
          (left) => _onPostExamKo(left),
          (right) => _onPostExamOk(),
    );
  }

  void _onGetExamsKo(ExamError examError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertExam(examError));
  }

  void _onGetExamsOk(List<ExamBO> exams) {
    hideProgress();
    _exams.value = exams;
  }

  void _onPostExamKo(ExamError examError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertExam(examError));
  }

  void _onPostExamOk() {
    hideProgress();
    _getExams();
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
    _getDegrees();
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
    _getDegrees();
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
    _getClassrooms();
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
    _getClassrooms();
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
    _getDepartments();
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
    _getDepartments();
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

  void updateExam(ExamBO exam) {
    hideError();
    showProgress();
    dataRepository.updateExam(exam).fold(
          (left) => _onUpdateExamKo(left),
          (right) => _onUpdateExamOk(),
    );
  }

  void _onUpdateExamKo(ExamError examError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertExam(examError));
  }

  void _onUpdateExamOk() {
    hideProgress();
    _getExams();
  }

  void deleteExam(ExamBO exam) {
    hideError();
    showProgress();
    dataRepository.deleteExam(exam.id).fold(
          (left) => _onDeleteExamKo(left),
          (right) => _onDeleteExamOk(),
    );
  }

  void _onDeleteExamKo(ExamError examError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertExam(examError));
  }

  void _onDeleteExamOk() {
    hideProgress();
    _getExams();
  }
}