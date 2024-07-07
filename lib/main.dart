import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nami_task/screens/login_screen.dart';
import 'package:nami_task/screens/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp.router(
        title: 'Attendance App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffE43E3A)),
          useMaterial3: true,
          primaryColor: const Color(0xffE43E3A),
          highlightColor: Colors.white,
          disabledColor: const Color(0xffDADADA),
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(
            headlineLarge: TextStyle(
              color: Colors.white,
              fontSize: 23.sp,
              fontWeight: FontWeight.w600,
            ),
            bodyMedium: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700),
            bodySmall: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400),
            labelSmall: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        routerConfig: _router,
      );
    });
  }
}

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      name: 'Splash',
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: 'Login',
      path: '/login',
      builder: (context, state) =>const LoginScreen(),
    ),
  ],
);
