import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/domain/model/department_bo.dart';
import 'package:uuid/uuid.dart';

void departmentDialog(String title, BuildContext context, DepartmentBO? department, void Function(DepartmentBO) manageDepartment) {
  final _nameController = TextEditingController(text: department?.name ?? '');
  final _acronymController = TextEditingController(text: department?.acronym ?? '');
  var id = department?.id;

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
              const SizedBox(height: 16),
              TextField(
                controller: _acronymController,
                decoration: InputDecoration(
                  labelText: 'acronym'.tr,
                ),
              ),
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
            var department = DepartmentBO(_nameController.text, _acronymController.text, id ?? uuid.v4().hashCode);
            manageDepartment(department);
            Navigator.pop(context, 'OK');
          },
          child: Text('ok'.tr),
        ),
      ],
    ),
  );
}
