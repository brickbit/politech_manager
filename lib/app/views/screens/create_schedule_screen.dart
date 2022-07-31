import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/extension/color_extension.dart';
import 'package:politech_manager/app/views/custom/subject_box.dart';
import 'package:politech_manager/app/views/dialog/file_type_dialog.dart';
import 'package:politech_manager/data/mapper/data_mapper.dart';
import '../../../domain/constant/constant.dart';
import '../../../domain/model/subject_bo.dart';
import '../../../domain/model/subject_state.dart';
import '../../controller/create_schedule_controller.dart';
import '../../navigation/app_routes.dart';
import '../dialog/conflict_dialog.dart';
import '../dialog/file_dialog.dart';

class CreateScheduleScreen extends GetView<CreateScheduleController> {
  const CreateScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Obx(
            () => controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _setCreateSchedule(context, true),
          );
        } else {
          return Obx(
            () => controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _setCreateSchedule(context, false),
          );
        }
      },
    ));
  }

  Widget _setCreateSchedule(BuildContext context, bool mobile) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.redAccent,
      content: Text(controller.errorMsg),
    );

    final snackBarWarning = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.amber,
      content: Text(controller.errorMsg, style: const TextStyle(color: Colors.black),),
    );

    Future.delayed(Duration.zero, () {
      if (controller.error) {
        ScaffoldMessenger.of(context).showSnackBar(snackBarWarning);
        controller.hideError();
      }
    });

    Future.delayed(Duration.zero, () {
      if (controller.warning) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        controller.hideWarning();
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
        leading: IconButton(
            onPressed: () {
              Get.offNamed(Routes.home,
                  arguments: {'page': Routes.scheduleList});
            },
            icon: const Icon(Icons.arrow_back_ios_outlined)),
        actions: [
          IconButton(
              onPressed: () {
                if (!controller.showCollisions.value) {
                  List<SubjectBO> items = controller.subjects.where((element) =>
                  !element.seminary && !element.laboratory)
                      .toSet()
                      .toList();
                  conflictDialog(items, context, (subject) {
                    controller.hideConflicts();
                    controller.showDepartmentConflicts(subject.department);
                    controller.showClassroomConflicts(subject.classroom);
                    controller.showCollisions.value = true;
                    controller.update();
                  });
                } else {
                  controller.hideConflicts();
                  controller.showCollisions.value = false;
                  controller.update();
                }
              },
              icon: controller.showCollisions.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility)),
          IconButton(
              onPressed: () {
                controller.saveSchedule();
              },
              icon: const Icon(Icons.save_sharp)),
          IconButton(
              onPressed: () async {
                fileTypeDialog(context, (fileType) {
                  controller.fileType.value = fileType;
                  controller.downloadFile();
                });
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
                  child: controller.scheduleType == 'oneSubjectPerHour'.tr
                      ? controller.showCollisions.value ? _simpleSchedule(mobile) : _simpleSchedule(mobile)
                      : controller.showCollisions.value ? _severalSchedule(mobile, context) : _severalSchedule(mobile, context)),
            ),
            _dragListSubjects()
          ],
        ),
      ),
    );
  }

  Widget _simpleSchedule(bool mobile) {
    final ratio = mobile ? 0.7 : 3.2;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, childAspectRatio: ratio),
        itemCount: maxCellsOneSubjectPerDay,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.white30,
            child: SizedBox(
              height: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      '${controller.calculateDay(index, mobile)} ${controller.calculateHour(index)}'),
                  const Padding(
                      padding: EdgeInsets.only(bottom: 4, left: 8, right: 8)),
                  _dragTarget(index, mobile),
                ],
              ),
            ),
          );
        });
  }

  Widget _severalSchedule(bool mobile, BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.horizontal,
      slivers: <Widget>[
        _dayBlock(mobile, context, 'monday'.tr),
        _dayBlock(mobile, context, 'tuesday'.tr),
        _dayBlock(mobile, context, 'wednesday'.tr),
        _dayBlock(mobile, context, 'thursday'.tr),
        _dayBlock(mobile, context, 'friday'.tr),
      ],
    );
  }

  Widget _dayBlock(bool mobile, BuildContext context, String day) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 12.0, bottom: 12.0, left: 60.0, right: 60.0),
                  child: Text(
                    day,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: _daySchedule(
                      mobile, controller.calculateIndexOfDay(day))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _daySchedule(bool mobile, int day) {
    final ratio = mobile ? 0.41 : 1.4;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, childAspectRatio: ratio),
        itemCount: maxCellsOneSubjectPerDay,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.white30,
            child: SizedBox(
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      '${controller.calculateSubjects(index)} ${controller.calculateHour(index)}', style: const TextStyle(fontSize: 10),),
                  const Padding(
                      padding: EdgeInsets.only(bottom: 8, left: 8, right: 8)),
                  _dragTargetLayered(index + day * 120, mobile, 0),
                  const Padding(padding: EdgeInsets.only(bottom: 8)),
                  _dragTargetLayered(index + day * 120 + 600, mobile, 1),
                  const Padding(padding: EdgeInsets.only(bottom: 8)),
                  _dragTargetLayered(index + day * 120 + 1200, mobile, 2),
                ],
              ),
            ),
          );
        });
  }

  Color _getCellColor(int index) {
    if (controller.subjectsToUpload[index] != null) {
      return controller.subjectsToUpload[index]!.subject != null ? controller.subjectsToUpload[index]!.subject!.color.parseColor() : Colors.white;
    } else {
      return Colors.white;
    }
  }

  Widget _setEmptyCell(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'empty'.tr,
          style: const TextStyle(fontSize: 12),
        ),
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            controller.subjectsToUpload[index]
                ?.state ==
                SubjectState.departmentCollision
                ? const Icon(
              Icons.warning,
              color: Colors.amberAccent,
              size: 18,
            )
                : Container(),
            controller.subjectsToUpload[index]
                ?.state ==
                SubjectState.departmentCollision
                ? const Icon(
              Icons.cancel,
              color: Colors.red,
              size: 18,
            )
                : Container()
          ],
        )
      ],
    );
  }


  Widget _dragTarget(int index, bool mobile) {
    return DragTarget<SubjectBox>(
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
                color: _getCellColor(index),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: SizedBox(
                  width: Size.infinite.width,
                  height: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (controller.subjectsToUpload[index]?.subject == null)
                          ? SizedBox(
                              height: 36,
                              child: _setEmptyCell(index)
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      controller.subjectsToUpload[index]!.subject!.acronym,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ((controller.subjectsToUpload[index]?.subject?.laboratory ??
                                                    false) ==
                                                true)
                                            ? Icon(
                                                Icons.science_sharp,
                                                size: mobile ? 14 : 18,
                                              )
                                            : Container(),
                                        ((controller.subjectsToUpload[index]?.subject?.seminary ??
                                                    false) ==
                                                true)
                                            ? Icon(
                                                Icons.emoji_people_sharp,
                                                size: mobile ? 14 : 18,
                                              )
                                            : Container(),
                                        ((controller.subjectsToUpload[index]?.subject?.english ??
                                                    false) ==
                                                true)
                                            ? Icon(
                                                Icons.flag,
                                                size: mobile ? 14 : 18,
                                              )
                                            : Container(),
                                      ],
                                    )
                                  ],
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    controller.deleteItem(controller
                                        .subjectsToUpload[index]!.subject!);
                                  },
                                  icon: Icon(Icons.delete,
                                      size: mobile ? 16 : 20),
                                )
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      onWillAccept: (SubjectBox? subject) {
        if (subject != null) {
          controller.showDepartmentConflicts(subject.subject.department);
          controller.showClassroomConflicts(subject.subject.classroom);
          controller.showCollisions.value = true;
          controller.update();
        }
        return true;
      },
      onAccept: (SubjectBox subject) {
        final item =
            subject.subject.copyWith();
        controller.completeDrag(item, index, false);
        controller.hideConflicts();
        controller.showCollisions.value = false;
        controller.update();
      },
      onLeave: (SubjectBox? subject) {
        controller.hideConflicts();
        controller.showCollisions.value = false;
        controller.update();
      },
    );
  }

  Widget _dragTargetLayered(int index, bool mobile, int layer) {
    return DragTarget<SubjectBox>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return Obx(
          () => Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Container(
              decoration: BoxDecoration(
                color: _getCellColor(index),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: SizedBox(
                  width: Size.infinite.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (controller.subjectsToUpload[index] == null)
                          ? SizedBox(
                              height: 36,
                              child: _setEmptyCell(index)
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      controller.subjectsToUpload[index]!.subject!.classGroup,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ((controller.subjectsToUpload[index]?.subject?.laboratory ??
                                                    false) ==
                                                true)
                                            ? Icon(
                                                Icons.science_sharp,
                                                size: mobile ? 14 : 18,
                                              )
                                            : Container(),
                                        ((controller.subjectsToUpload[index]?.subject?.seminary ??
                                                    false) ==
                                                true)
                                            ? Icon(
                                                Icons.emoji_people_sharp,
                                                size: mobile ? 14 : 18,
                                              )
                                            : Container(),
                                        ((controller.subjectsToUpload[index]?.subject?.english ??
                                                    false) ==
                                                true)
                                            ? Icon(
                                                Icons.flag,
                                                size: mobile ? 14 : 18,
                                              )
                                            : Container(),
                                      ],
                                    )
                                  ],
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    controller.deleteItem(controller
                                        .subjectsToUpload[index]!.subject!);
                                  },
                                  icon: Icon(Icons.delete,
                                      size: mobile ? 16 : 20),
                                )
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      onAccept: (SubjectBox subject) {
        final item =
            subject.subject.copyWith();
        controller.completeDrag(item, index, true);
      },
    );
  }

  Widget _dragListSubjects() {
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
              itemCount: controller.subjects.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 80,
                  height: 50,
                  child: Obx(
                    () => Draggable<SubjectBox>(
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
