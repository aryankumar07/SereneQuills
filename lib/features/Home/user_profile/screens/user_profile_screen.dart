import 'package:blogapp/features/Home/user_profile/controller/user_profile_controller.dart';
import 'package:blogapp/features/auth/controller/auth_controller.dart';
import 'package:blogapp/static_file/common/error_text.dart';
import 'package:blogapp/static_file/common/loader.dart';
import 'package:blogapp/static_file/common/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget{
  final String uid;
  UserProfileScreen({super.key,required this.uid});



  @override
  Widget build(BuildContext context, WidgetRef ref) {

    void navigateToEditProfile(){
    Routemaster.of(context).push('/edit_profile/$uid');
  }
    // TODO: implement build
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
        data: (user) => NestedScrollView(
          headerSliverBuilder: (context,innerBoxisScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 250,
                floating: true,
                snap: true,
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(child: 
                    Image.network(user.banner,fit: BoxFit.cover,)),
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.all(20).copyWith(bottom: 70),
                      child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                          radius: 35,
                          ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.all(20),
                      child: OutlinedButton(
                              onPressed: (){
                                navigateToEditProfile();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 25),
                              ),
                             child: Text('Edit Profile')),
                    ) 
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverList(delegate: SliverChildListDelegate(
                  [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'u/${user.name}',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text('${user.karma} Karma'),
                    ),
                    SizedBox(height: 10,),
                    Divider(thickness: 2,),
                  ]
                )),
                )
            ];
          }, 
          body: ref.watch(getUserPostProvider(uid)).when(
            data: (data) {
              return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context,int index) {
                final post = data[index];
                return PostCard(post: post);
              });
            }, 
            error: (error, stackTrace) {
              print(error);
            return ErrorText(error: error.toString());
            },
            loading: () => Loader()),),
        error: ((error, stackTrace) => ErrorText(error: error.toString())), 
        loading: () => Loader()),
    );
  }
}