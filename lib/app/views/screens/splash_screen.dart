

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {

  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 160,
              child: Image(
                image: AssetImage(
                  'assets/images/epcc.png',
                ),
              ),
            ),
            const SizedBox(height: 80,),
            const CircularProgressIndicator(),
            const SizedBox(height: 16,),
            Text(
              'loading'.tr,
              style: GoogleFonts.montserrat(fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }

}
