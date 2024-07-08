import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nami_task/widgets/app_bar.dart';
import 'package:nami_task/widgets/back_button.dart';
import 'package:nami_task/widgets/primary_button.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  late List<CameraDescription> cameras;
  late Future<CameraController>? _initializeControllerFuture;

  late Animation<Offset> _screenAnimation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = initializeCamera();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _screenAnimation = Tween<Offset>(
      begin: const Offset(2.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward(); //Start the animation
  }

  Future<CameraController> initializeCamera() async {
    cameras = await availableCameras();

    // Finding the front camera
    CameraDescription? frontCamera;
    for (CameraDescription camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.front) {
        frontCamera = camera;
        break;
      }
    }

    if (frontCamera == null) {
      throw CameraException(
        'No front camera found',
        'Ensure your device has a front camera or try using a different device.',
      );
    }

    final CameraController cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await cameraController.initialize();
    return cameraController;
  }

  @override
  void dispose() {
    _initializeControllerFuture?.then((cameraController) {
      cameraController.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          leftWidget: MyBackButton(
        myContext: context,
      )),
      body: SlideTransition(
        position: _screenAnimation,
        child: FutureBuilder<CameraController>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              } else if (snapshot.hasData) {
                return CameraWidget(snapshot: snapshot);
              } else {
                return Center(
                  child: Text(
                    'Failed to initialize camera',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class CameraWidget extends StatefulWidget {
  final AsyncSnapshot snapshot;
  const CameraWidget({
    super.key,
    required this.snapshot,
  });

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  double percent = 0.0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const duration = Duration(milliseconds: 50);
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        percent += 0.01;
        if (percent >= 1.0) {
          percent = 1.0;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 2.h),
      child: Column(
        children: [
          Container(
            width: 100.w,
            height: 55.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.sp),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).disabledColor,
                  blurRadius: 10.sp,
                  offset: Offset(-10.sp, 10.sp),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.sp),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CameraPreview(
                      widget.snapshot.data!,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 5.h,
                      width: 100.w,
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      color: Colors.black.withOpacity(0.2),
                      child: Align(
                        child: LinearPercentIndicator(
                          width: 75.w,
                          animation: true,
                          lineHeight: 1.5.h,
                          animationDuration: 5000,
                          percent: 1,
                          barRadius: Radius.circular(40.sp),
                          progressColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Text("Timer ${(5 - (5 * percent)).toStringAsFixed(1)} seconds left",
              style: Theme.of(context).textTheme.bodyMedium),
          Text(
            "Keep your App in Foreground",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w400,
                ),
          ),
          SizedBox(height: 5.h),
          GestureDetector(
            onTap: () {
              if (percent >= 1.0) {
                context.push("/code");
              }
            },
            child: const PrimaryButton(text: "Capture"),
          ),
          const Spacer(),
          Center(
            // bottom text hero
            child: Hero(
              tag: 'bottomTextHero',
              child: Text("Powered by Lucify",
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
