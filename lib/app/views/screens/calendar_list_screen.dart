import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/calendar_list_controller.dart';
import '../custom/calendar_tile.dart';
import '../custom/empty_view.dart';
import '../dialog/calendar_dialog.dart';

class CalendarListScreen extends GetView<CalendarListController> {
  const CalendarListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return Obx(
              () =>
          controller.loading
              ? const Center(child: CircularProgressIndicator())
              : _setScheduleList(context, true),
        );
      } else {
        return Obx(
              () =>
          controller.loading
              ? const Center(child: CircularProgressIndicator())
              : _setScheduleList(context, false),
        );
      }
      },
    ));
  }

  Widget _setScheduleList(BuildContext context, bool mobile) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.redAccent,
      content: Text(controller.errorMsg),
    );
    Future.delayed(Duration.zero, () {
      if (controller.error) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        controller.hideError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('calendar'.tr),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          calendarDialog('createCalendar'.tr, context, controller.degrees,
              controller.exams, (calendarFilters) {
            controller.createCalendar(calendarFilters);
          });
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: controller.calendars.isEmpty
          ? emptyView('noCalendar'.tr, mobile)
          : SafeArea(
              child: RefreshIndicator(
                  onRefresh: () async {
                    controller.getCalendars();
                    controller.getExams();
                  },
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              calendarTile(
                                  MediaQuery.of(context).size.width < 600,
                                  controller.calendars,
                                  index),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      //controller.updateCalendar(controller.schedules[index]);
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      controller.deleteCalendar(
                                          controller.calendars[index]);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: SizedBox(
                            height: 1,
                            child: Container(
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                      itemCount: controller.calendars.length)),
            ),
    );
  }
}
