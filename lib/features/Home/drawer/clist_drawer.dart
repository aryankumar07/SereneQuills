import 'package:blogapp/features/auth/controller/auth_controller.dart';
import 'package:blogapp/features/communuty/controller/communty_controller.dart';
import 'package:blogapp/model/comunity_model.dart';
import 'package:blogapp/static_file/common/error_text.dart';
import 'package:blogapp/static_file/common/loader.dart';
import 'package:blogapp/static_file/common/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget{

  void goToCreateCommunty(BuildContext context){
    Routemaster.of(context).push('/createCommunity');
  }

  void goToCommunty(BuildContext context,Community community){
    Routemaster.of(context).push('b/${community.name}');
  }



  CommunityListDrawer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            isGuest? SignInButton(
              isFromLogin: true,
            ):
            ListTile(
              title: Text('Create a Community'),
              leading: Icon(Icons.add),
              onTap: () => goToCreateCommunty(context),
            ),
            ref.watch(userCommunityProvider).when(
            data: (communities) => Expanded(
              child: ListView.builder(
                itemCount: communities.length,
                itemBuilder: (context,index) {
                  final community = communities[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(community.avatar),
                    ),
                    title: Text('b/${community.name}'),
                    onTap: (){
                      goToCommunty(context, community);
                    },
                  );
                }),
            ),
            error: ((error, stackTrace) => ErrorText(error: error.toString())), 
            loading: () => Loader())
          ],
        )),
    );
  }
}