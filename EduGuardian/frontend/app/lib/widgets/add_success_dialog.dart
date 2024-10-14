import 'package:flutter/material.dart';

void showAddSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle,
                color: Color.fromARGB(255, 40, 120, 63), size: 40),
            SizedBox(width: 10),
            Text(
              'Success!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Added successfully.',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // ปิด popup
              Navigator.pop(
                  context, true); // กลับไปที่หน้า StudentPage และรีเฟรช
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Color.fromARGB(255, 40, 120, 63),
                fontSize: 18,
              ),
            ),
          ),
        ],
      );
    },
  );
}
