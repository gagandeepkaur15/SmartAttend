import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WhiteButton extends StatelessWidget {
  final String text;
  const WhiteButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 7.h,
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.sp),
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}
