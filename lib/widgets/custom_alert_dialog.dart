import 'package:flutter/material.dart';
import 'package:nami_task/widgets/primary_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
