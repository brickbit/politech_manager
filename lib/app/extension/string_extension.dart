
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