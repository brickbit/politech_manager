
import 'package:politech_manager/domain/model/subject_bo.dart';

class PairSubjectStateBO {
  SubjectBO? subject;
  SubjectState state;

  PairSubjectStateBO(this.subject, this.state );
}

enum SubjectState { free, departmentCollision, classroomCollision }