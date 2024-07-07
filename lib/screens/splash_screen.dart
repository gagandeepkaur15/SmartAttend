import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nami_task/screens/login_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _isContainerExpanded = true;
  bool _isIconExpanded = false;
  late AnimationController _controller;
  late AnimationController _textController;
  late AnimationController _bottomTextController;
  late Animation<double> _containerWidthAnimation;
  late Animation<double> _containerHeightAnimation;
  late Animation<double> _iconSizeAnimation;
  late Animation<Offset> _textAnimation;
  late Animation<double> _bottomTextOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // AnimationController Initialization
    _controller = AnimationController(
      vsync: this, // Required for animation to work properly
      duration: const Duration(milliseconds: 500),
    );

    // Text Controller Initialization
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _bottomTextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Listener to trigger icon expansion when container animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isIconExpanded = true;
        });
        _textController.forward();
        _bottomTextController.forward();
        _startTransition();
      }
    });

    // Initial Delay
    Timer(const Duration(milliseconds: 3), () {
      setState(() {
        _isContainerExpanded = false; // Start container animation
        _controller
            .forward(); // Start icon animation after container animation completes
      });
    });

    // Tween for container width animation
    _containerWidthAnimation = Tween<double>(
      begin: 70.w,
      end: 30.w,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Tween for container height animation
    _containerHeightAnimation = Tween<double>(
      begin: 70.h,
      end: 13.h,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Tween for icon size animation
    _iconSizeAnimation = Tween<double>(
      begin: 10.sp,
      end: 40.sp,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Tween for text animation
    _textAnimation = Tween<Offset>(
      begin: const Offset(2.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));

    // Tween for bottom text opacity animation
    _bottomTextOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bottomTextController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _startTransition() {
    // Wait for a brief period after animations complete, then navigate to next screen
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).push(_createRoute());
    });
  }

  // Custom Routing to get fade in effect
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 1000),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Container Hero
                return Hero(
                  tag: 'containerHero',
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    width: _containerWidthAnimation.value,
                    height: _containerHeightAnimation.value,
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      borderRadius: BorderRadius.circular(20.sp),
                    ),
                    child: _isContainerExpanded
                        ? null
                        : Center(
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Icon(
                                  Icons.person,
                                  color: Theme.of(context).primaryColor,
                                  size: _iconSizeAnimation.value,
                                );
                              },
                            ),
                          ),
                  ),
                );
              },
            ),
            SizedBox(height: 3.h),
            SlideTransition(
              position: _textAnimation,
              // Text Hero
              child: Hero(
                tag: 'textHero',
                child: Text(
                  "SmartAttend",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
            const Spacer(),
            FadeTransition(
              opacity: _bottomTextOpacityAnimation,
              // Bottom Text Hero
              child: Hero(
                tag: 'bottomTextHero',
                child: Text(
                  "Powered by Lucify",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
