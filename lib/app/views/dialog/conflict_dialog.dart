
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/domain/model/subject_bo.dart';

void conflictDialog(List<SubjectBO> subjects, BuildContext context, void Function(SubjectBO) conflictType) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('showConflicts'.tr),
      content: SizedBox(
        height: 240,
        width: 200,
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            itemCount: subjects.length,
            itemBuilder: (BuildContext context, int index) {
              String subjectName = "${subjects[index].laboratory ? "Lab. " : ""}${subjects[index].seminary ? "Sem. ": ""}${subjects[index].name}";
              return ListTile(
                title: Text(subjectName),
                onTap: () {
                  conflictType(subjects[index]);
                  Navigator.pop(context, 'OK');
                },
              );
            }
        ),
    ),
  ),
  );
}