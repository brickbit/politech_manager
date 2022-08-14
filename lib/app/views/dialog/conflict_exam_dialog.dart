
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/model/exam_bo.dart';

void conflictExamDialog(List<ExamBO> exams, BuildContext context, void Function(ExamBO) conflictType) {
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
            itemCount: exams.length,
            itemBuilder: (BuildContext context, int index) {
              String subjectName = exams[index].acronym;
              return ListTile(
                title: Text(subjectName),
                onTap: () {
                  conflictType(exams[index]);
                  Navigator.pop(context, 'OK');
                },
              );
            }
        ),
      ),
    ),
  );
}