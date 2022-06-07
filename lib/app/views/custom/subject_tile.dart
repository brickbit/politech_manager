import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/extension/color_extension.dart';

import '../../../domain/model/subject_bo.dart';

Widget subjectTile(bool mobile, List<SubjectBO> subjects, int index) {
  return Container(
    constraints: mobile
        ? const BoxConstraints(maxWidth: 245)
        : const BoxConstraints(maxWidth: 400),
    child: Row(
      children: [
        SizedBox(
          width: 6,
          height: 140,
          child: Container(
            color: subjects[index].color.parseColor(),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 230, child:Text(subjects[index].name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold)),),
            const SizedBox(
              height: 4,
            ),
            Text(subjects[index].acronym,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 4,
            ),
            const SizedBox(
              height: 4,
            ),
            SizedBox(
                width: 230,
                child: Text(subjects[index].degree.name.toString(), overflow: TextOverflow.ellipsis,)),
            const SizedBox(
              height: 4,
            ),
            Text(
              'departmentAcronym'.trParams({
                'acronym':
                subjects[index].department.acronym.toString()
              }),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'classroomAcronym'.trParams(
                      {'acronym': subjects[index].classroom.name.toString()}),
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  'groupAcronym'.trParams(
                      {'acronym': subjects[index].classGroup.toString()}),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('subjectSemester'.trParams(
                    {'semester': (subjects[index].semester).toString()})),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  'subjectLanguage'.trParams({
                    'language':
                    subjects[index].english == false ? 'Español' : 'English'
                  }),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'subjectLaboratory'.trParams({
                    'laboratory':
                    subjects[index].laboratory == false ? 'no'.tr : 'yes'.tr
                  }),
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  'subjectSeminar'.trParams({
                    'seminary':
                    subjects[index].seminary == false ? 'no'.tr : 'yes'.tr
                  }),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
