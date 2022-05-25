import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/views/dialog/degree_dialog.dart';
import '../../controller/degree_list_controller.dart';
import '../custom/degree_tile.dart';
import '../custom/empty_view.dart';

class DegreeListScreen extends GetView<DegreeListController> {
  const DegreeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return Obx(
              () =>
          controller.loading
              ? const Center(child: CircularProgressIndicator())
              : _setDegreeList(context, true),
        );
      } else {
        return Obx(
              () =>
          controller.loading
              ? const Center(child: CircularProgressIndicator())
              : _setDegreeList(context, false),
        );
      }
      },
    ));
  }

  Widget _setDegreeList(
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
        title: Text('degree'.tr),
      ),
      body: controller.degrees.isEmpty
          ? emptyView('noDegree'.tr, mobile)
          : SafeArea(
              child: RefreshIndicator(
                  onRefresh: () async {
                    controller.getDegrees();
                  },
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              degreeTile(
                                  MediaQuery.of(context).size.width < 600,
                                  controller.degrees,
                                  index),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      degreeDialog(
                                          'editDegree'.tr,
                                          context,
                                          controller.degrees[index],
                                          (degree) => (controller
                                              .updateDegree(degree)));
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      controller.deleteDegree(
                                          controller.degrees[index]);
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
            ),
    );
  }
}
