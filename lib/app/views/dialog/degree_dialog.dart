import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/domain/model/degree_bo.dart';
import 'package:uuid/uuid.dart';
import '../custom/material_dropdown.dart';

void degreeDialog(String title, BuildContext context, DegreeBO? degree,
    void Function(DegreeBO) manageDegree) {
  final _nameController = TextEditingController(text: degree?.name ?? '');
  final _yearController = TextEditingController(text: degree?.year ?? '');
  var id = degree?.id;
  var _numSemesters = (degree?.numSemesters.toString() ?? '8').obs;

  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
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
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'year'.tr,
                ),
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('semesters'.tr),
                  materialDropdown(_numSemesters, ['4', '8']),
                ],
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
            var newDegree = DegreeBO(
                _nameController.text,
                int.parse(_numSemesters.value),
                _yearController.text,
                id ?? uuid.v4().hashCode);
            manageDegree(newDegree);
            Navigator.pop(context, 'OK');
          },
          child: Text('ok'.tr),
        ),
      ],
    ),
  );
}
