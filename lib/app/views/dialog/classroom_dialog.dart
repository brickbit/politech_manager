import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/data/mapper/data_mapper.dart';
import 'package:politech_manager/domain/model/classroom_bo.dart';
import 'package:uuid/uuid.dart';
import '../custom/material_dropdown.dart';

void classroomDialog(BuildContext context, ClassroomBO? classroom, void Function(ClassroomBO) manageClassroom) {
  final _nameController = TextEditingController(text: classroom?.name ?? '');
  final _acronymController = TextEditingController(text: classroom?.acronym ?? '');
  var id = classroom?.id;
  String? classroomName = classroom?.pavilion.toDropdownItem();
  var _pavilion = (classroomName ?? 'telecommunication'.tr).obs;

  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('createClassroom'.tr),
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
                controller: _acronymController,
                decoration: InputDecoration(
                  labelText: 'acronym'.tr,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                  height: 50,
                  width: Size.infinite.width,
                  child: materialDropdown(_pavilion, [
                    'telecommunication'.tr,
                    'computing'.tr,
                    'architecture'.tr,
                    'civil_work'.tr,
                    'central'.tr
                  ])),
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
            var classroom = ClassroomBO(_nameController.text, _pavilion.value,
                _acronymController.text, id ?? uuid.v4().hashCode);
            manageClassroom(classroom);
            Navigator.pop(context, 'OK');
          },
          child: Text('ok'.tr),
        ),
      ],
    ),
  );
}
