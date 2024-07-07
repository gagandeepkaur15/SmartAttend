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
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffe43e3a)),
          useMaterial3: true,
          primaryColor: const Color(0xffe43e3a),
          highlightColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(
            headlineLarge: TextStyle(
              color: Colors.white,
              fontSize: 21.sp,
              fontWeight: FontWeight.w500,
            ),
            bodySmall: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
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
      builder: (context, state) => LoginScreen(),
    ),
  ],
);
