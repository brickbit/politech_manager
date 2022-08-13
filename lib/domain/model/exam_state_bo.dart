
import 'package:politech_manager/domain/model/exam_state.dart';
import 'package:politech_manager/domain/model/pair_exam_bo.dart';

class ExamStateBO {
  PairExamBO? exam;
  ExamState state;

  ExamStateBO(this.exam, this.state );
}