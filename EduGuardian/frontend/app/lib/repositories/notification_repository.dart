import 'package:flutter/material.dart';
import '../services/websocket_client.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late WebSocketClient _webSocketClient;
  List<dynamic> _notifications = [];

  @override
  void initState() {
    super.initState();
    _webSocketClient = WebSocketClient(endpoint: "ws");

    // Listen to the notification stream and update UI on new notifications
    _webSocketClient.notifyStream.listen((notification) {
      setState(() {
        _notifications.add(notification);
      });
    });
  }

  @override
  void dispose() {
    _webSocketClient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<dynamic>(
        stream: _webSocketClient.notifyStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Update notifications list
            _notifications.add(snapshot.data);
          }

          return ListView.builder(
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_notifications[index].toString()),
              );
            },
          );
        },
      ),
    );
  }
}
