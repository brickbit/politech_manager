
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/model/calendar_bo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget calendarTile(bool mobile, List<CalendarBO> calendars, int index) {
  return Container(
    constraints: mobile
        ? const BoxConstraints(maxWidth: 220)
        : const BoxConstraints(maxWidth: 650),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          calendars[index].degree,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 8,
        ),
        Text('scheduleYear'.trParams({'year': calendars[index].year.toString()}),
            style: const TextStyle(fontSize: 12)),
      ],
    ),
  );
}