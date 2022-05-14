import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:politech_manager/app/extension/string_extension.dart';
import 'package:politech_manager/domain/model/exam_bo.dart';
import '../../../domain/model/department_bo.dart';

Widget examTile(bool mobile, List<ExamBO> exams, int index) {
  return Container(
    constraints: mobile ? const BoxConstraints(maxWidth: 240) : const BoxConstraints(maxWidth: 650),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(exams[index].subject.name,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('acronym'.tr),
            Text(
              exams[index].acronym,
            ),
            const SizedBox(
              width: 16,
            ),
            Text('turn'.tr),
            Text(exams[index].turn.toTurn()),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('semester'.tr),
            Text(exams[index].semester.toString()),
            const SizedBox(
              width: 16,
            ),
            Text('call'.tr),
            Text(exams[index].call.toCall()),
          ],
        ),
      ],
    ),
  );
}