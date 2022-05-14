import 'package:get/get.dart';
import 'package:politech_manager/data/model/classroom_dto.dart';
import 'package:politech_manager/data/model/degree_dto.dart';
import 'package:politech_manager/data/model/department_dto.dart';
import 'package:politech_manager/data/model/exam_dto.dart';
import 'package:politech_manager/domain/model/classroom_bo.dart';
import 'package:politech_manager/domain/model/degree_bo.dart';
import 'package:politech_manager/domain/model/department_bo.dart';
import 'package:politech_manager/domain/model/exam_bo.dart';
import '../../domain/model/pavilion.dart';
import '../../domain/model/subject_bo.dart';
import '../model/subject_dto.dart';

extension ClassroomBOMapper on ClassroomDto {
  ClassroomBO toBO() {
    return ClassroomBO(name, pavilion, acronym, id);
  }
}

extension DegreeBOMapper on DegreeDto {
  DegreeBO toBO() {
    return DegreeBO(name, numSemesters, year, id);
  }
}

extension DepartmentBOMapper on DepartmentDto {
  DepartmentBO toBO() {
    return DepartmentBO(name, acronym, id);
  }
}

extension ExamBOMapper on ExamDto {
  ExamBO toBO() {
    return ExamBO(subject.toBO(), acronym, semester, date, call, turn, id);
  }
}

extension SubjectBOMapper on SubjectDto {
  SubjectBO toBO() {
    return SubjectBO(
        name,
        acronym,
        classGroup,
        seminary,
        laboratory,
        english,
        time,
        semester,
        days,
        hours,
        turns,
        classroom.toBO(),
        department.toBO(),
        degree.toBO(),
        color,
        id);
  }
}

extension ClassroomDtoMapper on ClassroomBO {
  ClassroomDto toDto() {
    return ClassroomDto(name: name, pavilion: pavilion.toPavilion().toDto(), acronym: acronym, id: id);
  }
}

extension PavilionMapper on String {
  Pavilion toPavilion() {
    switch (this) {
      case 'Central': return Pavilion.central;
      case 'Telecommunication': return Pavilion.telecommunication;
      case 'Telecomunicaciones': return Pavilion.telecommunication;
      case 'Computing': return Pavilion.computing;
      case 'Informática': return Pavilion.computing;
      case 'Architecture': return Pavilion.architecture;
      case 'Arquitectura': return Pavilion.architecture;
      case 'civil_work': return Pavilion.civilWork;
      case 'Obras públicas': return Pavilion.civilWork;
      default: return Pavilion.central;
    }
  }

  String toDropdownItem() {
    switch (this) {
      case 'CENTRAL': return 'central'.tr;
      case 'TELECOMMUNICATION': return 'telecommunication'.tr;
      case 'COMPUTING': return 'computing'.tr;
      case 'ARCHITECTURE': return 'architecture'.tr;
      case 'CIVIL_WORK': return 'civil_work'.tr;
      default: return 'central'.tr;
    }
  }
}

extension StringPavilionMapper on Pavilion {
  String toDto() {
    switch (this) {
      case Pavilion.central: return "CENTRAL";
      case Pavilion.telecommunication: return "TELECOMMUNICATION";
      case Pavilion.computing: return "COMPUTING";
      case Pavilion.architecture: return "ARCHITECTURE";
      case Pavilion.civilWork: return "CIVIL_WORK";
      default: return "CENTRAL";
    }
  }
}

extension DegreeDtoMapper on DegreeBO {
  DegreeDto toDto() {
    return DegreeDto(name: name, numSemesters: numSemesters, year: year, id: id);
  }
}

extension DepartmentDtoMapper on DepartmentBO {
  DepartmentDto toDto() {
    return DepartmentDto(name: name, acronym: acronym, id: id);
  }
}

extension ExamDtoMapper on ExamBO {
  ExamDto toDto() {
    return ExamDto(subject: subject.toDto(), acronym: acronym, semester: semester, date: date, call: call, turn: turn, id: id);
  }
}

extension SubjectDtoMapper on SubjectBO {
  SubjectDto toDto() {
    return SubjectDto(
        name: name,
        acronym: acronym,
        classGroup: classGroup,
        seminary: seminary,
        laboratory: laboratory,
        english: english,
        time: time,
        semester: semester,
        days: days,
        hours: hours,
        turns: turns,
        classroom: classroom.toDto(),
        department: department.toDto(),
        degree: degree.toDto(),
        color: color,
        id: id);
  }
}