import 'dart:typed_data';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:politech_manager/app/extension/string_extension.dart';
import 'package:politech_manager/app/navigation/app_routes.dart';
import 'package:politech_manager/data/mapper/data_mapper.dart';
import 'package:politech_manager/domain/error/schedule_error_type.dart';
import 'package:politech_manager/domain/extension/extension.dart';
import 'package:politech_manager/domain/model/department_bo.dart';
import 'package:politech_manager/domain/model/subject_state.dart';
import 'package:politech_manager/domain/model/subject_bo.dart';
import 'package:politech_manager/domain/model/subject_state_bo.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/constant/constant.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/error/schedule_error.dart';
import '../../domain/model/classroom_bo.dart';
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

  final fileType = "".obs;

  final _semester = 1.obs;

  final _degree = ''.obs;

  final _year = ''.obs;

  final _update = false.obs;

  int get semester => _semester.value;

  final Rx<bool> _fileDownloaded = false.obs;

  bool get fileDownloaded => _fileDownloaded.value;

  String path = "";

  Rx<SubjectBO> selectedSubject = SubjectBO.mock().obs;

  final _subjectsToUpload = Rx<List<SubjectStateBO?>>([]);

  List<SubjectStateBO?> get subjectsToUpload => _subjectsToUpload.value;

  final _departmentsInCell = Rx<List<List<DepartmentBO?>>>([]);

  final _classroomsInCell = Rx<List<List<ClassroomBO?>>>([]);

  final _schedules = Rx<List<ScheduleBO>>([]);

  final showCollisions = false.obs;

  @override
  void onInit() {
    _subjects.value = argumentData['subjects'];
    _scheduleType.value = argumentData['scheduleType'];
    _semester.value = int.parse(argumentData['semester']);
    _degree.value = argumentData['degree'];
    _year.value = argumentData['year'];
    _update.value = argumentData['update'];
    if (_scheduleType.value == 'oneSubjectPerHour'.tr) {
      _subjectsToUpload.value = List.filled(maxCellsOneSubjectPerDay, null);
    } else {
      _subjectsToUpload.value = List.filled(maxCellsSeveralSubjectPerDay, null);
    }
    _getSchedules();
    super.onInit();
  }

  void _getSchedules() {
    dataRepository.getSchedules().fold(
          (left) => _onGetSchedulesKo(left),
          (right) => _onGetSchedulesOk(right),
    );
  }

  void _onGetSchedulesKo(ScheduleError scheduleError) {
    if (scheduleError.errorType == ScheduleErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => _onUpdateTokenError(), (right) => saveSchedule());
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertSchedule(scheduleError));
    }
  }

  void _onGetSchedulesOk(List<ScheduleBO> schedules) {
    hideProgress();
    _schedules.value = schedules;
    if (_update.value) {
      var subjectsObtained = _schedules.value.where((element) => element.id == argumentData['scheduleId']).first.subjects;
      for (var i = 0; i < _subjectsToUpload.value.length; i++) {
        _subjectsToUpload.value[i] = SubjectStateBO(subjectsObtained[i], SubjectState.free);
      }
    }
  }

  void hideConflicts() {
    for(var i = 0; i < _subjectsToUpload.value.length; i++) {
        _subjectsToUpload.value[i] = SubjectStateBO(_subjectsToUpload.value[i]?.subject, SubjectState.free);
    }
  }

  void showDepartmentConflicts(DepartmentBO department) {
    if (_scheduleType.value == 'oneSubjectPerHour'.tr) {
      _departmentsInCell.value = List.generate(maxCellsOneSubjectPerDay, (i) => List<DepartmentBO?>.filled(_schedules.value.length, null, growable: false), growable: false);
    } else {
      _departmentsInCell.value = List.generate(maxCellsSeveralSubjectPerDay, (i) => List<DepartmentBO?>.filled(_schedules.value.length, null, growable: false), growable: false);
    }

    for(var i = 0; i < _schedules.value.length; i++) {
      for(var j = 0; j < _schedules.value[i].subjects.length; j++) {
        if(_schedules.value[i].subjects[j]?.department.id == department.id) {
          _subjectsToUpload.value[j] = SubjectStateBO(_subjectsToUpload.value[j]?.subject, SubjectState.departmentCollision);
        }
      }
    }
  }

  void showClassroomConflicts(ClassroomBO classroom) {
    if (_scheduleType.value == 'oneSubjectPerHour'.tr) {
      _classroomsInCell.value = List.generate(maxCellsOneSubjectPerDay, (i) => List<ClassroomBO?>.filled(_schedules.value.length, null, growable: false), growable: false);
    } else {
      _classroomsInCell.value = List.generate(maxCellsSeveralSubjectPerDay, (i) => List<ClassroomBO?>.filled(_schedules.value.length, null, growable: false), growable: false);
    }

    for(var i = 0; i < _schedules.value.length; i++) {
      for(var j = 0; j < _schedules.value[i].subjects.length; j++) {
        if(_schedules.value[i].subjects[j]?.classroom.id == classroom.id) {
          _subjectsToUpload.value[j] = SubjectStateBO(_subjectsToUpload.value[j]?.subject, SubjectState.classroomCollision);
        }
      }
    }
    update();
  }

  void saveSchedule() {
    hideError();
    showProgress();
    var schedule = ScheduleBO(
        _subjectsToUpload.value.map((e) => e?.subject).toList(),
        _scheduleType.value.toScheduleTypeInt(),
        fileType.value.toFileTypeInt(),
        _degree.value,
        _semester.value.toString(),
        _year.value,
        0);
    dataRepository.postSchedule(schedule).fold(
          (left) => _onSaveScheduleKo(left),
          (right) => _onSaveScheduleOk(),
        );
  }

  void _onSaveScheduleKo(ScheduleError scheduleError) {
    if (scheduleError.errorType == ScheduleErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => _onUpdateTokenError(), (right) => saveSchedule());
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertSchedule(scheduleError));
    }
  }

  void _onSaveScheduleOk() {
    hideProgress();
    Get.offNamed(Routes.home);
  }

  void downloadFile() {
    hideError();
    showProgress();
    var schedule = ScheduleBO(
        _subjectsToUpload.value.map((e) => e?.subject).toList(),
        _scheduleType.value.toScheduleTypeInt(),
        fileType.value.toFileTypeInt(),
        _degree.value,
        _semester.value.toString(),
        _year.value,
        0);
    dataRepository.downloadSchedule(schedule).fold(
          (left) => _onDownloadScheduleKo(left),
          (right) => _onDownloadScheduleOk(right),
        );
  }

  void _onDownloadScheduleKo(ScheduleError scheduleError) {
    if (scheduleError.errorType == ScheduleErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => _onUpdateTokenError(), (right) => downloadFile());
    } else {
      hideProgress();
      showErrorMessage(errorManager.convertSchedule(scheduleError));
      showError();
    }
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
    if (Platform.isAndroid || Platform.isIOS) {
      OpenFile.open(path);
    } else if (Platform.isWindows) {
      if (await canLaunchUrl(Uri.file(path, windows: true))) {
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
    _subjects.value[pos] = _subjects.value[pos].reduceTime();
    if (_subjects.value[pos].time == 0) {
      _subjects.value.removeAt(pos);
    }
    _subjects.refresh();
    update();
  }

  String calculateDay(int index, bool mobile) {
    final module = index % 5;
    switch (module) {
      case 0:
        return mobile ? 'L'.tr : 'monday'.tr;
      case 1:
        return mobile ? 'M'.tr : 'tuesday'.tr;
      case 2:
        return mobile ? 'X'.tr : 'wednesday'.tr;
      case 3:
        return mobile ? 'J'.tr : 'thursday'.tr;
      case 4:
        return mobile ? 'V'.tr : 'friday'.tr;
      default:
        return '';
    }
  }

  int calculateIndexOfDay(String day) {
    if(day == 'L'.tr || day == 'monday'.tr) {
      return 0;
    } else if(day == 'M'.tr || day == 'tuesday'.tr) {
      return 1;
    } else if(day == 'X'.tr || day == 'wednesday'.tr) {
      return 2;
    } else if(day == 'J'.tr || day == 'thursday'.tr) {
      return 3;
    } else {
      return 4;
    }
  }

  String calculateSubjects(int index) {
    List<String> items = subjects.where((element) => !element.seminary && !element.laboratory).map((e) => e.acronym).toSet().toList();
    items.sort();
    final module = index % 5;
    switch (module) {
      case 0:
        return items.tryGet(0) ?? '';
      case 1:
        return items.tryGet(1) ?? '';
      case 2:
        return items.tryGet(2) ?? '';
      case 3:
        return items.tryGet(3) ?? '';
      case 4:
        return items.tryGet(4) ?? '';
      default:
        return '';
    }
  }

  String calculateHour(int index) {
    final int division = (index / 5).truncate();
    switch (division) {
      case 0:
        return '8:30';
      case 1:
        return '9:00';
      case 2:
        return '9:30';
      case 3:
        return '10:00';
      case 4:
        return '10:30';
      case 5:
        return '11:00';
      case 6:
        return '11:30';
      case 7:
        return '12:00';
      case 8:
        return '12:30';
      case 9:
        return '13:00';
      case 10:
        return '13:30';
      case 11:
        return '14:00';
      case 12:
        return '15:30';
      case 13:
        return '16:00';
      case 14:
        return '16:30';
      case 15:
        return '17:00';
      case 16:
        return '17:30';
      case 17:
        return '18:00';
      case 18:
        return '18:30';
      case 19:
        return '19:00';
      case 20:
        return '19:30';
      case 21:
        return '20:00';
      case 22:
        return '20:30';
      case 23:
        return '21:00';
      default:
        return 'Nan';
    }
  }

  void deleteItem(SubjectBO subject) {
    final index = _subjectsToUpload.value
        .indexWhere((element) => element?.subject?.id == subject.id);
    var targetSubject = _subjectsToUpload.value
        .firstWhere((element) => element?.subject?.id == subject.id);
    _subjectsToUpload.value[index] = null;

    final indexDraggeable =
        _subjects.value.indexWhere((element) => element.id == subject.id);
    if (indexDraggeable >= 0) {
      _subjects.value[indexDraggeable] =
          _subjects.value[indexDraggeable].addTime();
    } else {
      _subjects.value.insert(0,
          SubjectBO(
              targetSubject!.subject!.name,
              targetSubject.subject!.acronym,
              targetSubject.subject!.classGroup,
              targetSubject.subject!.seminary,
              targetSubject.subject!.laboratory,
              targetSubject.subject!.english,
              30,
              targetSubject.subject!.semester,
              targetSubject.subject!.classroom,
              targetSubject.subject!.department,
              targetSubject.subject!.degree,
              targetSubject.subject!.color,
              targetSubject.subject!.id));
    }

    _subjectsToUpload.refresh();
    _subjects.refresh();
    update();
  }

  void completeDrag(SubjectBO item, int index, bool severalSubjects) {
    if (severalSubjects) {
      List<String> columnSubject = subjects.where((element) => !element.seminary && !element.laboratory).map((e) => e.acronym).toSet().toList();
      columnSubject.sort();
      var module = index % 5;
      switch (_subjectsToUpload.value[index]?.state) {
        case SubjectState.free:
          if (columnSubject.indexOf(item.acronym) == module) {
            _subjectsToUpload.value[index] = SubjectStateBO(item, SubjectState.free);
          } else {
            showErrorMessage('incorrectColumnForSubject'.tr);
            showError();
          }
          break;
        case SubjectState.departmentCollision:
          if (columnSubject.indexOf(item.acronym) == module) {
            _subjectsToUpload.value[index] = SubjectStateBO(item, SubjectState.departmentCollision);
            showErrorMessage('departmentCollision'.tr);
            showWarning();
          } else {
            showErrorMessage('incorrectColumnForSubject'.tr);
            showError();
          }
          break;
        case SubjectState.classroomCollision:
          if (columnSubject.indexOf(item.acronym) == module) {
            _subjectsToUpload.value[index] = SubjectStateBO(null, SubjectState.classroomCollision);
            showErrorMessage('classroomCollision'.tr);
            showError();
          } else {
            showErrorMessage('incorrectColumnForSubject'.tr);
            showError();
          }
          break;
        case null:
          break;
      }
    } else {
      switch (_subjectsToUpload.value[index]?.state) {
        case SubjectState.free:
          _subjectsToUpload.value[index] = SubjectStateBO(item, SubjectState.free);
          break;
        case SubjectState.departmentCollision:
          _subjectsToUpload.value[index] = SubjectStateBO(item, SubjectState.departmentCollision);
          showErrorMessage('departmentCollision'.tr);
          showWarning();
          break;
        case SubjectState.classroomCollision:
          _subjectsToUpload.value[index] = SubjectStateBO(null, SubjectState.classroomCollision);
          showErrorMessage('classroomCollision'.tr);
          showError();
          break;
        case null:
          break;
      }
    }
  }

  void _onUpdateTokenError() {
    hideProgress();
    showError();
    showErrorMessage('Unable to update token');
  }
}
