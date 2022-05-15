import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/model/subject_bo.dart';
import '../custom/material_dropdown.dart';
import '../custom/material_dropdown_subject.dart';

void filterExamDialog(BuildContext context, List<SubjectBO> subjects,
    void Function(Map<String, dynamic>) filterExam) {
  var _turn = ('morning'.tr).obs;
  var _call = ('january'.tr).obs;
  var _semester = 1.toString().obs;
  var _subjectItems = subjects;
  var _subject = (_subjectItems[0]).obs;

  var _filterTurn = false.obs;
  var _filterCall = false.obs;
  var _filterSemester = false.obs;
  var _filterSubject = false.obs;

  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('filterExam'.tr),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Obx(
                  () => Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.green,
                          value: _filterCall.value,
                          onChanged: (bool? value) {
                            _filterCall.value = value!;
                          }),
                      Text('call'.tr),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: materialDropdown(
                    _call,
                    ['january'.tr, 'may'.tr, 'june'.tr],
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Obx(
                  () => Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.green,
                          value: _filterTurn.value,
                          onChanged: (bool? value) {
                            _filterTurn.value = value!;
                          }),
                      Text('turn'.tr),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: materialDropdown(
                    _turn,
                    ['morning'.tr, 'afternoon'.tr],
                  ),
                ),
              ]),
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
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: materialDropdown(
                      _semester, ['1', '2', '3', '4', '5', '6', '7', '8']),
                ),
              ]),
              const SizedBox(height: 24),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Obx(
                  () => Row(
                    children: [
                      Checkbox(
                          activeColor: Colors.green,
                          value: _filterSubject.value,
                          onChanged: (bool? value) {
                            _filterSubject.value = value!;
                          }),
                      Text('subject'.tr),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: materialDropdownSubject(_subject, _subjectItems),
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
            if (_filterSemester.value) {
              filter['semester'] = int.parse(_semester.value);
            }
            if (_filterCall.value) filter['call'] = _call.value;
            if (_filterTurn.value) filter['turn'] = _turn.value;
            if (_filterSubject.value) filter['subject'] = _subject.value;
            filterExam(filter);
            Navigator.pop(context, 'OK');
          },
          child: Text('filter'.tr),
        ),
      ],
    ),
  );
}
