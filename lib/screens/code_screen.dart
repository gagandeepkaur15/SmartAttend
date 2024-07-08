import 'package:flutter/material.dart';
import 'package:nami_task/widgets/app_bar.dart';
import 'package:nami_task/widgets/back_button.dart';
import 'package:nami_task/widgets/custom_text_field.dart';
import 'package:nami_task/widgets/primary_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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

  @override
  void dispose() {
    _controller.dispose();
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
          child: ListView(
            children: [
              SizedBox(height: 20.h),
              Text(
                "Please enter code given by Professor",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              CustomTextField(
                  hintText: "Enter Code", controller: codeController),
              SizedBox(height: 2.h),
              GestureDetector(
                onTap: () {
                  if (codeController.text.isNotEmpty) {
                    _showAnimatedDialog(context);
                  }
                },
                child: const PrimaryButton(text: "Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  final VoidCallback onClose;
  const CustomAlertDialog({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20.sp),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 2.h),
                  Center(
                    child: Container(
                      height: 5.5.h,
                      width: 30.w,
                      decoration: const BoxDecoration(
                        color: Color(0xff129C07),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 25.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Your attendance was successfully marked",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: GestureDetector(
                      onTap: () {},
                      child: const PrimaryButton(text: "Done"),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5.sp,
              right: 5.sp,
              child: IconButton(
                color: const Color(0xff848484),
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
