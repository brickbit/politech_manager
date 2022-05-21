import 'package:flutter/material.dart';
import 'package:get/get.dart';

void fileDialog(String filePath, BuildContext context, void Function() openFile) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('openDocumentSaved'.tr),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Text('documentSaved'.trParams({
            'path': filePath
          })),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text('cancel'.tr),
        ),
        TextButton(
          onPressed: () {
            openFile();
            Navigator.pop(context, 'OK');
          },
          child: Text('ok'.tr),
        ),
      ],
    ),
  );
}
