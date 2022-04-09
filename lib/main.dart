import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_with_username_email/model/userModel.dart';
import 'package:login_with_username_email/model/user_provider.dart';
import 'package:login_with_username_email/wrapper.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:login_with_username_email/services/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(
          create: (context) => AuthController(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
            duration: 2000,
            splash: Text('Splash Screen'),
            nextScreen: Wrapper(),
            splashTransition: SplashTransition.fadeTransition,
            // pageTransitionType: PageTransitionType.scale,
            backgroundColor: Colors.white),
      ),
    );
  }
}
