import 'package:blogapp/features/auth/controller/auth_controller.dart';
import 'package:blogapp/model/usermodel.dart';
import 'package:blogapp/routes.dart';
import 'package:blogapp/static_file/common/error_text.dart';
import 'package:blogapp/static_file/common/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blogapp/features/auth/screen/login_screen.dart';
import 'package:blogapp/theme/colors_scheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(   ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget{
  MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _MyappState();
  }
}

class _MyappState extends ConsumerState<MyApp>{
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref.watch(AuthControllerProvider.notifier).getUserData(data.uid.toString()).first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(data: (data) => MaterialApp.router(
      debugShowCheckedModeBanner: true,
      title: "serene",
      theme: ref.watch(ThemeNotifierProvider),
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) {
          if(data!=null){
            getData(ref, data);
            if(userModel!=null){
              return loggedInRoute;
            }
          }
          return loggedOutRoute;
        }
      ),
        routeInformationParser: RoutemasterParser(),
    )
    , error: ((error, stackTrace) => ErrorText(error: error.toString())),
     loading: () =>  Loader());
    
  }
}