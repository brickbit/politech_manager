
import 'package:politech_manager/domain/model/subject_bo.dart';

class ExamBO {
  final SubjectBO subject;
  final String acronym;
  final int semester;
  final String date;
  final String call;
  final String turn;
  final int id;

  ExamBO(this.subject, this.acronym, this.semester, this.date,
      this.call, this.turn, this.id);
}
