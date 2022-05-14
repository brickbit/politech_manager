import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/department_list_controller.dart';
import '../custom/department_tile.dart';
import '../dialog/department_dialog.dart';

class DepartmentListScreen extends GetView<DepartmentListController> {
  const DepartmentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        return Obx(
          () => controller.loading
              ? const Center(child: CircularProgressIndicator())
              : _setDepartmentList(context),
        );
      },
    ));
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
      appBar: AppBar(
        title: Text('department'.tr),
      ),
      body: controller.departments.isEmpty
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
                          departmentTile(
                              MediaQuery.of(context).size.width < 600,
                              controller.departments,
                              index),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  departmentDialog(
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
