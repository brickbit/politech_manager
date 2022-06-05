
import 'dart:typed_data';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:politech_manager/app/extension/string_extension.dart';
import 'package:politech_manager/data/mapper/data_mapper.dart';
import 'package:politech_manager/domain/model/exam_bo.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/error/calendar_error.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/model/calendar_bo.dart';
import '../../domain/model/pair_exam_bo.dart';
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
    _getNumberOfCells();
    _examsToUpload.value = List.filled(_numberOfCells.value, PairExamBO(null,null));
    super.onInit();
  }

  void setMobile(bool mobile) {
    _mobile.value = mobile;
  }

  void _getNumberOfCells() {
    final endDateArray = _endDate.value.split("-");
    final startDateArray = _startDate.value.split("-");

    final start = DateTime(int.parse(startDateArray[2]), int.parse(startDateArray[1]), int.parse(startDateArray[1]));
    final end = DateTime(int.parse(endDateArray[2]), int.parse(endDateArray[1]), int.parse(endDateArray[0]));
    _numberOfCells.value = end.difference(start).inDays;
    List<String> array = List.filled(_numberOfCells.value, "", growable: false);
    array.asMap().forEach((index, value) {
      array[index] = DateTime(start.year, start.month, start.day + index).getString();
    });
    _dateArray.value = array;
  }

  void saveCalendar() {
    hideError();
    showProgress();
    final itemMorning = _examsToUpload.value.map((item) => item.first).toList();
    final itemAfternoon = _examsToUpload.value.map((item) => item.last);
    itemMorning.addAll(itemAfternoon);
    itemMorning.removeWhere((element) => element == null);
    var calendar = CalendarBO(itemMorning, "GIIC", "year", _startDate.value, _endDate.value, _call.value, 0);
    dataRepository.postCalendar(calendar).fold(
          (left) => _onSaveCalendarKo(left),
          (right) => _onSaveCalendarOk(),
    );
  }

  void _onSaveCalendarKo(CalendarError calendarError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertCalendar(calendarError));
  }

  void _onSaveCalendarOk() {
    hideProgress();
  }

  void downloadFile() {
    hideError();
    showProgress();
    final itemMorning = _examsToUpload.value.map((item) => item.first).toList();
    final itemAfternoon = _examsToUpload.value.map((item) => item.last);
    itemMorning.addAll(itemAfternoon);
    itemMorning.removeWhere((element) => element == null);
    var calendar = CalendarBO(itemMorning, "GIIC", "year", _startDate.value, _endDate.value, _call.value, 0);
    dataRepository.downloadCalendar(calendar).fold(
          (left) => _onDownloadCalendarKo(left),
          (right) => _onDownloadCalendarOk(right),
    );
  }

  void _onDownloadCalendarKo(CalendarError calendarError) {
    hideProgress();
    showErrorMessage(errorManager.convertCalendar(calendarError));
    showError();
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

  bool isWeekend(String date, bool morning) {
    final weekday = DateTime.parse(date).weekday;
    return weekday == 7 || (weekday == 6 && !morning);
  }

  void startDrag(int index) {
    selectedExam.value = _exams.value.firstWhere((element) =>
    _exams.value
        .map((data) => data.toExamBox())
        .toList()[index]
        .exam
        .id ==
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
    final PairExamBO cell = _examsToUpload.value[index];
    if (morning) {
      _examsToUpload.value[index] = PairExamBO(item, cell.last);
    } else {
      _examsToUpload.value[index] = PairExamBO(cell.first, item);
    }
  }

  void deleteItem(ExamBO exam, bool morning) {
    if(morning) {
      final index = _examsToUpload.value.indexWhere((element) =>
      element.first?.id == exam.id);
      _examsToUpload.value[index] = PairExamBO(null, null);
    } else {
      final index = _examsToUpload.value.indexWhere((element) =>
      element.last?.id == exam.id);
      _examsToUpload.value[index] = PairExamBO(null, null);
    }
    _exams.value.add(exam);
    _examsToUpload.refresh();
    _exams.refresh();
    update();
  }

}


