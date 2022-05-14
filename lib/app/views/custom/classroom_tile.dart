import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:politech_manager/data/mapper/data_mapper.dart';
import '../../../domain/model/classroom_bo.dart';

Widget classroomTile(bool mobile, List<ClassroomBO> classrooms, int index) {
  return Container(
    constraints: mobile
        ? const BoxConstraints(maxWidth: 250)
        : const BoxConstraints(maxWidth: 650),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${classrooms[index].name} - ${classrooms[index].acronym}',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 4,
        ),
        Text(
          'classroomPavilion'.trParams({
            'pavilion': classrooms[index].pavilion.toUpperCase().toDropdownItem()
          }),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    ),
  );
}
