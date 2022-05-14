import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:politech_manager/app/views/dialog/degree_dialog.dart';
import 'package:politech_manager/app/views/dialog/subject_dialog.dart';
import '../../controller/data_controller.dart';
import '../../navigation/app_routes.dart';
import '../dialog/classroom_dialog.dart';
import '../dialog/department_dialog.dart';
import '../dialog/exam_dialog.dart';

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
                  return _dataTile(getName(index), index, false, context);
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
            //_getListData(false),
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
      leading: IconButton(
          icon: const Icon(
            Icons.add,
            color: Colors.green,
          ),
          onPressed: () {
            controller.hideError();
            switch (index) {
              case 0:
                degreeDialog(context, null,
                    (degree) => (controller.uploadDegree(degree)));
                break;
              case 1:
                classroomDialog(context, null,
                    (classroom) => (controller.uploadClassroom(classroom)));
                break;
              case 2:
                departmentDialog(context, null,
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
                  examDialog(context, null, controller.subjects, mobile,
                      (exam) => (controller.uploadExam(exam)));
                }
                break;
              default:
                degreeDialog(context, null,
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

  /*Widget _getListData(bool mobile) {
    switch (controller.index.value) {
      case 0:
        return Expanded(child: _listDegree());
      case 1:
        return Expanded(child: _listClassroom());
      case 2:
        return Expanded(child: _listDepartment());
      case 3:
        return Expanded(child: _listSubject(mobile));
      default:
        return Container(
          color: Colors.white54,
        );
    }
  }*/

  /*Widget _listDegree() {
    return controller.obx(
      (data) => ListView.separated(
          scrollDirection: Axis.vertical,
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //degreeTile(MediaQuery.of(context).size.width < 600, data?.degrees ?? [], index),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          /*degreeDialog(data?.degrees[index], 'editDegree'.tr)
                              .then(
                            (value) {
                              if (value != null) {
                                controller.updateDegree(value);
                                controller.update();
                              }
                            },
                          );*/
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          controller.deleteDegree(data?.degrees[index].id ?? 0);
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
          itemCount: data?.degrees.length ?? 0),
      onLoading: Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      onEmpty: Container(
        color: Colors.white,
        child: Text('noDataLoaded'.tr),
      ),
    );
  }

  Widget _listClassroom() {
    return controller.obx((data) {
      return ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //classroomTile(MediaQuery.of(context).size.width < 600, data?.classrooms ?? [], index),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          /*classroomDialog(
                                  data?.classrooms[index], 'editClassroom'.tr)
                              .then(
                            (value) {
                              if (value != null) {
                                controller.updateClassroom(value);
                                controller.update();
                              }
                            },
                          );*/
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          controller
                              .deleteClassroom(data?.classrooms[index].id ?? 0);
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
          itemCount: data?.classrooms.length ?? 0);
    });
  }

  Widget _listDepartment() {
    return controller.obx((data) {
      return ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //departmentTile(MediaQuery.of(context).size.width < 600, data?.departments ?? [], index),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          /*departmentDialog(
                                  data?.departments[index], 'editDepartment'.tr)
                              .then(
                            (value) {
                              if (value != null) {
                                controller.updateDepartment(value);
                                controller.update();
                              }
                            },
                          );*/
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          controller.deleteDepartment(
                              data?.departments[index].id ?? 0);
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
          itemCount: data?.departments.length ?? 0);
    });
  }

  Widget _listSubject(bool mobile) {
    return controller.obx((data) {
      return ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //subjectTile(MediaQuery.of(context).size.width < 600, data?.subjects ?? [], index),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () async {
                          /*subjectDialog(mobile, data?.subjects[index],
                                  'editSubject'.tr, controller)
                              .then(
                            (value) {
                              if (value != null) {
                                controller.updateSubject(value);
                                controller.update();
                              }
                            },
                          );*/
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          controller
                              .deleteSubject(data?.subjects[index].id ?? 0);
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
          itemCount: data?.subjects.length ?? 0);
    });
  }*/
}
