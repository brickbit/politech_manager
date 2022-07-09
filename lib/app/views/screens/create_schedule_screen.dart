import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/extension/color_extension.dart';
import 'package:politech_manager/app/views/custom/subject_box.dart';
import 'package:politech_manager/data/mapper/data_mapper.dart';
import '../../../domain/constant/constant.dart';
import '../../controller/create_schedule_controller.dart';
import '../../navigation/app_routes.dart';
import '../custom/material_dropdown.dart';
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
    var days = [
      'monday'.tr,
      'tuesday'.tr,
      'wednesday'.tr,
      'thursday'.tr,
      'friday'.tr
    ];
    var day = 'monday'.tr.obs;
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
        leading: IconButton(
            onPressed: () {
              Get.offNamed(Routes.home,
                  arguments: {'page': Routes.scheduleList});
            },
            icon: const Icon(Icons.arrow_back_ios_outlined)),
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
            Obx(
              () => controller.scheduleType == 'oneSubjectPerHour'.tr
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: materialDropdown(day, days),
                    ),
            ),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: controller.scheduleType == 'oneSubjectPerHour'.tr
                    ? _simpleSchedule(mobile)
                    : Obx(() => _severalSchedule(mobile, day.value, context)),
              ),
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

  Widget _severalSchedule(bool mobile, String day, BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.horizontal,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: _daySchedule(mobile)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: _daySchedule(mobile)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: _daySchedule(mobile)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: _daySchedule(mobile)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: _daySchedule(mobile)),
          ),
        ),
      ],
    );
  }

  Widget _daySchedule(bool mobile) {
    final ratio = mobile ? 0.4 : 1.4;
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
                      '${controller.calculateDay(index, mobile)} ${controller.calculateHour(index)}'),
                  const Padding(
                      padding: EdgeInsets.only(bottom: 8, left: 8, right: 8)),
                  _dragTargetLayered(index, mobile, 0),
                  const Padding(padding: EdgeInsets.only(bottom: 8)),
                  _dragTargetLayered(index, mobile, 1),
                  const Padding(padding: EdgeInsets.only(bottom: 8)),
                  _dragTargetLayered(index, mobile, 2),
                ],
              ),
            ),
          );
        });
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
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Container(
              decoration: BoxDecoration(
                color: (controller.subjectsToUpload[index] != null)
                    ? controller.subjectsToUpload[index]!.color.parseColor()
                    : Colors.white,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (controller.subjectsToUpload[index] != null)
                                ? controller.subjectsToUpload[index]!.acronym
                                : 'empty'.tr,
                            style: const TextStyle(fontSize: 10),
                          ),
                          (controller.subjectsToUpload[index] != null
                              ? IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    controller.deleteItem(
                                        controller.subjectsToUpload[index]!);
                                  },
                                  icon: Icon(Icons.delete,
                                      size: mobile ? 10 : 20),
                                )
                              : SizedBox(
                                  height: mobile ? 10 : 36,
                                  width: mobile ? 10 : 36,
                                ))
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ((controller.subjectsToUpload[index]?.laboratory ??
                                      false) ==
                                  true)
                              ? Icon(
                                  Icons.science_sharp,
                                  size: mobile ? 10 : 18,
                                )
                              : Container(),
                          ((controller.subjectsToUpload[index]?.seminary ??
                                      false) ==
                                  true)
                              ? Icon(
                                  Icons.emoji_people_sharp,
                                  size: mobile ? 10 : 18,
                                )
                              : Container(),
                          ((controller.subjectsToUpload[index]?.english ??
                                      false) ==
                                  true)
                              ? Icon(
                                  Icons.flag,
                                  size: mobile ? 10 : 18,
                                )
                              : Container(),
                        ],
                      )
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
            subject.subject.copyWith(newDay: "", newHour: "", newTurn: "");
        controller.completeDrag(item, index);
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
                color: (controller.subjectsToUpload[index +
                            (controller.subjectsToUpload.length / 3).round() *
                                layer] !=
                        null)
                    ? controller
                        .subjectsToUpload[index +
                            (controller.subjectsToUpload.length / 3).round() *
                                layer]!
                        .color
                        .parseColor()
                    : Colors.white,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (controller.subjectsToUpload[index +
                                        (controller.subjectsToUpload.length / 3)
                                                .round() *
                                            layer] !=
                                    null)
                                ? controller
                                    .subjectsToUpload[index +
                                        (controller.subjectsToUpload.length / 3)
                                                .round() *
                                            layer]!
                                    .acronym
                                : 'empty'.tr,
                            style: const TextStyle(fontSize: 10),
                          ),
                          (controller.subjectsToUpload[index +
                                      (controller.subjectsToUpload.length / 3)
                                              .round() *
                                          layer] !=
                                  null
                              ? IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    controller.deleteItem(
                                        controller.subjectsToUpload[index +
                                            (controller.subjectsToUpload
                                                            .length /
                                                        3)
                                                    .round() *
                                                layer]!);
                                  },
                                  icon: Icon(Icons.delete,
                                      size: mobile ? 10 : 20),
                                )
                              : SizedBox(
                                  height: mobile ? 10 : 36,
                                  width: mobile ? 10 : 36,
                                ))
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ((controller
                                          .subjectsToUpload[index +
                                              (controller.subjectsToUpload
                                                              .length /
                                                          3)
                                                      .round() *
                                                  layer]
                                          ?.laboratory ??
                                      false) ==
                                  true)
                              ? Icon(
                                  Icons.science_sharp,
                                  size: mobile ? 10 : 18,
                                )
                              : Container(),
                          ((controller
                                          .subjectsToUpload[index +
                                              (controller.subjectsToUpload
                                                              .length /
                                                          3)
                                                      .round() *
                                                  layer]
                                          ?.seminary ??
                                      false) ==
                                  true)
                              ? Icon(
                                  Icons.emoji_people_sharp,
                                  size: mobile ? 10 : 18,
                                )
                              : Container(),
                          ((controller
                                          .subjectsToUpload[index +
                                              (controller.subjectsToUpload
                                                              .length /
                                                          3)
                                                      .round() *
                                                  layer]
                                          ?.english ??
                                      false) ==
                                  true)
                              ? Icon(
                                  Icons.flag,
                                  size: mobile ? 10 : 18,
                                )
                              : Container(),
                        ],
                      )
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
            subject.subject.copyWith(newDay: "", newHour: "", newTurn: "");
        controller.completeDrag(item, index);
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
