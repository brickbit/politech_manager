import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/extension/datetime_extension.dart';
import '../../../domain/model/degree_bo.dart';
import '../../../domain/model/exam_bo.dart';
import '../../model/calendar_filter.dart';
import '../custom/material_dropdown.dart';
import '../custom/material_dropdown_degree.dart';

void calendarDialog(String title, BuildContext context, List<DegreeBO> degrees,
    List<ExamBO> exams, void Function(CalendarFilter) filteredExams) {
  var degreeItems = degrees;
  var degree = degreeItems[0].obs;
  var calls = ['january'.tr, 'may'.tr, 'june'.tr];
  var call = 'january'.tr.obs;
  var startDateText = 'startDate'.tr.obs;
  var endDateText = 'endDate'.tr.obs;
  Rx<DateTime> selectedStartDate = DateTime.now().obs;
  Rx<DateTime> selectedEndDate = DateTime.now().obs;

  _selectDate(BuildContext context, DateTime date,
      void Function(DateTime?) selectDate) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2010),
      lastDate: DateTime(2050),
    );
    selectDate(selected);
  }

  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('degree'.tr),
                materialDropdownDegree(degree, degreeItems),
              ]),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('call'.tr),
                  materialDropdown(call, calls),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('selectStartDate'.tr),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: Size.infinite.width,
                    height: 45,
                    child: ElevatedButton(
                      child: Obx(() {
                        return Text(startDateText.value);
                      }),
                      onPressed: () {
                        _selectDate(context, selectedStartDate.value,
                            (selected) {
                          if (selected != null &&
                              selected != selectedStartDate.value) {
                            selectedStartDate.value = selected;
                            startDateText.value = selected.dateToString();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('selectEndDate'.tr),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: Size.infinite.width,
                    height: 45,
                    child: ElevatedButton(
                      child: Obx(() {
                        return Text(endDateText.value);
                      }),
                      onPressed: () {
                        _selectDate(context, selectedEndDate.value, (selected) {
                          if (selected != null &&
                              selected != selectedEndDate.value) {
                            selectedEndDate.value = selected;
                            endDateText.value = selected.dateToString();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text('cancel'.tr),
        ),
        TextButton(
          onPressed: () {
            final examsFiltered = exams
                .where(
                    (element) => element.subject.degree.id == degree.value.id)
                .toList();
            Navigator.pop(context, 'OK');
            filteredExams(CalendarFilter(
                examsFiltered,
                selectedStartDate.value.dateToString(),
                selectedEndDate.value.dateToString(),
                call.value,
                degree.value.name));
          },
          child: Text('ok'.tr),
        ),
      ],
    ),
  );
}
