import '../../../domain/model/classroom_bo.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

Widget materialDropdownClassroom(
    Rx<ClassroomBO> selected, List<ClassroomBO> items) {
  return Obx(
    () => DropdownButton<String>(
      value: selected.value.name,
      style: const TextStyle(color: Colors.green, fontSize: 16.0),
      underline: Container(
        height: 2,
        color: Colors.green,
      ),
      isExpanded: true,
      items: items.map((ClassroomBO value) {
        return DropdownMenuItem<String>(
          value: value.name,
          child: Text(value.name),
        );
      }).toList(),
      onChanged: (String? updatedValue) {
        var result =
            items.firstWhere((element) => element.acronym == updatedValue!);
        selected.value = result;
      },
    ),
  );
}
