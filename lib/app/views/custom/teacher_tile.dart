
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/model/teacher_bo.dart';

Widget teacherTile(bool mobile, List<TeacherBO> teachers, int index) {
  return Container(
    constraints: mobile ? const BoxConstraints(maxWidth: 220) : const BoxConstraints(maxWidth: 650),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(teachers[index].name,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 4,
        ),
        Text(
          teachers[index].department.name,
        ),
      ],
    ),
  );
}