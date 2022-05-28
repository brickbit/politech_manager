
import 'package:get/get.dart';

extension StringCall on String {
  String getCall() {
    if (this == 'january'.tr) {
      return 'JANUARY';
    } else if (this == 'may'.tr) {
      return 'MAY';
    } else if (this == 'june'.tr) {
      return 'JUNE';
    } else {
      return 'JANUARY';
    }
  }

  String toCall() {
    if (this == 'JANUARY') {
      return 'january'.tr;
    } else if (this == 'MAY') {
      return 'may'.tr;
    } else if (this == 'JUNE') {
      return 'june'.tr;
    } else {
      return 'january'.tr;
    }
  }
}

extension StringTurn on String {
  String getTurn() {
    if (this == 'morning'.tr) {
      return 'MORNING';
    } else {
      return 'AFTERNOON';
    }
  }

  String toTurn() {
    if (this == 'MORNING') {
      return 'morning'.tr;
    } else {
      return 'afternoon'.tr;
    }
  }
}

extension StringScheduleType on String {
  int toScheduleTypeInt() {
    if (this == 'oneSubjectPerHour'.tr) {
      return 0;
    } else {
      return 1;
    }
  }
}

extension StringDateTime on String {
  bool previousThan(String endDate) {
    final endDateArray = endDate.split("-");
    final startDateArray = split("-");

    final start = DateTime(int.parse(startDateArray[0]), int.parse(startDateArray[1]), int.parse(startDateArray[2]));
    final end = DateTime(int.parse(endDateArray[0]), int.parse(endDateArray[1]), int.parse(endDateArray[2]));

    return end.difference(start).inDays > 0;
  }
}

extension StrindDateMapper on DateTime {
  String getString() {
    return toString().split(" ")[0];
  }
}
