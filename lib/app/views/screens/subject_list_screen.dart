import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/subject_list_controller.dart';
import '../custom/subject_tile.dart';
import '../dialog/subject_dialog.dart';

class SubjectListScreen extends GetView<SubjectListController> {
  const SubjectListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Obx(
                () =>
            controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _setSubjectList(Size.infinite.width, Size.infinite.width,
                Size.infinite.width, context, true),
          );
        } else {
          return Obx(
                () =>
            controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _setSubjectList(Size.infinite.width, Size.infinite.width,
                Size.infinite.width, context, false),
          );
        }
      },
    ));
  }

  Widget _setSubjectList(
    double instructionsWidth,
    double mailTextFieldWidth,
    double buttonWidth,
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
        title: Text('subject'.tr),
      ),
      body: controller.subjects.isEmpty
          ? _emptyView()
          : SafeArea(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          subjectTile(MediaQuery.of(context).size.width < 600, controller.subjects, index),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  subjectDialog(context, controller.subjects[index], controller.classrooms,
                                      controller.departments,
                                      controller.degrees, mobile, (subject) => (controller.updateSubject(subject)));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  controller.deleteSubject(controller.subjects[index]);
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
                  itemCount: controller.subjects.length)),
    );
  }

  Widget _emptyView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/no_data_bro.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                height: 500,
              ),
              Text('noSubject'.tr, style: const TextStyle(fontSize: 22), textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    );
  }
}
