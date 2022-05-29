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
        if (constraints.maxWidth < 600) {
          return Obx(
            () => controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _setCreateCalendar(context, true),
          );
        } else {
          return Obx(
            () => controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _setCreateCalendar(context, false),
          );
        }
      },
    ));
  }

  Widget _setCreateCalendar(BuildContext context, bool mobile) {
    controller.setMobile(mobile);
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
        leading: IconButton(
            onPressed: () {
              Get.offNamed(Routes.home,
                  arguments: {'page': Routes.calendarList});
            },
            icon: const Icon(Icons.arrow_back_ios_outlined)),
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
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: GridView.builder(
                    gridDelegate: mobile
                        ? const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, childAspectRatio: 0.8)
                        : const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8, childAspectRatio: 1),
                    itemCount: controller.numberOfCells,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.white30,
                        child: SizedBox(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(controller.dateArray[index]),
                              const Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 8, left: 8, right: 8)),
                              _dragTarget(index, true, mobile, controller.dateArray[index]),
                              const SizedBox(
                                height: 8,
                              ),
                              _dragTarget(index, false, mobile, controller.dateArray[index]),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
            _dragListExams()
          ],
        ),
      ),
    );
  }

  Widget _dragTarget(int index, bool morning, bool mobile, String date) {
    //var acceptedData = getAcceptedData();

    return DragTarget<ExamBox>(builder: (
      BuildContext context,
      List<dynamic> accepted,
      List<dynamic> rejected,
    ) {
      final acceptedData = controller.examsToUpload[index];
      return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Container(
          decoration: BoxDecoration(
            color: acceptedData != null ? (morning ? Colors.green : Colors.orange) : Colors.white,
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                width: Size.infinite.width,
                child: Text(acceptedData != null ? acceptedData.acronym : morning ? 'morning'.tr : 'afternoon'.tr)),
          ),
        ),
      );
    }, onAccept: (ExamBox exam) {
      final item = exam.exam.copyWith(newDate: date, newCall: controller.call, newTurn: morning ? "MORNING" : "AFTERNOON");
      controller.completeDrag(item, index);
      },);
  }

  Widget _dragListExams() {
    return Obx(() => Padding(
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
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
    ),
    );
  }
}