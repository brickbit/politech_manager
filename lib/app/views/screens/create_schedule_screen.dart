import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/views/custom/subject_box.dart';
import 'package:politech_manager/data/mapper/data_mapper.dart';
import '../../controller/create_schedule_controller.dart';
import '../../navigation/app_routes.dart';
import '../dialog/file_dialog.dart';

class CreateScheduleScreen extends GetView<CreateScheduleController> {
  const CreateScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        return Obx(
          () => controller.loading
              ? const Center(child: CircularProgressIndicator())
              : _setCreateSchedule(context),
        );
      },
    ));
  }

  Widget _setCreateSchedule(
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
    Future.delayed(Duration.zero, () {
      if (controller.fileDownloaded) {
        fileDialog(controller.path, context, () {
          controller.openFile();
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('editSchedule'.tr),
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Get.offNamed(Routes.home, arguments: {'page': Routes.scheduleList});
        }, icon: const Icon(Icons.arrow_back_ios_outlined)),
        actions: [
          IconButton(
              onPressed: () {
                controller.saveSchedule();
              },
              icon: const Icon(Icons.save_sharp)),
          IconButton(
              onPressed: () {
                controller.downloadFile();
              },
              icon: const Icon(Icons.download))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(),
            ),
            _dragListSubjects()
          ],
        ),
      ),
    );
  }

  Widget _dragListSubjects() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        height: 65,
        child: Container(
          margin: const EdgeInsets.symmetric(
              vertical: 8.0, horizontal: 8.0),
          height: 50.0,
          child: ListView.separated(
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: controller.subjects.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 70,
                height: 50,
                child: Draggable<SubjectBox>(
                  data: controller.subjects
                      .map((data) => data.toSubjectBox())
                      .toList()[index],
                  feedback: controller.subjects
                      .map((data) => data.toSubjectBox())
                      .toList()[index],
                  onDragStarted: () {
                    controller.startDrag(index);
                  },
                  onDragCompleted: () {
                    controller.dragItemSuccessfully(index);
                  },
                  child: controller.subjects
                      .map((data) => data.toSubjectBox())
                      .toList()[index],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                width: 16,
              );
            },
          ),
        ),
      ),
    );
  }
}
