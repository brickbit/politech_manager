

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/model/department_bo.dart';
import '../../../domain/model/teacher_bo.dart';
import '../custom/material_dropdown_department.dart';

void teacherDialog(String title, BuildContext context, List<DepartmentBO> departments, TeacherBO? teacher, void Function(TeacherBO) manageTeacher) {
  final _nameController = TextEditingController(text: teacher?.name ?? '');
  var _departmentItems = departments;
  var _department = _departmentItems[0].obs;
  var id = teacher?.id;

  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'name'.tr,
                ),
              ),
              const SizedBox(height: 24),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('department'.tr),
                materialDropdownDepartment(_department, _departmentItems),
              ]),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text('cancel'.tr),
        ),
        TextButton(
          onPressed: () {
            var uuid = const Uuid();
            var teacher = TeacherBO(_nameController.text, _department.value, id ?? uuid.v4().hashCode);
            manageTeacher(teacher);
            Navigator.pop(context, 'OK');
          },
          child: Text('ok'.tr),
        ),
      ],
    ),
  );
}
