import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/data/mapper/data_mapper.dart';
import '../../controller/create_calendar_controller.dart';
import '../../navigation/app_routes.dart';
import '../custom/exam_box.dart';
import '../dialog/file_dialog.dart';

class CreateCalendarScreen extends GetView<CreateCalendarController> {
  const CreateCalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        return Obx(
          () => controller.loading
              ? const Center(child: CircularProgressIndicator())
              : _setCreateCalendar(context),
        );
      },
    ));
  }

  Widget _setCreateCalendar(
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
        title: Text('editCalendar'.tr),
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Get.offNamed(Routes.home, arguments: {'page': Routes.calendarList});
        }, icon: const Icon(Icons.arrow_back_ios_outlined)),
        actions: [
          IconButton(
              onPressed: () {
                controller.saveCalendar();
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
            _dragListExams()
          ],
        ),
      ),
    );
  }

  Widget _dragListExams() {
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
            itemCount: controller.exams.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 70,
                height: 50,
                child: Draggable<ExamBox>(
                  data: controller.exams
                      .map((data) => data.toExamBox())
                      .toList()[index],
                  feedback: controller.exams
                      .map((data) => data.toExamBox())
                      .toList()[index],
                  onDragStarted: () {
                    controller.startDrag(index);
                  },
                  onDragCompleted: () {
                    controller.dragItemSuccessfully(index);
                  },
                  child: controller.exams
                      .map((data) => data.toExamBox())
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
