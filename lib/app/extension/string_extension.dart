
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
}

extension StringTurn on String {
  String getTurn() {
    if (this == 'morning'.tr) {
      return 'MORNING';
    } else {
      return 'AFTERNOON';
    }
  }
}