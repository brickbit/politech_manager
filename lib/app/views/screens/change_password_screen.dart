import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/change_password_controller.dart';
import '../custom/password_text_field.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  ChangePasswordScreen({Key? key}) : super(key: key);

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Obx(
            () => controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _changePasswordScreen(Size.infinite.width,
                    Size.infinite.width, Size.infinite.width, context),
          );
        } else {
          return Obx(
            () => controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _changePasswordScreen(300, 300, 300, context),
          );
        }
      },
    ));
  }

  Widget _changePasswordScreen(
    double instructionsWidth,
    double mailTextFieldWidth,
    double buttonWidth,
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
        title: Text('updatePassword'.tr),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                ColorFiltered(
                  colorFilter:
                      ColorFilter.mode((Colors.grey[400])!, BlendMode.modulate),
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/mural_epcc.png'),
                      fit: BoxFit.cover,
                    )),
                    height: 350,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: mailTextFieldWidth,
                  child: PasswordTextField(title:'putOldPassword'.tr, passwordController:_oldPasswordController),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: mailTextFieldWidth,
                  child: PasswordTextField(title:'putNewPassword'.tr, passwordController:_newPasswordController),
                ),
                const SizedBox(
                  height: 32,
                ),
                SizedBox(
                    width: buttonWidth,
                    height: 45,
                    child: ElevatedButton(
                        child: Text('setNewPassword'.tr),
                        onPressed: () {
                          controller.changePassword(_oldPasswordController.text,_newPasswordController.text);
                        },
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
