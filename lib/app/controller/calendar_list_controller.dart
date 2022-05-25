import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/extension/datetime_extension.dart';
import 'package:politech_manager/app/extension/string_extension.dart';
import 'package:politech_manager/app/model/calendar_filter.dart';
import '../../domain/error/calendar_error.dart';
import '../../domain/error/degree_error.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/error/exam_error.dart';
import '../../domain/model/calendar_bo.dart';
import '../../domain/model/degree_bo.dart';
import '../../domain/model/exam_bo.dart';
import '../../domain/repository/data_repository.dart';
import '../navigation/app_routes.dart';
import 'base_controller.dart';

class CalendarListController extends BaseController {
  CalendarListController(
      {required this.dataRepository, required this.errorManager});

  dynamic argumentData = Get.arguments;

  final DataRepository dataRepository;

  final ErrorManager errorManager;

  final _calendars = Rx<List<CalendarBO>>([]);

  List<CalendarBO> get calendars => _calendars.value;

  final _exams = Rx<List<ExamBO>>([]);

  List<ExamBO> get exams => _exams.value;

  final _degrees = Rx<List<DegreeBO>>([]);

  List<DegreeBO> get degrees => _degrees.value;

  @override
  void onInit() {
    getCalendars();
    getExams();
    getDegrees();
    super.onInit();
  }

  @override
  void onResumed() {
    getCalendars();
    getExams();
    getDegrees();
    super.onResumed();
  }

  void getCalendars() {
    hideError();
    showProgress();
    dataRepository.getCalendars().fold(
          (left) => _onGetCalendarsKo(left),
          (right) => _onGetCalendarsOk(right),
        );
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

  void _onGetCalendarsKo(CalendarError calendarError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertCalendar(calendarError));
  }

  void _onGetCalendarsOk(List<CalendarBO> calendars) {
    hideProgress();
    _calendars.value = calendars;
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
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertExam(examError));
  }

  void _onGetExamsOk(List<ExamBO> exams) {
    hideProgress();
    _exams.value = exams;
  }

  void deleteCalendar(CalendarBO calendar) {
    hideError();
    showProgress();
    dataRepository.deleteCalendar(calendar.id).fold(
          (left) => _onDeleteCalendarKo(left),
          (right) => _onDeleteCalendarOk(),
        );
  }

  void _onDeleteCalendarKo(CalendarError calendarError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertCalendar(calendarError));
  }

  void _onDeleteCalendarOk() {
    hideProgress();
    getCalendars();
  }

  void createCalendar(CalendarFilter calendarFilter) {
    if (calendarFilter.startDate == DateTime.now().dateToString() ||
        calendarFilter.endDate == DateTime.now().dateToString()) {
      showErrorMessage('emptyDatesError'.tr);
      showError();
    } else {
      if (calendarFilter.startDate.previousThan(calendarFilter.endDate)) {
        Get.toNamed(Routes.calendar, arguments: {
          'exams': calendarFilter.exams,
          'startDate': calendarFilter.startDate,
          'endDate': calendarFilter.endDate,
          'call': calendarFilter.call,
          'degree': calendarFilter.degree,
        });
      } else {
        showErrorMessage('datesError'.tr);
        showError();
      }
    }
  }

  /*void updateSchedule(ScheduleBO schedule) {
    //TODO: fix server model
    /*var candidateSubjects = subjects.where((element) => element.semester == int.parse(schedule.semester) && element.degree.id == schedule.degree.id).toList();
    Get.toNamed(Routes.schedule, arguments: {
      'subjects': candidateSubjects,
      'savedSubjects': schedule.subjects
      'scheduleType': schedule.type,
      'semester': scheduleFilter.semester,
    });*/
    /*hideError();
    showProgress();
    dataRepository.updateSchedule(schedule).fold(
          (left) => _onUpdateScheduleKo(left),
          (right) => _onUpdateScheduleOk(),
    );*/
  }

  void _onUpdateScheduleKo(ScheduleError scheduleError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertSchedule(scheduleError));
  }

  void _onUpdateScheduleOk() {
    hideProgress();
    getSchedules();
  }*/
}
