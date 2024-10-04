import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/notification_bloc.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // เรียกใช้ FetchNotifications เพื่อโหลดการแจ้งเตือนเมื่อเริ่มหน้า
    context.read<NotificationBloc>().add(FetchNotifications());

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return ListTile(
                  title: Text('${notification.description}'), // หรือใช้ข้อมูลอื่นจาก model
                  subtitle: Text('ID: ${notification.studentId}'),
                );
              },
            );
          } else if (state is NotificationError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('No notifications available.'));
        },
      ),
    );
  }
}
