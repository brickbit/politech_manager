import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/views/dialog/filter_exam_dialog.dart';
import '../../controller/exam_list_controller.dart';
import '../custom/empty_view.dart';
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
            () => controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _setExamList(true, context),
          );
        } else {
          return Obx(
            () => controller.loading
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
        actions: <Widget>[
          controller.filterActive
              ? IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () {
                    controller.eraseFilters();
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.filter_list),
                  color: controller.filterActive ? Colors.green : Colors.grey,
                  onPressed: () {
                    filterExamDialog(context, controller.subjects,
                        (filters) => (controller.getFilteredExams(filters)));
                  },
                ),
        ],
      ),
      body: controller.exams.isEmpty
          ? emptyView('noExam'.tr)
          : SafeArea(
              child: RefreshIndicator(
                  onRefresh: () async {
                    controller.getExams();
                  },
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              examTile(MediaQuery.of(context).size.width < 600,
                                  controller.exams, index),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      examDialog(
                                          'editExam'.tr,
                                          context,
                                          controller.exams[index],
                                          controller.subjects,
                                          mobile,
                                          (exam) =>
                                              (controller.updateExam(exam)));
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      controller
                                          .deleteExam(controller.exams[index]);
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
            ),
    );
  }
}
