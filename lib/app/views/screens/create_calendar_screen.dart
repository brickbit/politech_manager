import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/extension/datetime_extension.dart';
import 'package:politech_manager/data/mapper/data_mapper.dart';
import '../../../domain/model/exam_bo.dart';
import '../../../domain/model/exam_state.dart';
import '../../controller/create_calendar_controller.dart';
import '../../navigation/app_routes.dart';
import '../custom/exam_box.dart';
import '../dialog/conflict_exam_dialog.dart';
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
                if (!controller.showCollisions.value) {
                  List<ExamBO> items = controller.exams;
                  conflictExamDialog(items, context, (exam) {
                    controller.hideConflicts();
                    controller.showTeacherConflicts(exam.subject.teacher!);

                    controller.showClassroomConflicts(exam.subject.classroom);
                    controller.showCollisions.value = true;
                    controller.update();
                  });
                } else {
                  controller.hideConflicts();
                  controller.showCollisions.value = false;
                  controller.update();
                }
              },
              icon: controller.showCollisions.value
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility)),
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
                            crossAxisCount: 4, childAspectRatio: 0.65)
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
                              Text(controller.dateArray[index], style: const TextStyle(fontSize: 12),),
                              const Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 8, left: 4, right: 4)),
                              _dragTarget(
                                  index,
                                  true,
                                  mobile,
                                  controller.dateArray[index],
                                  controller.isWeekend(
                                      controller.dateArray[index], true)),
                              const SizedBox(
                                height: 8,
                              ),
                              _dragTarget(
                                  index,
                                  false,
                                  mobile,
                                  controller.dateArray[index],
                                  controller.isWeekend(
                                      controller.dateArray[index], false)),
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

  Widget _dragTarget(
      int index, bool morning, bool mobile, String date, bool weekend) {
    return DragTarget<ExamBox>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return Obx(
          () => Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: Container(
              decoration: BoxDecoration(
                color: weekend
                    ? Colors.red
                    : morning
                        ? (controller.examsToUpload[index].first!.exam != null
                            ? Colors.green
                            : Colors.white)
                        : (controller.examsToUpload[index].last!.exam != null
                            ? Colors.orange
                            : Colors.white),
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top:8, bottom: 8,left: 2),
                child: SizedBox(
                  width: Size.infinite.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      weekend ? Text('weekend'.tr, style: const TextStyle(fontSize: 12))
                          : morning
                            ? controller.examsToUpload[index].first!.exam == null
                              ? _setEmptyCell(index, morning)
                              : Text(controller.examsToUpload[index].first!.exam!.acronym, style: const TextStyle(fontSize: 12))
                            : controller.examsToUpload[index].last!.exam == null
                              ? _setEmptyCell(index, morning)
                              : Text(controller.examsToUpload[index].last!.exam!.acronym, style: const TextStyle(fontSize: 12)),
                      morning
                          ? (controller.examsToUpload[index].first!.exam != null
                              ? IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                                  onPressed: () {
                                    controller.deleteItem(
                                        controller.examsToUpload[index].first!.exam!,
                                        morning);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    size: mobile ? 18 : 20,
                                  ),
                                )
                              : SizedBox(
                                  height: mobile ? 18 : 36,
                                  width: mobile ? 18 : 36,
                                ))
                          : (controller.examsToUpload[index].last!.exam != null
                              ? IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                                  onPressed: () {
                                    controller.deleteItem(
                                        controller.examsToUpload[index].last!.exam!,
                                        morning);
                                  },
                                  icon: Icon(Icons.delete, size: mobile ? 18 : 20),
                                )
                              : SizedBox(
                                  height: mobile ? 18 : 36,
                                  width: mobile ? 18 : 36,
                                ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      onWillAccept: (ExamBox? exam) {
        if (exam != null) {
          if(exam.exam.subject.teacher != null) {
            controller.showTeacherConflicts(exam.exam.subject.teacher);
          }
          controller.showClassroomConflicts(exam.exam.subject.classroom);
          controller.showCollisions.value = true;
          controller.update();
        }
        return true;
      },
      onAccept: (ExamBox exam) {
        if (!weekend) {
          final item = exam.exam.copyWith(
              newDate: date.parseDate(),
              newCall: controller.call,
              newTurn: morning ? "MORNING" : "AFTERNOON");
          controller.completeDrag(item, index, morning);
          controller.hideConflicts();
          controller.showCollisions.value = false;
          controller.update();
        } else {
          controller.showErrorMessage('noExamAllowed'.tr);
          controller.showError();
          controller.restoreDraggableItem(exam.exam);
        }
      },
      onLeave: (ExamBox? exam) {
        controller.hideConflicts();
        controller.showCollisions.value = false;
        controller.update();
      },
    );
  }

  Widget _setEmptyCell(int index, bool morning) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(morning
            ? 'morning'.tr
            : 'afternoon'.tr, style: const TextStyle(fontSize: 12)),
        morning
            ? controller.examsToUpload[index].first!.state == ExamState.classroomCollision || controller.examsToUpload[index].first!.state == ExamState.teacherCollision
              ? const Icon(
                Icons.cancel,
                color: Colors.red,
                size: 16,
              )
              : Container()
            : controller.examsToUpload[index].last!.state == ExamState.classroomCollision || controller.examsToUpload[index].last!.state == ExamState.teacherCollision
              ? const Icon(
                Icons.cancel,
                color: Colors.red,
                size: 16,
              )
              : Container()
      ],
    );
  }

  Widget _dragListExams() {
    return Obx(
      () => Padding(
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
                  child: Obx(
                () => Draggable<ExamBox>(
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
