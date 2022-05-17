
import 'package:get/get.dart';
import 'package:politech_manager/domain/model/subject_bo.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/repository/data_repository.dart';
import 'base_controller.dart';

class CreateScheduleController extends BaseController {
  CreateScheduleController(
      {required this.dataRepository, required this.errorManager});

  dynamic argumentData = Get.arguments;

  final DataRepository dataRepository;

  final ErrorManager errorManager;

  final _subjects = Rx<List<SubjectBO>>([]);

  List<SubjectBO> get degrees => _subjects.value;

  final _scheduleType = "".obs;

  String get scheduleType => _scheduleType.value;

  final _semester = 1.obs;

  int get semester => _semester.value;

  @override
  void onInit() {
    _subjects.value = argumentData['subjects'];
    _scheduleType.value = argumentData['scheduleType'];
    _semester.value = argumentData['semester'];
    super.onInit();
  }

}
