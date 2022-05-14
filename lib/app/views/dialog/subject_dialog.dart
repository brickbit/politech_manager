import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/extension/color_extension.dart';
import 'package:politech_manager/domain/model/degree_bo.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/model/classroom_bo.dart';
import '../../../domain/model/department_bo.dart';
import '../../../domain/model/subject_bo.dart';
import '../custom/material_dropdown.dart';
import '../custom/material_dropdown_classroom.dart';
import '../custom/material_dropdown_color.dart';
import '../custom/material_dropdown_degree.dart';
import '../custom/material_dropdown_department.dart';

void subjectDialog(
    BuildContext context,
    SubjectBO? subject,
    List<ClassroomBO> classrooms,
    List<DepartmentBO> departments,
    List<DegreeBO> degrees,
    bool mobile,
    void Function(SubjectBO) manageSubject) {
  final _nameController = TextEditingController(text: subject?.name ?? '');
  final _acronymController = TextEditingController(text: subject?.acronym ?? '');
  final _groupController = TextEditingController(text: subject?.classGroup ?? '');
  var _isSeminary = (subject?.seminary ?? false).obs;
  var _isLaboratory = (subject?.laboratory ?? false).obs;
  var _isEnglish = (subject?.english ?? false).obs;
  var _time = (subject?.time.toString() ?? '60').obs;
  var _semester = (subject?.semester ?? 1).toString().obs;
  var id = subject?.id;

  var _classroomItems = classrooms;
  var _classroom = _classroomItems[0].obs;
  var _departmentItems = departments;
  var _department = _departmentItems[0].obs;
  var _degreeItems = degrees;
  var _degree = _degreeItems[0].obs;
  var _colorItems = ['blue'.tr, 'red'.tr, 'yellow'.tr, 'orange'.tr, 'green'.tr];
  var _color = _colorItems[subject?.color ?? 0].obs;

  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('createSubject'.tr),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SizedBox(
            height: mobile ? 300 : 560,
            width: 280,
            child: ListView(
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
                TextField(
                  controller: _groupController,
                  decoration: InputDecoration(
                    labelText: 'group'.tr,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('seminary'.tr),
                    Obx(
                      () => Switch(
                        value: _isSeminary.value,
                        activeColor: Colors.amber,
                        onChanged: (value) => _isSeminary.value = value,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('laboratory'.tr),
                    Obx(
                      () => Switch(
                        value: _isLaboratory.value,
                        activeColor: Colors.amber,
                        onChanged: (value) => _isLaboratory.value = value,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('English'),
                    Obx(
                      () => Switch(
                        value: _isEnglish.value,
                        activeColor: Colors.amber,
                        onChanged: (value) => _isEnglish.value = value,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('time'.tr),
                    materialDropdown(_time, [
                      '60',
                      '90',
                      '120',
                      '150',
                      '180',
                      '210',
                      '240',
                      '270',
                      '300'
                    ]),
                  ],
                ),
                const SizedBox(height: 24),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('semester'.tr),
                  materialDropdown(
                      _semester, ['1', '2', '3', '4', '5', '6', '7', '8']),
                ]),
                const SizedBox(height: 24),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('classroom'.tr),
                  materialDropdownClassroom(_classroom, _classroomItems),
                ]),
                const SizedBox(height: 24),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('department'.tr),
                  materialDropdownDepartment(_department, _departmentItems),
                ]),
                const SizedBox(height: 24),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('degree'.tr),
                  materialDropdownDegree(_degree, _degreeItems),
                ]),
                const SizedBox(height: 24),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('color'.tr),
                  materialDropdownColor(_color, _colorItems),
                ]),
              ],
            ),
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
            var subject = SubjectBO(
                _nameController.text,
                _acronymController.text,
                _groupController.text,
                _isSeminary.value,
                _isLaboratory.value,
                _isEnglish.value,
                int.parse(_time.value),
                int.parse(_semester.value),
                "",
                "",
                "",
                _classroom.value,
                _department.value,
                _degree.value,
                _color.value.getColorNumber(),
                id ?? uuid.v4().hashCode);
            manageSubject(subject);
            Navigator.pop(context, 'OK');
          },
          child: Text('ok'.tr),
        ),
      ],
    ),
  );
}
