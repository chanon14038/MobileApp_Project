import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<String> notifications = [
    'การแจ้งเตือนที่ 1: คุณมีงานที่ยังไม่เสร็จ',
    'การแจ้งเตือนที่ 2: การนัดหมายใหม่ถูกสร้างขึ้น',
    'การแจ้งเตือนที่ 3: การบ้านต้องส่งภายในวันนี้',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.notifications),
              title: Text(notifications[index]),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // การกระทำเมื่อคลิกที่การแจ้งเตือน
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('คุณเลือก: ${notifications[index]}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationPage(),
  ));
}
