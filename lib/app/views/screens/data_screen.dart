import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:politech_manager/app/views/dialog/degree_dialog.dart';
import 'package:politech_manager/app/views/dialog/subject_dialog.dart';
import '../../controller/data_controller.dart';
import '../../navigation/app_routes.dart';
import '../custom/classroom_tile.dart';
import '../custom/degree_tile.dart';
import '../custom/department_tile.dart';
import '../custom/empty_view.dart';
import '../custom/exam_tile.dart';
import '../custom/subject_tile.dart';
import '../dialog/classroom_dialog.dart';
import '../dialog/department_dialog.dart';
import '../dialog/exam_dialog.dart';
import '../dialog/filter_exam_dialog.dart';
import '../dialog/filter_subject_dialog.dart';

class DataScreen extends GetView<DataController> {
  const DataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Obx(
              () => controller.loading
                  ? const Center(child: CircularProgressIndicator())
                  : _dataViewSmall(context),
            );
          } else {
            return Obx(
              () => controller.loading
                  ? const Center(child: CircularProgressIndicator())
                  : _dataViewLarge(context),
            );
          }
        },
      ),
    );
  }

  Widget _dataViewSmall(BuildContext context) {
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
        title: Text('fillData'.tr),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(color: Colors.grey),
            );
          },
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return _dataTile(getName(index), index, true, context);
          },
        ),
      ),
    );
  }

  Widget _dataViewLarge(BuildContext context) {
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
        title: Text('fillData'.tr),
        automaticallyImplyLeading: false,
        actions: controller.currentIndex == 3 || controller.currentIndex == 4
            ? <Widget>[
          controller.filterActive
              ? IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              if(controller.currentIndex == 3) {
                controller.eraseSubjectFilters();
              } else {
                controller.eraseExamFilters();
              }
            },
          )
              : IconButton(
            icon: const Icon(Icons.filter_list),
            color: controller.filterActive ? Colors.green : Colors.grey,
            onPressed: () {
              if(controller.currentIndex == 3) {
                filterSubjectDialog(
                    context,
                    controller.classrooms,
                    controller.departments,
                    controller.degrees,
                        (filters) => (controller.getFilteredSubjects(filters)));
              } else {
                filterExamDialog(
                    context,
                    controller.subjects,
                        (filters) => (controller.getFilteredExams(filters)));
              }

            },
          ),
              ]
            : <Widget>[],
      ),
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: 300,
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Divider(color: Colors.grey),
                  );
                },
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: _dataTile(getName(index), index, false, context),);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                height: Size.infinite.height,
                width: 1,
                child: Container(
                  color: Colors.grey,
                ),
              ),
            ),
            _getListData(context),
          ],
        ),
      ),
    );
  }

  String getName(int index) {
    switch (index) {
      case 0:
        return 'degree'.tr;
      case 1:
        return 'classroom'.tr;
      case 2:
        return 'department'.tr;
      case 3:
        return 'subject'.tr;
      case 4:
        return 'exam'.tr;
      default:
        return '';
    }
  }

  Widget _dataTile(String title, int index, mobile, BuildContext context) {
    return ListTile(
      tileColor: controller.currentIndex == index ? Colors.black12: Colors.grey[150],
      leading: IconButton(
          icon: const Icon(
            Icons.add,
            color: Colors.green,
          ),
          onPressed: () {
            controller.hideError();
            switch (index) {
              case 0:
                degreeDialog('createDegree'.tr, context, null,
                    (degree) => (controller.uploadDegree(degree)));
                break;
              case 1:
                classroomDialog('createClassroom'.tr, context, null,
                    (classroom) => (controller.uploadClassroom(classroom)));
                break;
              case 2:
                departmentDialog('createDepartment'.tr, context, null,
                    (department) => (controller.uploadDepartment(department)));
                break;
              case 3:
                if (controller.classrooms.isEmpty ||
                    controller.departments.isEmpty ||
                    controller.degrees.isEmpty) {
                  controller.showError();
                  controller.showErrorMessage('canNotCreateSubject'.tr);
                } else {
                  subjectDialog(
                      'createSubject'.tr,
                      context,
                      null,
                      controller.classrooms,
                      controller.departments,
                      controller.degrees,
                      mobile,
                      (subject) => (controller.uploadSubject(subject)));
                }
                break;
              case 4:
                if (controller.subjects.isEmpty) {
                  controller.showError();
                  controller.showErrorMessage('canNotCreateExam'.tr);
                } else {
                  examDialog('createExam'.tr,context, null, controller.subjects, mobile,
                      (exam) => (controller.uploadExam(exam)));
                }
                break;
              default:
                degreeDialog('createDegree'.tr, context, null,
                    (degree) => (controller.uploadDegree(degree)));
            }
          }),
      title: Text(
        title,
        style: const TextStyle(fontSize: 20),
      ),
      trailing: mobile != false
          ? TextButton(
              onPressed: () {
                switch (index) {
                  case 0:
                    Get.toNamed(Routes.degreeList,
                        arguments: {'degrees': controller.degrees});
                    break;
                  case 1:
                    Get.toNamed(Routes.classroomList,
                        arguments: {'classrooms': controller.classrooms});
                    break;
                  case 2:
                    Get.toNamed(Routes.departmentList,
                        arguments: {'departments': controller.departments});
                    break;
                  case 3:
                    Get.toNamed(Routes.subjectList, arguments: {
                      'subjects': controller.subjects,
                      'degrees': controller.degrees,
                      'classrooms': controller.classrooms,
                      'departments': controller.departments
                    });
                    break;
                  case 4:
                    Get.toNamed(Routes.examList, arguments: {
                      'exams': controller.exams,
                      'subjects': controller.subjects
                    });
                    break;
                  default:
                    Get.toNamed(Routes.degreeList,
                        arguments: {'degrees': controller.degrees});
                }
              },
              child: Text(
                'seeAll'.tr,
                style: const TextStyle(color: Colors.green),
              ),
            )
          : const SizedBox(),
      selectedColor: controller.currentIndex == index ? Colors.grey : null,
      onTap: () {
        controller.changeSection(index);
        controller.update();
      },
    );
  }

  Widget _getListData(BuildContext context) {
    switch (controller.currentIndex) {
      case 0:
        return Expanded(child: _setDegreeList(context));
      case 1:
        return Expanded(child: _setClassroomList(context));
      case 2:
        return Expanded(child: _setDepartmentList(context));
      case 3:
        return Expanded(child: _setSubjectList(context, false));
      case 4:
        return Expanded(child: _setExamList(context, false));
      default:
        return Expanded(
            child: Container(
          color: Colors.white54,
        ));
    }
  }

  Widget _setDegreeList(
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
      body: controller.degrees.isEmpty
          ? emptyView('noDegree'.tr)
          : SafeArea(
              child: ListView.separated(
                  primary: false,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          degreeTile(MediaQuery.of(context).size.width < 600,
                              controller.degrees, index),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  degreeDialog(
                                      'editDegree'.tr,
                                      context,
                                      controller.degrees[index],
                                      (degree) =>
                                          (controller.updateDegree(degree)));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  controller
                                      .deleteDegree(controller.degrees[index]);
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
                  itemCount: controller.degrees.length)),
    );
  }

  Widget _setClassroomList(
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
      body: controller.classrooms.isEmpty
          ? emptyView('noClassroom'.tr)
          : SafeArea(
              child: ListView.separated(
                  primary: false,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          classroomTile(MediaQuery.of(context).size.width < 600,
                              controller.classrooms, index),
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
    );
  }

  Widget _setDepartmentList(
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
      body: controller.departments.isEmpty
          ? emptyView('noDepartment'.tr)
          : SafeArea(
              child: ListView.separated(
                  primary: false,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          departmentTile(
                              MediaQuery.of(context).size.width < 600,
                              controller.departments,
                              index),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  departmentDialog(
                                      'editDepartment'.tr,
                                      context,
                                      controller.departments[index],
                                      (department) => (controller
                                          .updateDepartment(department)));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  controller.deleteDepartment(
                                      controller.departments[index]);
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
                  itemCount: controller.departments.length)),
    );
  }

  Widget _setSubjectList(BuildContext context, bool mobile) {
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
      body: controller.subjects.isEmpty
          ? emptyView('noSubject'.tr)
          : SafeArea(
              child: ListView.separated(
                  primary: false,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          subjectTile(MediaQuery.of(context).size.width < 600,
                              controller.subjects, index),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  subjectDialog(
                                      'editSubject'.tr,
                                      context,
                                      controller.subjects[index],
                                      controller.classrooms,
                                      controller.departments,
                                      controller.degrees,
                                      mobile,
                                      (subject) =>
                                          (controller.updateSubject(subject)));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  controller.deleteSubject(
                                      controller.subjects[index]);
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

  Widget _setExamList(BuildContext context, bool mobile) {
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
      body: controller.exams.isEmpty
          ? emptyView('noExam'.tr)
          : SafeArea(
              child: ListView.separated(
                  primary: false,
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
                                      (exam) => (controller.updateExam(exam)));
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
    );
  }
}
