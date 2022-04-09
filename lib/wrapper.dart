import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_with_username_email/pages/home_page.dart';
import 'package:login_with_username_email/pages/login_page.dart';
import 'package:login_with_username_email/services/auth_controller.dart';
import 'package:login_with_username_email/shared/loading.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthController().authChanges(),
      builder: (context, snapshot) {
        final provider = Provider.of<AuthController>(context, listen: false);

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginPage();
          }
        }
      },
    );
  }

  Widget BuildLoading() => Center(
        child: CircularProgressIndicator(),
      );
}
