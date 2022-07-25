
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void fileTypeDialog(BuildContext context, void Function(String) fileType) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('fileType'.tr),
      content: SizedBox(
        height: 190,
        child: Column(
          children: [
            ListTile(
              title: Text('subject'.tr,),
              onTap: () {
                fileType('subject'.tr);
                Navigator.pop(context, 'OK');
              },
            ),
            Container(
              height: 1,
              width: 200,
              color: Colors.grey,
            ),
            ListTile(
              title: Text('department'.tr),
              onTap: () {
                fileType('department'.tr);
                Navigator.pop(context, 'OK');
              },
            ),
            Container(
              height: 1,
              width: 200,
              color: Colors.grey,
            ),
            ListTile(
              title: Text('classroom'.tr),
              onTap: () {
                fileType('classroom'.tr);
                Navigator.pop(context, 'OK');
              },
            ),
          ],
        ),
      ),
    ),
  );
}