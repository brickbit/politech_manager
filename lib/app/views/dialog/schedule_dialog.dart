import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/model/schedule_filter.dart';
import 'package:politech_manager/domain/model/subject_bo.dart';
import '../../../domain/model/degree_bo.dart';
import '../custom/material_dropdown.dart';
import '../custom/material_dropdown_degree.dart';

void scheduleDialog(String title, BuildContext context, List<DegreeBO> degrees, List<SubjectBO> subjects,
    void Function(ScheduleFilter) filteredSubjects) {
  var _semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  var _semester = '1'.obs;
  var _degreeItems = degrees;
  var _degree = _degreeItems[0].obs;
  var _scheduleTypes = ['oneSubjectPerHour'.tr, 'severalSubjectsPerHour'.tr];
  var _scheduleType = 'oneSubjectPerHour'.tr.obs;

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
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('degree'.tr),
                materialDropdownDegree(_degree, _degreeItems),
              ]),
              const SizedBox(height: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('semester'.tr),
                materialDropdown(
                    _semester, _semesters),
              ]),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('scheduleType'.tr),
                  materialDropdown(_scheduleType, _scheduleTypes),
                ],
              ),
              const SizedBox(height: 24),

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
            final subjectsFiltered = subjects.where((element) => element.semester == int.parse(_semester.value) && element.degree.id == _degree.value.id).toList();
            Navigator.pop(context, 'OK');
            filteredSubjects(ScheduleFilter(subjectsFiltered,int.parse(_semester.value), _scheduleType.value));
          },
          child: Text('ok'.tr),
        ),
      ],
    ),
  );
}
