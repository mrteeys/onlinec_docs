import 'dart:js';

import 'package:docs_clone/repository/auth_repository.dart';
import 'package:docs_clone/screens/home_screen.dart';
import 'package:flutter/material.dart';
// import 'package:docs_clone/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessager = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final errorModel =
        await ref.read(authRepositoryProvider).signInWithGoogle();

    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.replace('/');
    } else {
      sMessager.showSnackBar(SnackBar(
        content: Text(errorModel.error!),
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Center(
            child: ElevatedButton.icon(
                onPressed: () => signInWithGoogle(ref, context),
                icon: Image.asset('assets/images/g-logo-2.png', height: 20),
                label: const Text(
                  'Sign in with Google',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(150, 50),
                ))));
  }
}
