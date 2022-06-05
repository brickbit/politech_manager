import 'package:flutter/material.dart';

Widget emptyView(String text, bool mobile, Function() action ) {
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
              height: mobile ? 400 : 500,
            ),
            SizedBox(height: mobile ? 12 : 32,),
            Text(text, style: TextStyle(fontSize: mobile ? 18 : 22), textAlign: TextAlign.center,),
            IconButton(onPressed: action, icon: const Icon(Icons.refresh, color: Colors.green, size: 40,))
          ],
        ),
      ),
    ),
  );
}