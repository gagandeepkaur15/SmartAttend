import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nami_task/providers/socket_provider.dart';
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
  // final _streamController = StreamController<Message>();

  String buttonText = "Stop Service";

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

  // void connectToSocket() {
  //   socket = socket_io.io(dotenv.env['SOCKET_URL'], <String, dynamic>{
  //     'transports': ['websocket'],
  //     'autoConnect': false,
  //   });

  //   socket.connect();

  //   socket.on('connect', (_) {
  //     debugPrint('Connected to the server');
  //   });

  //   // socket.on('response-message', (data) {
  //   //   debugPrint('Message from server: $data');
  //   //   _streamController.add(data);
  //   // });

  //   socket.on('response-message', (data) {
  //     final serverdata = jsonDecode(data);
  //     debugPrint('Title: ${serverdata['title']}');
  //     debugPrint('Body: ${serverdata['body']}');
  //     final message = Message.fromJson(serverdata);
  //     _streamController.add(message);
  //   });

  //   socket.on('disconnect', (_) {
  //     debugPrint('Disconnected from the server');
  //   });

  //   socket.emit('user-message', codeController.text);
  // }

  @override
  void dispose() {
    _controller.dispose();
    // socket.dispose();
    // _streamController.close();
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
                Consumer(
                  builder: (context, ref, child) {
                    return GestureDetector(
                      onTap: () {
                        if (_key.currentState!.validate()) {
                          _showAnimatedDialog(context);
                          final socketValue = ref.watch(socketProvider);
                          socketValue.when(
                            data: (socket) async {
                              socket.emit('user-message', codeController.text);
                              FlutterBackgroundService()
                                  .invoke('setAsBackground');
                            },
                            loading: () {
                              debugPrint('Socket is loading');
                            },
                            error: (error, stack) {
                              debugPrint('Error: $error');
                            },
                          );
                        }
                      },
                      child: const PrimaryButton(text: "Submit"),
                    );
                  },
                ),
                SizedBox(height: 4.h),

                // Stream Builder to show message from server
                // StreamBuilder<Message>(
                //   stream: _streamController.stream,
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(
                //         child: SizedBox.shrink(),
                //       );
                //     } else if (snapshot.hasError) {
                //       return Center(
                //           child: Text(
                //         'Error: ${snapshot.error}',
                //         style: Theme.of(context).textTheme.bodyMedium,
                //       ));
                //     } else if (!snapshot.hasData) {
                //       return Center(
                //           child: Text(
                //         'No messages received yet.',
                //         style: Theme.of(context).textTheme.bodyMedium,
                //       ));
                //     } else {
                //       final message = snapshot.data!;
                //       return Center(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Text(
                //               'Title: ${message.title}',
                //               style: Theme.of(context).textTheme.bodyMedium,
                //             ),
                //             SizedBox(height: 1.h),
                //             Text(
                //               'Body: ${message.body}',
                //               style: Theme.of(context).textTheme.bodySmall,
                //             ),
                //           ],
                //         ),
                //       );
                //     }
                //   },
                // ),

                // ElevatedButton(
                //   onPressed: () {
                //     FlutterBackgroundService().invoke('setAsForeground');
                //   },
                //   child: const Text("Foreground"),
                // ),

                // Stream Builder
                Consumer(
                  builder: (context, ref, child) {
                    final messageStream = ref.watch(messageStreamProvider);
                    return messageStream.when(
                      data: (message) {
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
                      },
                      loading: () => const Center(
                        child: SizedBox.shrink(),
                      ),
                      error: (error, stack) => Center(
                        child: Text(
                          'Error: $error',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    );
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
