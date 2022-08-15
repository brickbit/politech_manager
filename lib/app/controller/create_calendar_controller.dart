import 'dart:typed_data';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:politech_manager/app/extension/string_extension.dart';
import 'package:politech_manager/data/mapper/data_mapper.dart';
import 'package:politech_manager/domain/error/calendar_error_type.dart';
import 'package:politech_manager/domain/model/exam_bo.dart';
import 'package:politech_manager/domain/model/exam_state.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/error/calendar_error.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/model/calendar_bo.dart';
import '../../domain/model/classroom_bo.dart';
import '../../domain/model/exam_state_bo.dart';
import '../../domain/model/pair_exam_bo.dart';
import '../../domain/model/teacher_bo.dart';
import '../../domain/repository/data_repository.dart';
import 'base_controller.dart';

class CreateCalendarController extends BaseController {
  CreateCalendarController(
      {required this.dataRepository, required this.errorManager});

  dynamic argumentData = Get.arguments;

  final DataRepository dataRepository;

  final ErrorManager errorManager;

  final _exams = Rx<List<ExamBO>>([]);

  List<ExamBO> get exams => _exams.value;

  final _startDate = "".obs;

  String get startDate => _startDate.value;

  final _endDate = "".obs;

  String get endDate => _endDate.value;

  final _call = "".obs;

  String get call => _call.value;

  final _degree = "".obs;

  String get degree => _degree.value;

  final Rx<bool> _fileDownloaded = false.obs;

  bool get fileDownloaded => _fileDownloaded.value;

  String path = "";

  Rx<ExamBO> selectedExam = ExamBO.mock().obs;

  final _numberOfCells = 0.obs;

  int get numberOfCells => _numberOfCells.value;

  final _dateArray = Rx<List<String>>([]);

  List<String> get dateArray => _dateArray.value;

  final _examsToUpload = Rx<List<PairExamBO>>([]);

  List<PairExamBO> get examsToUpload => _examsToUpload.value;

  final _mobile = false.obs;

  final _calendars = Rx<List<CalendarBO?>>([]);

  final _id = 0.obs;

  final _teachersInCell = Rx<List<TeacherBO?>>([]);

  final _classroomsInCell = Rx<List<ClassroomBO?>>([]);

  final showCollisions = false.obs;

  final _update = false.obs;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  @override
  void onInit() {
    _exams.value = argumentData['exams'];
    _startDate.value = argumentData['startDate'];
    _endDate.value = argumentData['endDate'];
    _call.value = argumentData['call'];
    _degree.value = argumentData['degree'];
    _id.value = (argumentData['calendarId'] != null) ? argumentData['calendarId'] : 0;
    _update.value = argumentData['update'];
    _getNumberOfCells();
    _examsToUpload.value =
        List.filled(_numberOfCells.value, PairExamBO(ExamStateBO(null,ExamState.free), ExamStateBO(null,ExamState.free)));
    _getCalendars();
    super.onInit();
  }

  void _getCalendars() {
    dataRepository.getCalendars().fold(
          (left) => _onGetCalendarsKo(left),
          (right) => _onGetCalendarsOk(right),
    );
  }

