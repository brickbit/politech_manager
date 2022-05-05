import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/views/custom/password_text_field.dart';
import '../../controller/sign_in_controller.dart';

class SignInScreen extends GetView<SignInController> {
  SignInScreen({Key? key}) : super(key: key);

  final _userController = TextEditingController();
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Obx(
            () => controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _recoverPasswordScreen(Size.infinite.width,
                    Size.infinite.width, Size.infinite.width, context),
          );
        } else {
          return Obx(
            () => controller.loading
                ? const Center(child: CircularProgressIndicator())
                : _recoverPasswordScreen(300, 300, 300, context),
          );
        }
      },
    ));
  }

  Widget _recoverPasswordScreen(
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
        title: Text('signIn'.tr),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                /*ColorFiltered(
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
                ),*/
                SizedBox(
                  width: mailTextFieldWidth,
                  child: TextField(
                    controller: _userController,
                    decoration: InputDecoration(labelText: 'putUser'.tr),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: mailTextFieldWidth,
                  child: TextField(
                    controller: _mailController,
                    decoration: InputDecoration(labelText: 'putEmail'.tr),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: instructionsWidth,
                  child: Text('signInInstructions'.tr),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: instructionsWidth,
                  child: PasswordTextField(title: 'putPassword'.tr, passwordController: _passwordController,),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: instructionsWidth,
                  child: PasswordTextField(title: 'putRepeatPassword'.tr, passwordController: _repeatPasswordController,),
                ),
                const SizedBox(
                  height: 32,
                ),
                SizedBox(
                    width: buttonWidth,
                    height: 45,
                    child: ElevatedButton(
                        child: Text('signInButton'.tr),
                        onPressed: () {
                          controller.signIn(_userController.text,_mailController.text,_passwordController.text,_repeatPasswordController.text);
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
