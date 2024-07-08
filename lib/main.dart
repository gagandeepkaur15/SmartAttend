import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nami_task/screens/attendance_screen.dart';
import 'package:nami_task/screens/camera_screen.dart';
import 'package:nami_task/screens/code_screen.dart';
import 'package:nami_task/screens/course_list_screen.dart';
import 'package:nami_task/screens/login_screen.dart';
import 'package:nami_task/screens/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
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
          scaffoldBackgroundColor: Colors.white,
          primaryColor: const Color(0xffE43E3A),
          highlightColor: Colors.white,
          disabledColor: const Color(0xffDADADA),
          indicatorColor: const Color(0xffCDFFCC),
          textTheme: TextTheme(
            headlineLarge: TextStyle(
              color: Colors.white,
              fontSize: 23.sp,
              fontWeight: FontWeight.w600,
            ),
            headlineMedium: TextStyle(
              color: Colors.black,
              fontSize: 19.sp,
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
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 1000),
        );
      },
    ),
    GoRoute(
      name: 'CourseList',
      path: '/courseList',
      builder: (context, state) => const CourseListScreen(),
    ),
    GoRoute(
      name: 'Attendance',
      path: '/attendance/:course',
      pageBuilder: (context, state) {
        final course = state.pathParameters["course"]!;
        return CustomTransitionPage(
          key: state.pageKey,
          child: AttendanceScreen(course: course),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 1000),
        );
      },
    ),
    GoRoute(
      name: 'Camera',
      path: '/camera',
      builder: (context, state) => const CameraScreen(),
    ),
    GoRoute(
      name: 'Code',
      path: '/code',
      builder: (context, state) => const CodeScreen(),
    ),
  ],
);
