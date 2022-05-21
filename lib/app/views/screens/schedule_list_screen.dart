import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/views/dialog/schedule_dialog.dart';
import '../../controller/schedule_list_controller.dart';
import '../custom/empty_view.dart';
import '../custom/schedule_tile.dart';

class ScheduleListScreen extends GetView<ScheduleListController> {
  const ScheduleListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        return Obx(
          () => controller.loading
              ? const Center(child: CircularProgressIndicator())
              : _setScheduleList(context),
        );
      },
    ));
  }

  Widget _setScheduleList(
    BuildContext context,
  ) {
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
        title: Text('schedule'.tr),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          scheduleDialog(
              'createSchedule'.tr,
              context,
              controller.degrees,
              controller.subjects,
              (scheduleFilters) {
                controller.createSchedule(scheduleFilters);
              });
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: controller.schedules.isEmpty
          ? emptyView('noSchedule'.tr)
          : SafeArea(
              child: RefreshIndicator(
                  onRefresh: () async {
                    controller.getSchedules();
                    controller.getDegrees();
                    controller.getSubjects();
                  },
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              scheduleTile(MediaQuery.of(context).size.width < 600, controller.schedules, index),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      controller.updateSchedule(controller.schedules[index]);
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      controller.deleteSchedule(
                                          controller.schedules[index]);
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
                      itemCount: controller.schedules.length)),
            ),
    );
  }
}
