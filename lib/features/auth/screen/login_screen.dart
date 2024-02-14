import 'package:blogapp/features/auth/controller/auth_controller.dart';
import 'package:blogapp/static_file/common/loader.dart';
import 'package:flutter/material.dart';
import 'package:blogapp/static_file/common/sign_in_button.dart';
import 'package:blogapp/static_file/constants/constants.dart';
import 'package:blogapp/theme/colors_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class loginScreen extends ConsumerWidget{

  loginScreen({super.key});

  void signInAsaGuest(WidgetRef ref,BuildContext context){
    ref.read(AuthControllerProvider.notifier).SignInAsaGuest(context);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isLoading = ref.watch(AuthControllerProvider);
    return Scaffold(
      appBar: AppBar(
        // title: Icon(
        //   Icons.login,
        //   color: Colors.red,
        // ),
        title: Image.asset(
          Constants.logoPath,
          color: Colors.red,
          height: 30,
        ),
        actions: [
          TextButton(
            onPressed: () => signInAsaGuest(ref, context), 
            child: const Text('Skip'))
        ],
      ),
      body: isLoading? Loader() : Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*.05,),
          const Text(
            'Share Your Thoughts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(height: 40,),
          Padding(
            padding: EdgeInsets.only(left: 20,right: 20),
            child: Container(
              height: MediaQuery.of(context).size.height*.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorCodes.drawerColor,
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Image.asset(Constants.logoImagePath)),
            ),
          ),
          SizedBox(height: 40,),
          SignInButton(),
        ],
      ),
    );
  }
}