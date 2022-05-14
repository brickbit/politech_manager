
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/model/degree_bo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget degreeTile(bool mobile, List<DegreeBO> degrees, int index) {
  return Container(
    constraints: mobile
        ? const BoxConstraints(maxWidth: 220)
        : const BoxConstraints(maxWidth: 650),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          degrees[index].name,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          'degreeSemesters'
              .trParams({'semester': degrees[index].numSemesters.toString()}),
        ),
        const SizedBox(
          height: 8,
        ),
        Text('degreeYear'.trParams({'year': degrees[index].year.toString()}),
            style: const TextStyle(fontSize: 12)),
      ],
    ),
  );
}