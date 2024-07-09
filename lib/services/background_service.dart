import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nami_task/models/message_model.dart';
import 'package:nami_task/services/local_notification_initialization.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: true,
      autoStartOnBoot: true,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      service.setForegroundNotificationInfo(
          title: "Foreground Notification",
          content: "This is foreground notification");
    }

    debugPrint("Background Service is running");

    await dotenv.load();

    final socket = io.io(dotenv.env['SOCKET_URL'], <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.connect();

    socket.onConnect((_) {
      debugPrint('Connected. Socket ID: ${socket.id}');
    });

    socket.on('response-message', (data) {
      final serverData = jsonDecode(data);
      final message = Message.fromJson(serverData);
      LocalNotifications.showNotification(
          title: message.title,
          body: message.body,
          payload: "Notification from socket");
    });

    socket.onDisconnect((_) {
      debugPrint('Disconnected from socket.');
    });

    service.on('stop').listen((event) {
      socket.disconnect();
      service.stopSelf();
      debugPrint('Background process is now stopped');
    });

    service.invoke('update');
  }
}
