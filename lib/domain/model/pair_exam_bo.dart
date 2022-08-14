import 'package:politech_manager/domain/model/exam_state_bo.dart';

class PairExamBO {
  final ExamStateBO? first;
  final ExamStateBO? last;

  PairExamBO(this.first, this.last);
}