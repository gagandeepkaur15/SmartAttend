import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nami_task/widgets/custom_text_field.dart';
import 'package:nami_task/widgets/primary_button.dart';
import 'package:nami_task/widgets/white_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController idCont = TextEditingController();

  final TextEditingController passCont = TextEditingController();

  late AnimationController _controller;
  late Animation<Offset> _columnAnimation;

  @override
  void initState() {
    super.initState();

    // AnimationController Initialization
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Tween for text animation
    _columnAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: Center(
            child: ListView(
              children: [
                AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _columnAnimation,
                        child: Column(
                          children: [
                            SizedBox(height: 6.h),

                            // Container Hero
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
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.4),
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
                            SizedBox(height: 3.h),

                            // Text Hero
                            Hero(
                              tag: 'textHero',
                              child: Text(
                                "SmartAttend",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                            ),
                            SizedBox(height: 10.h),

                            // Login Fields
                            CustomTextField(
                                hintText: "Your ID", controller: idCont),
                            CustomTextField(
                                hintText: "Password", controller: passCont),
                            GestureDetector(
                              onTap: () {
                                context.go('/courseList');
                              },
                              child: const PrimaryButton(
                                text: "Log in",
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              child: Text("Forgot Password",
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ),
                            SizedBox(height: 2.h),
                            const WhiteButton(text: "Create new account"),
                          ],
                        ),
                      );
                    }),
                SizedBox(height: 12.h),

                // Bottom Text Hero
                Center(
                  child: Hero(
                    tag: 'bottomTextHero',
                    child: Text("Powered by Lucify",
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
