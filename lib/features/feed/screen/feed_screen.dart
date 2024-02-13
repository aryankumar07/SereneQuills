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
        // print('communities data is $communities');
        return ref.watch(userPostProvider(communities))
        .when(
          data: (data){
            print('length of data is ${data.length}');
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
        loading: ()=>Loader());
      }, 
      error: (error, stackTrace) => ErrorText(error: error.toString()), 
      loading: ()=>Loader());
  }
}