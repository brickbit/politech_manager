import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/views/dialog/teacher_dialog.dart';
import '../../controller/teacher_list_controller.dart';
import '../custom/empty_view.dart';
import '../custom/teacher_tile.dart';

class TeacherListScreen extends GetView<TeacherListController> {
  const TeacherListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Obx(
                () =>
            controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _setTeacherList(context, true),
          );
        } else {
          return Obx(
                () =>
            controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _setTeacherList(context, false),
          );
        }
      },
    ));
  }

  Widget _setTeacherList(
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
        title: Text('teacher'.tr),
      ),
      body: controller.teachers.isEmpty
          ? emptyView('noTeacher'.tr, mobile, () {
        controller.getTeachers();
      })
          : SafeArea(
        child: RefreshIndicator(
            onRefresh: () async {
              controller.getTeachers();
            },
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        teacherTile(
                            MediaQuery.of(context).size.width < 600,
                            controller.teachers,
                            index),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                teacherDialog(
                                    'editTeacher'.tr,
                                    context,
                                    controller.departments,
                                    controller.teachers[index],
                                        (teacher) => (controller
                                        .updateTeacher(teacher)));
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                controller.deleteTeacher(
                                    controller.teachers[index]);
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
                itemCount: controller.teachers.length)),
      ),
    );
  }
}
