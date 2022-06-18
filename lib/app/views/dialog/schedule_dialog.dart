import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/model/schedule_filter.dart';
import 'package:politech_manager/domain/model/subject_bo.dart';
import '../../../domain/model/degree_bo.dart';
import '../custom/material_dropdown.dart';
import '../custom/material_dropdown_degree.dart';

void scheduleDialog(String title, BuildContext context, List<DegreeBO> degrees, List<SubjectBO> subjects,
    void Function(ScheduleFilter) filteredSubjects) {
  var semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  var semester = '1'.obs;
  var degreeItems = degrees;
  var degree = degreeItems[0].obs;
  var fileTypes = ['subject'.tr, 'department'.tr, 'classroom'.tr];
  var fileType = 'subject'.tr.obs;
  var scheduleTypes = ['oneSubjectPerHour'.tr, 'severalSubjectsPerHour'.tr];
  var scheduleType = 'oneSubjectPerHour'.tr.obs;

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
                materialDropdownDegree(degree, degreeItems),
              ]),
              const SizedBox(height: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('semester'.tr),
                materialDropdown(
                    semester, semesters),
              ]),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('scheduleType'.tr),
                  materialDropdown(scheduleType, scheduleTypes),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('fileType'.tr),
                  materialDropdown(fileType, fileTypes),
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
            final subjectsFiltered = subjects.where((element) => element.semester == int.parse(semester.value) && element.degree.id == degree.value.id).toList();
            Navigator.pop(context, 'OK');
            filteredSubjects(ScheduleFilter(subjectsFiltered,int.parse(semester.value), scheduleType.value, fileType.value, degree.value.name, degree.value.year));
          },
          child: Text('ok'.tr),
        ),
      ],
    ),
  );
}
