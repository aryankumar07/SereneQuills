import 'package:blogapp/features/auth/controller/auth_controller.dart';
import 'package:blogapp/theme/colors_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget{

  void logout(WidgetRef ref) async {
    ref.read (AuthControllerProvider.notifier).logout();
  }

  void navigateToUserProfile(BuildContext context,String uid){
    Routemaster.of(context).push('/u/$uid');
  }

  void toggleTheme(WidgetRef ref){
    ref.read(ThemeNotifierProvider.notifier).toggleTheme();
  }

  ProfileDrawer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    // TODO: implement build
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 70,
            ),
            SizedBox(height: 10,),
            Text('b/${user.name}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
            ),
            SizedBox(height: 10,),
            Divider(),
            ListTile(
              title: Text('My Profile'),
              leading: Icon(Icons.person_2_outlined),
              onTap: () {
                navigateToUserProfile(context, user.uid);
              } ,
            ),
            ListTile(
              title: Text('LogOut'),
              leading: Icon(Icons.logout,color: ColorCodes.redColor,),
              onTap: () => logout(ref),
            ),
            Switch.adaptive(
              value: ref.watch(ThemeNotifierProvider.notifier).mode == ThemeMode.dark,
             onChanged: (val){
              toggleTheme(ref);
             })
          ],
        )),
    );
  }
}