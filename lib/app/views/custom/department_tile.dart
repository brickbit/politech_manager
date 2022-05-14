import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/model/department_bo.dart';

Widget departmentTile(bool mobile, List<DepartmentBO> departments, int index) {
  return Container(
    constraints: mobile ? const BoxConstraints(maxWidth: 220) : const BoxConstraints(maxWidth: 650),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(departments[index].name,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 4,
        ),
        Text(
          departments[index].acronym,
        ),
      ],
    ),
  );
}