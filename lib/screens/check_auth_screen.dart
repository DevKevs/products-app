import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';
import 'package:products_app/screens/screens.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readStorage(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            if (snapshot.data == '') {
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const LoginScreen(),
                      transitionDuration: const Duration(seconds: 0)),
                );
              });
            } else {
              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const HomeScreen(),
                      transitionDuration: const Duration(seconds: 0)),
                );
              });
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
