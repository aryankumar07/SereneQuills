import 'package:blogapp/features/communuty/controller/communty_controller.dart';
import 'package:blogapp/features/post/controller/post_controller.dart';
import 'package:blogapp/static_file/common/error_text.dart';
import 'package:blogapp/static_file/common/loader.dart';
import 'package:blogapp/static_file/common/post_card.dart';
import 'package:blogapp/theme/colors_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerWidget{
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunityProvider).when(
      data: (communities){
        return ref.watch(userPostProvider(communities))
        .when(
          data: (posts){
             return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context,index) {
                final post = posts[index];
                // return PostCard(post: post);
                return Container(
                  child: Text('data'),
                );
              });
          }, 
        error: (error, stackTrace) => ErrorText(error: error.toString()), 
        loading: ()=>Loader());
      }, 
      error: (error, stackTrace) => ErrorText(error: error.toString()), 
      loading: ()=>Loader());
  }
}