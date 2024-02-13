import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blogapp/features/auth/controller/auth_controller.dart';
import 'package:blogapp/static_file/constants/constants.dart';

class SignInButton extends ConsumerWidget{

  void SigninWithgoogle(BuildContext context,WidgetRef ref){
    ref.read(AuthControllerProvider.notifier).SignInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    // TODO: implement build
    return Row(
            children: [
              SizedBox(width:MediaQuery.of(context).size.width*.28),
              const CircleAvatar(
                backgroundImage: AssetImage(Constants.googleLogoPath),
              ),
              TextButton(
                onPressed: () => SigninWithgoogle(context,ref),
                 child: const Text(
                  'Continue With Google',
                 style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                  ),)),
            ],
          );
  }
}