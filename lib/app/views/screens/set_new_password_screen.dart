
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/views/custom/password_text_field.dart';

import '../../controller/set_new_password_controller.dart';

class SetNewPasswordScreen extends GetView<SetNewPasswordController> {
  SetNewPasswordScreen({Key? key}) : super(key: key);

  final _mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Obx(
                () => controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _setNewPasswordScreen(Size.infinite.width,
                Size.infinite.width, Size.infinite.width, context),
          );
        } else {
          return Obx(
                () => controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _setNewPasswordScreen(300, 300, 300, context),
          );
        }
      },
    ));
  }

  Widget _setNewPasswordScreen(
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
        title: Text('setNewPassword'.tr),
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
                SizedBox(
                  width: instructionsWidth,
                  child: Text('setNewPasswordInstructions'.tr),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: mailTextFieldWidth,
                  child: PasswordTextField(title:'putPassword'.tr, passwordController:_mailController),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                    width: buttonWidth,
                    height: 45,
                    child: ElevatedButton(
                        child: Text('setNewPassword'.tr),
                        onPressed: () {
                          controller.setNewPassword(_mailController.text);
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
