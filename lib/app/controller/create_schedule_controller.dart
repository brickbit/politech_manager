
import 'dart:typed_data';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:politech_manager/data/mapper/data_mapper.dart';
import 'package:politech_manager/domain/model/subject_bo.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/constant/constant.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/error/schedule_error.dart';
import '../../domain/model/schedule_bo.dart';
import '../../domain/repository/data_repository.dart';
import 'base_controller.dart';

class CreateScheduleController extends BaseController {
  CreateScheduleController(
      {required this.dataRepository, required this.errorManager});

  dynamic argumentData = Get.arguments;

  final DataRepository dataRepository;

  final ErrorManager errorManager;

  final _subjects = Rx<List<SubjectBO>>([]);

  List<SubjectBO> get subjects => _subjects.value;

  final _scheduleType = "".obs;

  String get scheduleType => _scheduleType.value;

  final _semester = 1.obs;

  int get semester => _semester.value;

  final Rx<bool> _fileDownloaded = false.obs;

  bool get fileDownloaded => _fileDownloaded.value;

  String path = "";

  Rx<SubjectBO> selectedSubject = SubjectBO.mock().obs;

  final _subjectsToUpload = Rx<List<SubjectBO?>>([]);

  List<SubjectBO?> get subjectsToUpload => _subjectsToUpload.value;

  @override
  void onInit() {
    _subjects.value = argumentData['subjects'];
    _scheduleType.value = argumentData['scheduleType'];
    _semester.value = argumentData['semester'];
    _subjectsToUpload.value = List.filled(maxCellsOneSubjectPerDay, null);
    super.onInit();
  }

  void saveSchedule() {
    hideError();
    showProgress();
    var schedule = ScheduleBO([], 0, 0, "degree", "year", 0);
    dataRepository.postSchedule(schedule).fold(
          (left) => _onSaveScheduleKo(left),
          (right) => _onSaveScheduleOk(),
    );
  }

  void _onSaveScheduleKo(ScheduleError scheduleError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertSchedule(scheduleError));
  }

  void _onSaveScheduleOk() {
    hideProgress();
  }


  void downloadFile() {
    hideError();
    showProgress();
    var schedule = ScheduleBO([], 0, 0, "degree", "year", 0);
    dataRepository.downloadSchedule(schedule).fold(
          (left) => _onDownloadScheduleKo(left),
          (right) => _onDownloadScheduleOk(right),
    );
  }

  void _onDownloadScheduleKo(ScheduleError scheduleError) {
    hideProgress();
    showErrorMessage(errorManager.convertSchedule(scheduleError));
    showError();
  }

  void _onDownloadScheduleOk(Uint8List bytes) async {
    final pathAux = await _localPath;
    var scheduleFile = File('$pathAux/schedule.xlsx');
    await scheduleFile.writeAsBytes(bytes);
    path = '$pathAux/schedule.xlsx';
    hideProgress();
    _fileDownloaded.value = true;
  }

  void openFile() async {
    if(Platform.isAndroid || Platform.isIOS) {
      OpenFile.open(path);
    } else if (Platform.isWindows) {
      if (await canLaunchUrl(Uri.file(path,windows: true))) {
        await launchUrl(Uri.file(path, windows: true));
      } else {
        showErrorMessage('canNotOpenDocument'.tr);
        showError();
      }
    } else {
      if (await canLaunchUrl(Uri.parse("file://$path"))) {
        await launchUrl(Uri.parse("file://$path"));
      } else {
        showErrorMessage('canNotOpenDocument'.tr);
        showError();
      }
    }
    _fileDownloaded.value = false;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  void startDrag(int index) {
    selectedSubject.value = _subjects.value.firstWhere((element) =>
    _subjects.value
        .map((data) => data.toSubjectBox())
        .toList()[index]
        .subject
        .id ==
        element.id);
  }

  void dragItemSuccessfully(int index) {
    selectedSubject = _subjects.value
        .firstWhere((element) =>
    _subjects.value
        .map((data) => data.toSubjectBox())
        .toList()[index]
        .subject
        .id ==
        element.id)
        .obs;
    var pos = _subjects.value.indexOf(selectedSubject.value);
    if (_subjects.value[pos].time == 0) {
      _subjects.value.removeAt(pos);
    }
    update();
  }

  String calculateDay(int index) {
    final module = index%5;
    switch (module) {
      case 0: return 'L';
      case 1: return 'M';
      case 2: return 'X';
      case 3: return 'J';
      case 4: return 'V';
      default: return '';
    }
  }

  String calculateHour(int index) {
    final int division = (index/5).truncate();
    switch (division) {
      case 0: return '8:30';
      case 1: return '9:00';
      case 2: return '9:30';
      case 3: return '10:00';
      case 4: return '10:30';
      case 5: return '11:00';
      case 6: return '11:30';
      case 7: return '12:00';
      case 8: return '12:30';
      case 9: return '13:00';
      case 10: return '13:30';
      case 11: return '14:00';
      case 12: return '14:30';
      case 13: return '15:30';
      case 14: return '16:00';
      case 15: return '16:30';
      case 16: return '17:00';
      case 17: return '17:30';
      case 18: return '18:00';
      case 19: return '18:30';
      case 20: return '19:00';
      case 21: return '19:30';
      case 22: return '20:00';
      case 23: return '20:30';
      case 24: return '21:00';
      default: return 'Nan';
    }
  }

  void deleteItem(SubjectBO subject) {
    final index = _subjectsToUpload.value.indexWhere((element) =>
    element?.id == subject.id);
    _subjectsToUpload.value[index] = null;

    _subjects.value.add(subject);
    _subjectsToUpload.refresh();
    _subjects.refresh();
    update();
  }

  void completeDrag(SubjectBO item, int index) {
    _subjectsToUpload.value[index] = item;
  }

}
