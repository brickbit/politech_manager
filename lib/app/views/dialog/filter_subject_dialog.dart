import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/model/classroom_bo.dart';
import '../../../domain/model/degree_bo.dart';
import '../../../domain/model/department_bo.dart';
import '../custom/material_dropdown.dart';
import '../custom/material_dropdown_classroom.dart';
import '../custom/material_dropdown_degree.dart';
import '../custom/material_dropdown_department.dart';

void filterSubjectDialog(
    BuildContext context,
    List<ClassroomBO> classrooms,
    List<DepartmentBO> departments,
    List<DegreeBO> degrees,
    void Function(Map<String, dynamic>) filterSubject) {
  var _isLaboratory = false.obs;
  var _isSeminary = false.obs;
  var _isEnglish = false.obs;
  var _semester = 1.toString().obs;
  var _classroomItems = classrooms;
  var _classroom = _classroomItems[0].obs;
  var _departmentItems = departments;
  var _department = _departmentItems[0].obs;
  var _degreeItems = degrees;
  var _degree = _degreeItems[0].obs;

  var _filterSeminary = false.obs;
  var _filterLaboratory = false.obs;
  var _filterEnglish = false.obs;
  var _filterSemester = false.obs;
  var _filterClassroom = false.obs;
  var _filterDepartment = false.obs;
  var _filterDegree = false.obs;

  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('filterSubject'.tr),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              _seminaryBlock(_isSeminary, _filterSeminary),
              const SizedBox(height: 16),
              _laboratoryBlock(_isLaboratory, _filterLaboratory),
              const SizedBox(height: 16),
              _englishBlock(_isEnglish, _filterEnglish),
              const SizedBox(height: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Obx(
                      () => Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.green,
                          value: _filterSemester.value,
                          onChanged: (bool? value) {
                            _filterSemester.value = value!;
                          }),
                      Text('semester'.tr),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                  child: materialDropdown(
                      _semester, ['1', '2', '3', '4', '5', '6', '7', '8']),
                ),
              ]),
              const SizedBox(height: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Obx(
                      () => Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.green,
                          value: _filterClassroom.value,
                          onChanged: (bool? value) {
                            _filterClassroom.value = value!;
                          }),
                      Text('classroom'.tr),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                child: materialDropdownClassroom(_classroom, _classroomItems),
                ),
              ]),
              const SizedBox(height: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Obx(
                      () => Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.green,
                          value: _filterDepartment.value,
                          onChanged: (bool? value) {
                            _filterDepartment.value = value!;
                          }),
                      Text('department'.tr),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                    child: materialDropdownDepartment(_department, _departmentItems),
                ),
              ]),
              const SizedBox(height: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Obx(
                      () => Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.green,
                          value: _filterDegree.value,
                          onChanged: (bool? value) {
                            _filterDegree.value = value!;
                          }),
                      Text('degree'.tr),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                    child: materialDropdownDegree(_degree, _degreeItems),
                ),
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
            final Map<String, dynamic> filter = <String, dynamic>{};
            if(_filterSeminary.value) filter['seminary'] = _isSeminary.value;
            if(_filterLaboratory.value) filter['laboratory'] = _isLaboratory.value;
            if(_filterEnglish.value) filter['english'] = _isEnglish.value;
            if(_filterSemester.value)  filter['semester'] = int.parse(_semester.value);
            if(_filterClassroom.value) filter['classroom'] = _classroom.value;
            if(_filterDepartment.value) filter['department'] = _department.value;
            if(_filterDegree.value)  filter['degree'] = _degree.value;
            filterSubject(filter);
            Navigator.pop(context, 'OK');
          },
          child: Text('filter'.tr),
        ),
      ],
    ),
  );
}

Widget _seminaryBlock(Rx<bool> isSeminary, Rx<bool> filterSeminary) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Obx(
        () => Row(
          children: [
            Checkbox(
              activeColor: Colors.green,
                value: filterSeminary.value,
                onChanged: (bool? value) {
                  filterSeminary.value = value!;
                }),
            Text('seminary'.tr),
          ],
        ),
      ),
      Obx(
        () => Switch(
          value: isSeminary.value,
          activeColor: Colors.amber,
          onChanged: (value) => isSeminary.value = value,
        ),
      ),
    ],
  );
}

Widget _laboratoryBlock(Rx<bool> isLaboratory, Rx<bool> filterLaboratory) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Obx(
            () => Row(
          children: [
            Checkbox(
                activeColor: Colors.green,
                value: filterLaboratory.value,
                onChanged: (bool? value) {
                  filterLaboratory.value = value!;
                }),
            Text('laboratory'.tr),
          ],
        ),
      ),
      Obx(
        () => Switch(
          value: isLaboratory.value,
          activeColor: Colors.amber,
          onChanged: (value) => isLaboratory.value = value,
        ),
      ),
    ],
  );
}

Widget _englishBlock(Rx<bool> isEnglish, Rx<bool> filterEnglish) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Obx(
            () => Row(
          children: [
            Checkbox(
                activeColor: Colors.green,
                value: filterEnglish.value,
                onChanged: (bool? value) {
                  filterEnglish.value = value!;
                }),
            Text('english'.tr),
          ],
        ),
      ),
      Obx(
        () => Switch(
          value: isEnglish.value,
          activeColor: Colors.amber,
          onChanged: (value) => isEnglish.value = value,
        ),
      ),
    ],
  );
}

