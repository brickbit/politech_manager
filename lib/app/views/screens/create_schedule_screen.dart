import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/extension/color_extension.dart';
import 'package:politech_manager/app/views/custom/subject_box.dart';
import 'package:politech_manager/data/mapper/data_mapper.dart';
import '../../../domain/constant/constant.dart';
import '../../controller/create_schedule_controller.dart';
import '../../navigation/app_routes.dart';
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
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5, childAspectRatio: 4/5),
                    itemCount: maxCellsOneSubjectPerDay,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.white30,
                        child: SizedBox(
                          height: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  '${controller.calculateDay(index)} ${controller.calculateHour(index)}'),
                              const Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 8, left: 8, right: 8)),
                              _dragTarget(index, mobile),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
            _dragListSubjects()
          ],
        ),
      ),
    );
  }

  Widget _dragTarget(int index, bool mobile) {
    return DragTarget<SubjectBox>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return Padding(
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
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: Size.infinite.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text((controller.subjectsToUpload[index] != null)
                        ? controller.subjectsToUpload[index]!.acronym
                        : 'empty'.tr, style: const TextStyle(fontSize: 12),),
                    Row(
                      children: [
                        ((controller.subjectsToUpload[index]?.laboratory  ?? false) == true) ? const Icon(Icons.science_sharp, size: 12,) : Container(),
                        ((controller.subjectsToUpload[index]?.seminary  ?? false) == true) ? const Icon(Icons.emoji_people_sharp,size: 12,) : Container(),
                        ((controller.subjectsToUpload[index]?.english  ?? false) == true) ? const Icon(Icons.flag, size: 12,) : Container(),
                      ],
                    )
                  ],
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
