import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nami_task/models/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

final socketProvider =
    FutureProvider.autoDispose<socket_io.Socket>((ref) async {
  final socket = socket_io.io(dotenv.env['SOCKET_URL'], <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  socket.connect();
  ref.onDispose(() {
    socket.dispose();
  });
  return socket;
});

final messageStreamProvider = StreamProvider.autoDispose<Message>((ref) async* {
  final socket = await ref.watch(socketProvider.future);

  final streamController = StreamController<Message>();

  socket.on('response-message', (data) {
    final serverData = jsonDecode(data);
    final message = Message.fromJson(serverData);
    streamController.add(message);

    // Foreground Notification

    // LocalNotifications.showNotification(
    //     title: message.title,
    //     body: message.body,
    //     payload: "Notification from socket");
  });

  ref.onDispose(() {
    streamController.close();
  });

  yield* streamController.stream;
});
