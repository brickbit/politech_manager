import 'package:politech_manager/domain/model/department_bo.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../domain/model/teacher_bo.dart';

Widget materialDropdownTeacher(
    Rx<TeacherBO> selected, List<TeacherBO> items) {
  return Obx(
        () => DropdownButton<String>(
      value: selected.value.name,
      style: const TextStyle(color: Colors.green, fontSize: 16.0),
      underline: Container(
        height: 2,
        color: Colors.green,
      ),
      isExpanded: true,
      items: items.map((TeacherBO value) {
        return DropdownMenuItem<String>(
          value: value.name,
          child: Text(value.name),
        );
      }).toList(),
      onChanged: (String? updatedValue) {
        var result =
        items.firstWhere((element) => element.name == updatedValue!);
        selected.value = result;
      },
    ),
  );
}