  void _onGetCalendarsKo(CalendarError calendarError) {
    if (calendarError.errorType == CalendarErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => _onUpdateTokenError(), (right) => saveCalendar());
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertCalendar(calendarError));
    }
  }

  void _onGetCalendarsOk(List<CalendarBO?> calendars) {
    hideProgress();
    _calendars.value = calendars;
    if (_update.value) {
      var examsObtained = _calendars.value.where((element) => element?.id == _id.value).first?.exams;
      for (var i = 0; i < _examsToUpload.value.length; i++) {
        _examsToUpload.value[i] = parseToExamStateMorning(examsObtained?[i], i);
      }
      for (var i = _examsToUpload.value.length; i < _examsToUpload.value.length*2; i++) {
        _examsToUpload.value[i - _examsToUpload.value.length] = parseToExamStateAfternoon(examsObtained?[i], i);
      }
    }
  }

  void hideConflicts() {
    for(var i = 0; i < _examsToUpload.value.length; i++) {
      _examsToUpload.value[i] = PairExamBO(
          ExamStateBO(_examsToUpload.value[i].first?.exam, ExamState.free),
          ExamStateBO(_examsToUpload.value[i].last?.exam, ExamState.free));
    }
  }

  void showTeacherConflicts(TeacherBO? teacher) {
    if(teacher != null) {
      _teachersInCell.value =
          List.filled(_numberOfCells.value, null, growable: false);

      for (var i = 0; i < _calendars.value.length; i++) {
        for (var j = 0; j < _calendars.value[i]!.exams.length; j++) {
          if (_calendars.value[i]!.exams[j]?.subject.teacher?.id ==
              teacher.id) {
            if (j < _examsToUpload.value.length) {
              _examsToUpload.value[j] = PairExamBO(
                  ExamStateBO(_examsToUpload.value[j].first?.exam,
                      ExamState.teacherCollision),
                  ExamStateBO(_examsToUpload.value[j].last?.exam,
                      _examsToUpload.value[j].last!.state));
            } else {
              _examsToUpload.value[j - _examsToUpload.value.length] =
                  PairExamBO(
                      ExamStateBO(
                          _examsToUpload.value[j - _examsToUpload.value.length]
                              .first?.exam,
                          _examsToUpload.value[j - _examsToUpload.value.length]
                              .first!.state),
                      ExamStateBO(
                          _examsToUpload.value[j - _examsToUpload.value.length]
                              .last?.exam, ExamState.teacherCollision));
            }
          }
        }
      }
    }
  }

  void showClassroomConflicts(ClassroomBO classroom) {
    _classroomsInCell.value = List.filled(_numberOfCells.value, null, growable: false);

    for(var i = 0; i < _calendars.value.length; i++) {
      for(var j = 0; j < _calendars.value[i]!.exams.length; j++) {
        if(_calendars.value[i]!.exams[j]?.subject.classroom.id == classroom.id) {
          if (j < _examsToUpload.value.length) {
            _examsToUpload.value[j] = PairExamBO(
                ExamStateBO(_examsToUpload.value[j].first?.exam, ExamState.classroomCollision),
                ExamStateBO(_examsToUpload.value[j].last?.exam, _examsToUpload.value[j].last!.state));
          } else {
            _examsToUpload.value[j - _examsToUpload.value.length] = PairExamBO(
                ExamStateBO(_examsToUpload.value[j - _examsToUpload.value.length].first?.exam, _examsToUpload.value[j - _examsToUpload.value.length].first!.state),
                ExamStateBO(_examsToUpload.value[j - _examsToUpload.value.length].last?.exam, ExamState.classroomCollision));
          }
        }
      }
    }
    update();
  }


  PairExamBO parseToExamStateMorning(ExamBO? exam, int index) {
    if (exam != null) {
      return PairExamBO(
          ExamStateBO(exam, _examsToUpload.value[index].first!.state),
          ExamStateBO(_examsToUpload.value[index].last!.exam,_examsToUpload.value[index].last!.state));
    } else {
      return PairExamBO(
          ExamStateBO(_examsToUpload.value[index].first?.exam,_examsToUpload.value[index].first!.state),
          ExamStateBO(_examsToUpload.value[index].last?.exam,_examsToUpload.value[index].last!.state));
    }
  }

  PairExamBO parseToExamStateAfternoon(ExamBO? exam, int index) {
    if (exam != null) {
        return PairExamBO(
            ExamStateBO(_examsToUpload.value[index - _examsToUpload.value.length].first?.exam, _examsToUpload.value[index - _examsToUpload.value.length].first!.state),
            ExamStateBO(exam, _examsToUpload.value[index - _examsToUpload.value.length].last!.state));
    } else {
      return PairExamBO(
          ExamStateBO(_examsToUpload.value[index].first?.exam,_examsToUpload.value[index].first!.state),
          ExamStateBO(_examsToUpload.value[index].last?.exam,_examsToUpload.value[index].last!.state));
    }
  }


  void setMobile(bool mobile) {
    _mobile.value = mobile;
  }

  void _getNumberOfCells() {
    final endDateArray = _endDate.value.split("-");
    final startDateArray = _startDate.value.split("-");

    final start = DateTime(int.parse(startDateArray[2]),
        int.parse(startDateArray[1]), int.parse(startDateArray[0]));
    final end = DateTime(int.parse(endDateArray[2]), int.parse(endDateArray[1]),
        int.parse(endDateArray[0]));
    _numberOfCells.value = end.difference(start).inDays;
    List<String> array = List.filled(_numberOfCells.value, "", growable: false);
    array.asMap().forEach((index, value) {
      array[index] =
          DateTime(start.year, start.month, start.day + index + 1).getString();
    });
    _dateArray.value = array;
  }

  void saveCalendar() {
    hideError();
    showProgress();
    final itemMorning = _examsToUpload.value.map((item) => item.first?.exam).toList();
    final itemAfternoon = _examsToUpload.value.map((item) => item.last?.exam);
    itemMorning.addAll(itemAfternoon);
    if(!_update.value) {
      var calendar = CalendarBO(
          itemMorning,
          "GIIC",
          "year",
          _startDate.value,
          _endDate.value,
          _call.value,
          0);
      dataRepository.postCalendar(calendar).fold(
            (left) => _onSaveCalendarKo(left),
            (right) => _onSaveCalendarOk(),
      );
    } else {
      var calendar = CalendarBO(
          itemMorning,
          "GIIC",
          "year",
          _startDate.value,
          _endDate.value,
          _call.value,
          _id.value);
      dataRepository.updateCalendar(calendar).fold(
            (left) => _onSaveCalendarKo(left),
            (right) => _onSaveCalendarOk(),
      );
    }
  }

  void _onSaveCalendarKo(CalendarError calendarError) {
    if (calendarError.errorType == CalendarErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => _onUpdateTokenError(), (right) => saveCalendar());
    } else {
      hideProgress();
      showError();
      showErrorMessage(errorManager.convertCalendar(calendarError));
    }
  }

  void _onSaveCalendarOk() {
    hideProgress();
  }

  void downloadFile() {
    hideError();
    showProgress();
    final itemMorning = _examsToUpload.value.map((item) => item.first?.exam).toList();
    final itemAfternoon = _examsToUpload.value.map((item) => item.last?.exam);
    itemMorning.addAll(itemAfternoon);
    itemMorning.removeWhere((element) => element == null);
    var calendar = CalendarBO(itemMorning, "GIIC", "year", _startDate.value,
        _endDate.value, _call.value, 0);
    dataRepository.downloadCalendar(calendar).fold(
          (left) => _onDownloadCalendarKo(left),
          (right) => _onDownloadCalendarOk(right),
        );
  }

  void _onDownloadCalendarKo(CalendarError calendarError) {
    if (calendarError.errorType == CalendarErrorType.expiredToken) {
      dataRepository
          .updateToken()
          .fold((left) => _onUpdateTokenError(), (right) => downloadFile());
    } else {
      hideProgress();
      showErrorMessage(errorManager.convertCalendar(calendarError));
      showError();
    }
  }

  void _onDownloadCalendarOk(Uint8List bytes) async {
    final pathAux = await _localPath;
    var scheduleFile = File('$pathAux/calendar.xlsx');
    await scheduleFile.writeAsBytes(bytes);
    path = '$pathAux/calendar.xlsx';
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

  bool isWeekend(String date, bool morning) {
    final weekday = DateTime.parse(date).weekday;
    return weekday == 7 || (weekday == 6 && !morning);
  }

  void startDrag(int index) {
    selectedExam.value = _exams.value.firstWhere((element) =>
        _exams.value.map((data) => data.toExamBox()).toList()[index].exam.id ==
        element.id);
  }

  void dragItemSuccessfully(int index) {
    selectedExam = _exams.value
        .firstWhere((element) =>
            _exams.value
                .map((data) => data.toExamBox())
                .toList()[index]
                .exam
                .id ==
            element.id)
        .obs;
    var pos = _exams.value.indexOf(selectedExam.value);
    _exams.value.removeAt(pos);
    _exams.refresh();
    update();
  }

  void restoreDraggableItem(ExamBO exam) {
    _exams.value.add(exam);
    _exams.refresh();
    update();
  }

  void completeDrag(ExamBO item, int index, bool morning) {
    if (morning) {
    switch (_examsToUpload.value[index].first!.state) {
      case ExamState.free:
        final ExamBO? cell = _examsToUpload.value[index].last?.exam;
        _examsToUpload.value[index] = PairExamBO(
            ExamStateBO(item, _examsToUpload.value[index].first!.state),
            ExamStateBO(cell, _examsToUpload.value[index].last!.state));
        break;
      case ExamState.classroomCollision:
        _handleClassroomCollision(index, item, morning);
        break;
      case ExamState.teacherCollision:
        _handleTeacherCollision(index, item, morning);
        break;
    }
    }else {
      switch (_examsToUpload.value[index].last!.state) {
        case ExamState.free:
          final ExamBO? cell = _examsToUpload.value[index].first?.exam;
          _examsToUpload.value[index] = PairExamBO(
              ExamStateBO(cell, _examsToUpload.value[index].first!.state),
              ExamStateBO(item, _examsToUpload.value[index].last!.state));
          break;
        case ExamState.classroomCollision:
          _handleClassroomCollision(index, item, morning);
          break;
        case ExamState.teacherCollision:
          _handleTeacherCollision(index, item, morning);
          break;
      }
    }
  }

  void _handleClassroomCollision(int index, ExamBO item, bool morning) {
    if (morning) {
      _examsToUpload.value[index] = PairExamBO(ExamStateBO(null, ExamState.classroomCollision),ExamStateBO(_examsToUpload.value[index].last?.exam, _examsToUpload.value[index].last!.state));
    } else {
      _examsToUpload.value[index] = PairExamBO(ExamStateBO(_examsToUpload.value[index].first?.exam, _examsToUpload.value[index].first!.state),ExamStateBO(null, ExamState.classroomCollision));
    }
    _recoverExam(item);
    showErrorMessage('classroomCollision'.tr);
    showError();
  }

  void _handleTeacherCollision(int index, ExamBO item, bool morning) {
    if (morning) {
      _examsToUpload.value[index] = PairExamBO(ExamStateBO(null, ExamState.teacherCollision),ExamStateBO(_examsToUpload.value[index].last?.exam, _examsToUpload.value[index].last!.state));
    } else {
      _examsToUpload.value[index] = PairExamBO(ExamStateBO(_examsToUpload.value[index].first?.exam, _examsToUpload.value[index].first!.state),ExamStateBO(null, ExamState.teacherCollision));
    }
    _recoverExam(item);
    showErrorMessage('teacherCollision'.tr);
    showError();
  }

  void _recoverExam(ExamBO item) {
    var exam = ExamBO(
            item.subject,
            item.acronym,
            item.semester,
            item.date,
            item.call,
            item.turn,
            item.id);
    _exams.value.add(exam);
    _exams.refresh();
    update();
  }

  void deleteItem(ExamBO exam, bool morning) {
    if (morning) {
      final index = _examsToUpload.value
          .indexWhere((element) => element.first?.exam?.id == exam.id);
      _examsToUpload.value[index] = PairExamBO(ExamStateBO(null,_examsToUpload.value[index].first!.state), ExamStateBO(null,_examsToUpload.value[index].last!.state));
    } else {
      final index = _examsToUpload.value
          .indexWhere((element) => element.last!.exam?.id == exam.id);
      _examsToUpload.value[index] = PairExamBO(ExamStateBO(null,_examsToUpload.value[index].first!.state), ExamStateBO(null,_examsToUpload.value[index].last!.state));
    }
    _exams.value.add(exam);
    _examsToUpload.refresh();
    _exams.refresh();
    update();
  }

  void _onUpdateTokenError() {
    hideProgress();
    showError();
    showErrorMessage('Unable to update token');
  }
}
