import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 4.h),
              Hero(
                tag: 'containerHero',
                child: Container(
                  width: 30.w,
                  height: 13.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    borderRadius: BorderRadius.circular(20.sp),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.4),
                        blurRadius: 10.sp,
                        offset: Offset(-10.sp, 10.sp),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                      size: 40.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Hero(
                tag: 'textHero',
                child: Text(
                  "SmartAttend",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
              const Spacer(),
              Hero(
                tag: 'bottomTextHero',
                child: Text(
                  "Powered by Lucify",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                ),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
