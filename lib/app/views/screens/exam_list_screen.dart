import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/exam_list_controller.dart';
import '../custom/exam_tile.dart';
import '../dialog/exam_dialog.dart';


class ExamListScreen extends GetView<ExamListController> {
  const ExamListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Obx(
                () =>
            controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _setExamList(true, context),
          );
        } else {
          return Obx(
                () =>
            controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _setExamList(false, context),
          );
        }
      },
    ));
  }

  Widget _setExamList(
    bool mobile,
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

    return Scaffold(
      appBar: AppBar(
        title: Text('exam'.tr),
      ),
      body: controller.exams.isEmpty
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
                          examTile(
                              MediaQuery.of(context).size.width < 600,
                              controller.exams,
                              index),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  examDialog(
                                      context,
                                      controller.exams[index],
                                      controller.subjects,
                                      mobile,
                                      (exam) => (controller
                                          .updateExam(exam)));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  controller.deleteExam(
                                      controller.exams[index]);
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
                  itemCount: controller.exams.length)),
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
              Text(
                'noDepartment'.tr,
                style: const TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
