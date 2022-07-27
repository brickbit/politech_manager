import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/model/schedule_filter.dart';
import 'package:politech_manager/domain/error/degree_error_type.dart';
import 'package:politech_manager/domain/error/schedule_error_type.dart';
import 'package:politech_manager/domain/error/subject_error_type.dart';
import 'package:politech_manager/domain/model/subject_bo.dart';
import '../../domain/error/degree_error.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/error/schedule_error.dart';
import '../../domain/error/subject_error.dart';
import '../../domain/model/degree_bo.dart';
import '../../domain/model/schedule_bo.dart';
import '../../domain/repository/data_repository.dart';
import '../navigation/app_routes.dart';
import 'base_controller.dart';

class ScheduleListController extends BaseController {
  ScheduleListController(
      {required this.dataRepository, required this.errorManager});

  dynamic argumentData = Get.arguments;

  final DataRepository dataRepository;

  final ErrorManager errorManager;

  final _schedules = Rx<List<ScheduleBO>>([]);

  List<ScheduleBO> get schedules => _schedules.value;

  final _degrees = Rx<List<DegreeBO>>([]);

  List<DegreeBO> get degrees => _degrees.value;

  final _subjects = Rx<List<SubjectBO>>([]);

  List<SubjectBO> get subjects => _subjects.value;

  @override
  void onInit() {
    getSchedules();
    getDegrees();
    getSubjects();
    super.onInit();
  }

  void createSchedule(ScheduleFilter scheduleFilter) {
    Get.offNamed(Routes.schedule, arguments: {
      'subjects': scheduleFilter.subjects,
      'scheduleType': scheduleFilter.scheduleType,
      'semester': scheduleFilter.semester,
      'degree': scheduleFilter.degree,
      'year': scheduleFilter.year,
      'update': false
    });
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

  void getSchedules() {
    hideError();
    showProgress();
    dataRepository.getSchedules().fold(
          (left) => _onGetSchedulesKo(left),
          (right) => _onGetSchedulesOk(right),
        );
  }

  void _onGetSchedulesKo(ScheduleError scheduleError) {
    if (scheduleError.errorType == ScheduleErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => _onUpdateTokenError(), (right) => getSchedules());
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertSchedule(scheduleError));
    }
  }

  void _onGetSchedulesOk(List<ScheduleBO> schedules) {
    hideProgress();
    _schedules.value = schedules;
  }

  void updateSchedule(ScheduleBO schedule) {
    Get.offNamed(Routes.schedule, arguments: {
      'scheduleId': schedule.id,
      'subjects': _calculateSubjectToUpload(schedule),
      'scheduleType': schedule.scheduleType == 0 ? 'oneSubjectPerHour'.tr :  'severalSubjectsPerHour'.tr,
      'semester': schedule.semester,
      'degree': schedule.degree,
      'year': schedule.year,
      'update': true
    });
  }

  List<SubjectBO> _calculateSubjectToUpload(ScheduleBO schedule) {
    List<SubjectBO> initialSubjects = subjects.where((element) => element.semester == int.parse(schedule.semester) && element.degree.name == schedule.degree).toList();
    schedule.subjects.removeWhere((value) => value == null);
    List<SubjectBO> subjectsToAdd = List.empty(growable: true);
    for (var itemA in schedule.subjects) {
      if (initialSubjects.any((element) => element.id == itemA?.id)) {
        var subject = initialSubjects.where((element) => element.id == itemA?.id).toList().first;
        var count = schedule.subjects.where((c) => c?.id == subject.id).toList().length;
        initialSubjects.remove(subject);
        subjectsToAdd.add(SubjectBO(subject.name, subject.acronym, subject.classGroup, subject.seminary, subject.laboratory, subject.english, subject.time - 30 * count, subject.semester, subject.days, subject.hours, subject.turns, subject.classroom, subject.department, subject.degree, subject.color, subject.id));
      }
    }
    for (var itemA in subjectsToAdd) {
      initialSubjects.add(itemA);
    }
    return initialSubjects;
  }

  void deleteSchedule(ScheduleBO schedule) {
    hideError();
    showProgress();
    dataRepository.deleteSchedule(schedule.id).fold(
          (left) => _onDeleteScheduleKo(left, schedule),
          (right) => _onDeleteScheduleOk(),
        );
  }

  void _onDeleteScheduleKo(ScheduleError scheduleError, ScheduleBO schedule) {
    if (scheduleError.errorType == ScheduleErrorType.expiredToken) {
      dataRepository.updateToken().fold(
          (left) => _onUpdateTokenError(), (right) => deleteSchedule(schedule));
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertSchedule(scheduleError));
    }
  }

  void _onDeleteScheduleOk() {
    hideProgress();
    getSchedules();
  }

  void _onUpdateTokenError() {
    hideProgress();
    showError();
    showErrorMessage('Unable to update token');
  }
}
