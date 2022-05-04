import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/login_controller.dart';
import '../../navigation/app_routes.dart';
import '../custom/password_text_field.dart';

class LoginScreen extends GetView<LoginController> {
  LoginScreen({Key? key}) : super(key: key);

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Obx(
              () => controller.loading
                  ? const Center(child: CircularProgressIndicator())
                  : _loginScreen(true, Size.infinite.width, Size.infinite.width,
                      Size.infinite.width, context),
            );
          } else {
            return Obx(
              () => controller.loading
                  ? const Center(child: CircularProgressIndicator())
                  : _loginScreen(false, 300, 300, 300, context),
            );
          }
        },
      ),
    );
  }

  Widget _loginScreen(
    bool mobile,
    double userTextFieldWidth,
    double passwordTextFieldWidth,
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
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    height: mobile ? 280 : 320,
                  ),
                ),
                SizedBox(
                    width: userTextFieldWidth,
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'email'.tr),
                    )),
                const SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  width: passwordTextFieldWidth,
                  child: PasswordTextField(
                    title: 'password'.tr,
                    passwordController: _passwordController,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                SizedBox(
                    width: buttonWidth,
                    height: 45,
                    child: ElevatedButton(
                        child: Text('login'.tr),
                        onPressed: () {
                          controller.login(_usernameController.text,
                              _passwordController.text);
                        })),
                const SizedBox(
                  height: 30.0,
                ),
                TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.recoverPassword);
                    },
                    child: Text('forgottenPassword'.tr)),
                const SizedBox(
                  height: 8.0,
                ),
                TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.register);
                    },
                    child: Text('register'.tr)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
