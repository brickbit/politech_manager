import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:politech_manager/domain/model/exam_bo.dart';
import '../../../domain/model/department_bo.dart';

Widget examTile(bool mobile, List<ExamBO> exams, int index) {
  return Container(
    constraints: mobile ? const BoxConstraints(maxWidth: 220) : const BoxConstraints(maxWidth: 650),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(exams[index].subject.name,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 4,
        ),
        Text(
          exams[index].acronym,
        ),
      ],
    ),
  );
}