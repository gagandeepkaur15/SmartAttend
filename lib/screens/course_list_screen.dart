import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nami_task/widgets/app_bar.dart';
import 'package:nami_task/widgets/primary_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen>
    with TickerProviderStateMixin {
  List<String> courses = [
    "MTL 100",
    "PYL 100",
    "CCML 100",
    "APL 105",
    "NEN 100"
  ];

  int indexSelected = -1;
  bool showText = false;

  late AnimationController _controller;
  late Animation<Offset> _listAnimation;
  late Animation<Offset> _buttonAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Tween for list animation
    _listAnimation = Tween<Offset>(
      begin: const Offset(2.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    ));

    // Tween for button animation
    _buttonAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    ));

    // Tween for opacity animation
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward(); //Start the animation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        leftWidget: FadeTransition(
          opacity: _opacityAnimation,
          child: Text(
            "SmartAttend",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            FadeTransition(
              opacity: _opacityAnimation,
              child: Text(
                "Courses List",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: SlideTransition(
                  position: _listAnimation,
                  child: ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            if (index != indexSelected) {
                              setState(() {
                                indexSelected = index;
                              });
                            }
                          },
                          child: Container(
                            height: 5.h,
                            width: 100.w,
                            padding: EdgeInsets.only(left: 15.sp),
                            margin: EdgeInsets.only(bottom: 1.5.h),
                            decoration: BoxDecoration(
                              color: index == indexSelected
                                  ? Theme.of(context).indicatorColor
                                  : Theme.of(context).scaffoldBackgroundColor,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    courses[index],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  SizedBox(width: 1.w),
                                  index == indexSelected
                                      ? Container(
                                          height: 2.h,
                                          width: 10.w,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xff129C07),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.check,
                                              color: Theme.of(context)
                                                  .indicatorColor,
                                              size: 15.sp,
                                            ),
                                          ))
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
            // Bottom Text Hero
            FadeTransition(
              opacity: _opacityAnimation,
              child: SlideTransition(
                position: _buttonAnimation,
                child: GestureDetector(
                  onTap: () {
                    if (indexSelected != -1) {
                      context.go("/attendance");
                    } else {
                      setState(() {
                        showText = true;
                      });
                    }
                  },
                  child: const Hero(
                    tag: "button",
                    child: PrimaryButton(text: "Mark Attendance"),
                  ),
                ),
              ),
            ),
            showText == true
                ? Text(
                    "Please select a course",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xffE43E3A),
                    ),
                  )
                : const SizedBox.shrink(),
            SizedBox(height: 4.h),
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
    );
  }
}
