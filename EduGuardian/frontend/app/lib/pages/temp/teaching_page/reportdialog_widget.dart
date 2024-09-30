import 'package:flutter/material.dart';

class ReportDialog extends StatefulWidget {
  final String studentName;

  ReportDialog({required this.studentName});

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  TextEditingController descriptionController = TextEditingController();
  Map<String, bool> reasons = {
    'ดื้อ': false,
    'ซน': false,
    'กินขนม': false,
    'จีบสาว': false,
    'หลับ': false,
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('รายงานการกระทำของ ${widget.studentName}'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text('โปรดเลือกสาเหตุ:'),
            SizedBox(height: 10),
            Column(
              children: reasons.keys.map((String key) {
                return CheckboxListTile(
                  title: Text(key),
                  value: reasons[key],
                  onChanged: (bool? value) {
                    setState(() {
                      reasons[key] = value ?? false;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'คำอธิบายเพิ่มเติม',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // ปิด popup
          },
          child: Text('ยกเลิก'),
        ),
        TextButton(
          onPressed: () {
            // รวบรวมข้อมูลรายงาน
            String selectedReasons = reasons.entries
                .where((entry) => entry.value == true)
                .map((entry) => entry.key)
                .join(', ');

            String description = descriptionController.text;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'รายงาน ${widget.studentName}\nสาเหตุ: $selectedReasons\nคำอธิบาย: $description'),
              ),
            );
            Navigator.of(context).pop(); // ปิด popup
          },
          child: Text('รายงาน'),
        ),
      ],
    );
  }
}
