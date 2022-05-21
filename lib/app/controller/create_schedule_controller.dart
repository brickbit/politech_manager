
import 'dart:typed_data';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:politech_manager/domain/model/subject_bo.dart';
import 'package:url_launcher/url_launcher.dart';
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

  List<SubjectBO> get degrees => _subjects.value;

  final _scheduleType = "".obs;

  String get scheduleType => _scheduleType.value;

  final _semester = 1.obs;

  int get semester => _semester.value;

  final Rx<bool> _fileDownloaded = false.obs;

  bool get fileDownloaded => _fileDownloaded.value;

  String path = "";

  @override
  void onInit() {
    _subjects.value = argumentData['subjects'];
    _scheduleType.value = argumentData['scheduleType'];
    _semester.value = argumentData['semester'];
    super.onInit();
  }

  void saveSchedule() {
    hideError();
    showProgress();
    /*List<List<SubjectBO?>> subjects =  scheduleType.toScheduleTypeInt() == 0 ? morning5Rows.value + afternoon5Rows.value : combineMatrix();
    List<List<SubjectBO?>> tSubject = _transpose(subjects);
    List<List<List<SubjectBO?>>> eSubject = _encapsulate(tSubject);
    var schedule = ScheduleBO(eSubject, scheduleType.toScheduleTypeInt(), fileType, targetDegree!.name!, targetDegree!.year!,0);
*/
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
    /*
    List<List<SubjectModel?>> subjects =  scheduleType == 0 ? morning5Rows.value + afternoon5Rows.value : combineMatrix();
    List<List<SubjectModel?>> tSubject = _transpose(subjects);
    List<List<List<SubjectModel?>>> eSubject = _encapsulate(tSubject);
    var schedule = ScheduleModel(id: null,subjects: eSubject, scheduleType: scheduleType, fileType: fileType, degree: targetDegree!.name!, year: targetDegree!.year!);
    */
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
    if (await canLaunchUrl(Uri.parse("file://$path"))) {
      await launchUrl(Uri.parse("file://$path"));
    } else {
      showErrorMessage('canNotOpenDocument'.tr);
      showError();
    }
    _fileDownloaded.value = false;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  List<List<SubjectBO?>> _transpose(List<List<SubjectBO?>> colsInRows) {
    int nRows = colsInRows.length;
    if (colsInRows.isEmpty) return colsInRows;

    int nCols = colsInRows[0].length;
    if (nCols == 0) throw StateError('Degenerate matrix');

    // Init the transpose to make sure the size is right
    List<List<SubjectBO?>> rowsInCols = List.filled(nCols, []);
    for (int col = 0; col < nCols; col++) {
      rowsInCols[col] = List.filled(nRows, null);
    }

    // Transpose
    for (int row = 0; row < nRows; row++) {
      for (int col = 0; col < nCols; col++) {
        rowsInCols[col][row] = colsInRows[row][col];
      }
    }
    return rowsInCols;
  }

  List<List<List<SubjectBO?>>> _encapsulate(List<List<SubjectBO?>> matrix) {
    var result = matrix.map((items) => items.map((item) => [item]).toList()).toList();
    return result;
  }

}
