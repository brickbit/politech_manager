import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/views/custom/classroom_tile.dart';
import 'package:politech_manager/app/views/dialog/classroom_dialog.dart';
import '../../controller/classroom_list_controller.dart';
import '../custom/empty_view.dart';

class ClassroomListScreen extends GetView<ClassroomListController> {
  const ClassroomListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return Obx(
              () =>
          controller.loading
              ? const Center(child: CircularProgressIndicator())
              : _setClassroomList(context, true),
        );
      } else {
        return Obx(
              () =>
          controller.loading
              ? const Center(child: CircularProgressIndicator())
              : _setClassroomList(context, false),
        );
      }
      },
    ));
  }

  Widget _setClassroomList(
    BuildContext context,
      bool mobile
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
        title: Text('classroom'.tr),
      ),
      body: controller.classrooms.isEmpty
          ? emptyView('noClassroom'.tr, mobile, () {
            controller.getClassrooms();
      })
          : SafeArea(
              child: RefreshIndicator(
                  onRefresh: () async {
                    controller.getClassrooms();
                  },
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              classroomTile(
                                  MediaQuery.of(context).size.width < 600,
                                  controller.classrooms,
                                  index),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      classroomDialog(
                                          'editClassroom'.tr,
                                          context,
                                          controller.classrooms[index],
                                          (classroom) => (controller
                                              .updateClassroom(classroom)));
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      controller.deleteClassroom(
                                          controller.classrooms[index]);
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
                      itemCount: controller.classrooms.length)),
            ),
    );
  }
}
