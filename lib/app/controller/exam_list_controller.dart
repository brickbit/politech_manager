
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:politech_manager/domain/error/exam_error.dart';
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

  @override
  void onInit() {
    _exams.value = argumentData['exams'];
    _subjects.value = argumentData['subjects'];
    super.onInit();
  }

  void _getExams() {
    hideError();
    showProgress();
    dataRepository.getExams().fold(
          (left) => _onGetExamsKo(left),
          (right) => _onGetExamsOk(right),
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
