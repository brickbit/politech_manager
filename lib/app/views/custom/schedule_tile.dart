
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/model/degree_bo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/model/schedule_bo.dart';

Widget scheduleTile(bool mobile, List<ScheduleBO> schedules, int index) {
  return Container(
    constraints: mobile
        ? const BoxConstraints(maxWidth: 220)
        : const BoxConstraints(maxWidth: 650),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          schedules[index].degree,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 8,
        ),
        Text('scheduleYear'.trParams({'year': schedules[index].year.toString()}),
            style: const TextStyle(fontSize: 12)),
      ],
    ),
  );
}