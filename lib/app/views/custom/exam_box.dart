import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/model/exam_bo.dart';

class ExamBox extends StatelessWidget {
  final ExamBO exam;

  const ExamBox({
    Key? key,
    required this.exam,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 4,
                ),
                exam.turn == "morning".tr
                    ? const Icon(Icons.sunny,
                        color: Colors.black45, size: 16)
                    : const Icon(Icons.shield_moon,
                    color: Colors.black45, size: 16),
                Text(
                  exam.acronym,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
