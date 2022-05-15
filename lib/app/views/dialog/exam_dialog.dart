import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/extension/string_extension.dart';
import 'package:politech_manager/domain/model/exam_bo.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/model/subject_bo.dart';
import '../custom/material_dropdown.dart';
import '../custom/material_dropdown_subject.dart';

void examDialog(BuildContext context, ExamBO? exam, List<SubjectBO> subjects,
    bool mobile, void Function(ExamBO) manageExam) {
  final _acronymController = TextEditingController(text: exam?.acronym ?? '');
  var _semester = (exam?.semester ?? 1).toString().obs;
  var id = exam?.id;
  var _subjectItems = subjects;
  var _subject = (exam?.subject ?? _subjectItems[0]).obs;
  var _turn = (exam?.turn.toTurn() ?? 'morning'.tr).obs;
  var _call = (exam?.call.toCall() ?? 'january'.tr).obs;

  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('createExam'.tr),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SizedBox(
            height: mobile ? 200 : 360,
            width: 280,
            child: ListView(
              children: [
                TextField(
                  controller: _acronymController,
                  decoration: InputDecoration(
                    labelText: 'acronym'.tr,
                  ),
                ),
                const SizedBox(height: 24),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('semester'.tr),
                  materialDropdown(
                      _semester, ['1', '2', '3', '4', '5', '6', '7', '8']),
                ]),
                const SizedBox(height: 24),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('subject'.tr),
                  materialDropdownSubject(_subject, _subjectItems),
                ]),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('call'.tr),
                    materialDropdown(
                        _call, ['january'.tr, 'may'.tr, 'june'.tr]),
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('turn'.tr),
                    materialDropdown(_turn, ['morning'.tr, 'afternoon'.tr]),
                  ],
                ),
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
            var exam = ExamBO(
                _subject.value,
                _acronymController.text,
                int.parse(_semester.value),
                '',
                _call.value.getCall(),
                _turn.value.getTurn(),
                id ?? uuid.v4().hashCode);
            manageExam(exam);
            Navigator.pop(context, 'OK');
          },
          child: Text('ok'.tr),
        ),
      ],
    ),
  );
}
