
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/error/schedule_error.dart';
import '../../domain/model/schedule_bo.dart';
import '../../domain/repository/data_repository.dart';
import 'base_controller.dart';

class ScheduleListController extends BaseController {
  ScheduleListController(
      {required this.dataRepository, required this.errorManager});

  dynamic argumentData = Get.arguments;

  final DataRepository dataRepository;

  final ErrorManager errorManager;

  final _schedules = Rx<List<ScheduleBO>>([]);

  List<ScheduleBO> get schedules => _schedules.value;

  void _getSchedules() {
    hideError();
    showProgress();
    dataRepository.getSchedules().fold(
          (left) => _onGetSchedulesKo(left),
          (right) => _onGetSchedulesOk(right),
    );
  }

  void _onGetSchedulesKo(ScheduleError scheduleError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertSchedule(scheduleError));
  }

  void _onGetSchedulesOk(List<ScheduleBO> schedules) {
    hideProgress();
    _schedules.value = schedules;
  }

  void updateSchedule(ScheduleBO schedule) {
    hideError();
    showProgress();
    dataRepository.updateSchedule(schedule).fold(
          (left) => _onUpdateScheduleKo(left),
          (right) => _onUpdateScheduleOk(),
    );
  }

  void _onUpdateScheduleKo(ScheduleError scheduleError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertSchedule(scheduleError));
  }

  void _onUpdateScheduleOk() {
    hideProgress();
    _getSchedules();
  }

  void deleteSchedule(ScheduleBO schedule) {
    hideError();
    showProgress();
    dataRepository.deleteSchedule(schedule.id).fold(
          (left) => _onDeleteScheduleKo(left),
          (right) => _onDeleteScheduleOk(),
    );
  }

  void _onDeleteScheduleKo(ScheduleError scheduleError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertSchedule(scheduleError));
  }

  void _onDeleteScheduleOk() {
    hideProgress();
    _getSchedules();
  }
}
