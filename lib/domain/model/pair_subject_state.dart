
import 'package:politech_manager/domain/model/subject_bo.dart';
/*
class PairSubjectStateBO {
  SubjectBO? subject;
  SubjectState state;

  PairSubjectStateBO(this.subject, this.state );

  void updateState(SubjectState newState) {
    state = newState;
  }
}
*/
enum SubjectState { free, departmentCollision, classroomCollision }
