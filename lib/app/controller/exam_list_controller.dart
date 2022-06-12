import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/extension/string_extension.dart';
import 'package:politech_manager/domain/error/exam_error.dart';
import 'package:politech_manager/domain/error/exam_error_type.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/model/exam_bo.dart';
import '../../domain/model/subject_bo.dart';
import '../../domain/repository/data_repository.dart';
import 'base_controller.dart';

class ExamListController extends BaseController {
  ExamListController(
      {required this.dataRepository, required this.errorManager});

  dynamic argumentData = Get.arguments;

  final DataRepository dataRepository;

  final ErrorManager errorManager;

  final _exams = Rx<List<ExamBO>>([]);

  List<ExamBO> get exams => _exams.value;

  final _subjects = Rx<List<SubjectBO>>([]);

  List<SubjectBO> get subjects => _subjects.value;

  final _filterActive = false.obs;

  bool get filterActive => _filterActive.value;

  @override
  void onInit() {
    _exams.value = argumentData['exams'];
    _subjects.value = argumentData['subjects'];
    super.onInit();
  }

  void getExams() {
    hideError();
    showProgress();
    dataRepository.getExams().fold(
          (left) => _onGetExamsKo(left),
          (right) => _onGetExamsOk(right),
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

  void eraseFilters() {
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
