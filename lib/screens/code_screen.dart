import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/material.dart';
import 'package:nami_task/models/message_model.dart';
import 'package:nami_task/widgets/app_bar.dart';
import 'package:nami_task/widgets/back_button.dart';
import 'package:nami_task/widgets/custom_alert_dialog.dart';
import 'package:nami_task/widgets/custom_text_field.dart';
import 'package:nami_task/widgets/primary_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class CodeScreen extends StatefulWidget {
  const CodeScreen({super.key});

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController codeController = TextEditingController();
  late Animation<Offset> _screenAnimation;
  late AnimationController _controller;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  late socket_io.Socket socket;
  // final StreamController<String> _streamController = StreamController<String>();
  final _streamController = StreamController<Message>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _screenAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward(); //Start the animation
  }

  void connectToSocket() {
    // Configure the socket connection
    socket = socket_io.io(dotenv.env['SOCKET_URL'], <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Connect to the server
    socket.connect();

    // Handle socket events
    socket.on('connect', (_) {
      debugPrint('Connected to the server');
    });

    // Receiving server message

    // socket.on('response-message', (data) {
    //   debugPrint('Message from server: $data');
    //   _streamController.add(data);
    // });

    socket.on('response-message', (data) {
      final serverdata = jsonDecode(data);
      debugPrint('Title: ${serverdata['title']}');
      debugPrint('Body: ${serverdata['body']}');
      final message = Message.fromJson(serverdata);
      _streamController.add(message);
    });

    socket.on('disconnect', (_) {
      debugPrint('Disconnected from the server');
    });

    // Emit a message to the server
    socket.emit('user-message', codeController.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    socket.dispose();
    _streamController.close();
    super.dispose();
  }

  void _showAnimatedDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.center,
          child: CustomAlertDialog(
            onClose: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 2),
            end: const Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leftWidget: MyBackButton(myContext: context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 2.h),
        child: SlideTransition(
          position: _screenAnimation,
          child: Form(
            key: _key,
            child: ListView(
              children: [
                SizedBox(height: 20.h),
                Text(
                  "Please enter code given by Professor",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 2.h),
                CustomTextField(
                  hintText: "Enter Code",
                  controller: codeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: () {
                    if (_key.currentState!.validate()) {
                      _showAnimatedDialog(context);
                      connectToSocket();
                    }
                  },
                  child: const PrimaryButton(text: "Submit"),
                ),
                SizedBox(height: 4.h),

                // Stream Builder to show message from server
                StreamBuilder<Message>(
                  stream: _streamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SizedBox.shrink(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        'Error: ${snapshot.error}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ));
                    } else if (!snapshot.hasData) {
                      return Center(
                          child: Text(
                        'No messages received yet.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ));
                    } else {
                      final message = snapshot.data!;
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Title: ${message.title}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Body: ${message.body}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
