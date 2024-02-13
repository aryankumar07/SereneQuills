import 'package:blogapp/features/auth/controller/auth_controller.dart';
import 'package:blogapp/features/communuty/controller/communty_controller.dart';
import 'package:blogapp/model/comunity_model.dart';
import 'package:blogapp/static_file/common/error_text.dart';
import 'package:blogapp/static_file/common/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget{
  final String name;
  CommunityScreen({super.key,required this.name});

  void navigateToModScreen(BuildContext context){
    Routemaster.of(context).push('/mod_tools/$name');
  }

  void joinCommunity(WidgetRef ref,Community community,BuildContext context){
    ref.watch(CommunityControllerProvider.notifier)
    .joinCommunity(community, context);
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build

    final user=ref.watch(userProvider)!;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
        data: (community) => NestedScrollView(
          headerSliverBuilder: (context,innerBoxisScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 150,
                floating: true,
                snap: true,
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(child: 
                    Image.network(community.banner,fit: BoxFit.cover,)),
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverList(delegate: SliverChildListDelegate(
                  [
                    Align(
                      alignment: Alignment.topLeft,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(community.avatar),
                        radius: 35,
                        ),
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'b/${community.name}',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          community.mods.contains(user.uid) ? 
                          OutlinedButton(
                            onPressed: (){
                              navigateToModScreen(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 25),
                            ),
                           child: Text('Mod tools'))
                          :
                          OutlinedButton(
                            onPressed: (){
                              joinCommunity(ref, community, context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 25),
                            ),
                           child: Text(
                            community.member.contains(user.uid)?
                            'Joined':'Join')),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text('${community.member.length} Members'),
                    )
                  ]
                )),
                )
            ];
          }, 
          body: Text("data")), 
        error: ((error, stackTrace) => ErrorText(error: error.toString())), 
        loading: () => Loader()),
    );
  }
}