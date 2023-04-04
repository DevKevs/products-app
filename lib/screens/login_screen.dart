import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:products_app/screens/screens.dart';
import 'package:products_app/providers/providers.dart';
import 'package:products_app/widgets/widgets.dart';

import '../UI/input_decoration.dart';
import '../services/services.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = 'login';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: LoginBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.30),
            CardContainer(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm())
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(
                  context, RegisterScreen.routeName),
              child: const Text(
                'Create a new account',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    ));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return SizedBox(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.loginDecoration(
                placeholder: 'email@semail.com',
                label: 'Email',
                icon: Icons.alternate_email_outlined,
              ),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '') ? null : 'Invalid email';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecorations.loginDecoration(
                placeholder: 'User password',
                label: '*********',
                icon: Icons.lock,
              ),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'Password must have 6 characters';
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      if (!loginForm.isValidForm()) return;

                      loginForm.isLoading = true;

                      final String? errorMsg = await authService.signIn(
                          loginForm.email, loginForm.password);
                      if (errorMsg == null) {
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(
                            context, HomeScreen.routeName);
                      } else {
                        // ignore: use_build_context_synchronously
                        // showAlert(context, errorMsg);
                        NotificationService.showSnackBar(errorMsg);
                        loginForm.isLoading = false;
                      }
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading ? 'Wait...' : 'Log in',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
