import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget emptyView(String text) {
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
            Text(text, style: const TextStyle(fontSize: 22), textAlign: TextAlign.center,)
          ],
        ),
      ),
    ),
  );
}