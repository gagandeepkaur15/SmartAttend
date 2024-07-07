import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyBackButton extends StatelessWidget {
  final BuildContext myContext;
  const MyBackButton({super.key, required this.myContext});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        myContext.pop();
      },
      child: Container(
        height: 4.5.h,
        width: 10.w,
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        decoration: BoxDecoration(
          color: Theme.of(context).disabledColor,
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios,
            color: const Color(0xff7B7B7B),
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}
