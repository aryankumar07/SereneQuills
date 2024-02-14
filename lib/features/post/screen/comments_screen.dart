import 'package:blogapp/features/post/controller/post_controller.dart';
import 'package:blogapp/features/post/widgets/comment_card.dart';
import 'package:blogapp/model/post_model.dart';
import 'package:blogapp/static_file/common/error_text.dart';
import 'package:blogapp/static_file/common/loader.dart';
import 'package:blogapp/static_file/common/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentScreen extends ConsumerStatefulWidget{
  final String postId;

  CommentScreen({super.key,required this.postId});


  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _CommentScreenState();
  }
}

class _CommentScreenState extends ConsumerState<CommentScreen>{

  final commentController = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post){
    ref.read(postControllerProvider.notifier).addComment(
      context: context, 
      text: commentController.text.trim(), 
      post: post);
      setState(() {
        commentController.clear();
      });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostIdProvider(widget.postId))
      .when(
        data: (data) {
          return Column(
            children: [
              PostCard(post: data),
              SizedBox(height: 10,),
              TextField(
                onSubmitted: (val) => addComment(data),
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'what are your thoughts?',
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
              ref.watch(getPostCommentsProvider(widget.postId))
              .when(data: (data){
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context,int index){
                      final comment = data[index];
                      return CommentCard(comment: comment);
                    }),
                );
              }, 
              error: (error, stackTrace) {
                print(error);
              return ErrorText(error: error.toString()); 
              },
              loading: () => Loader()),
            ],
          );
        }, 
      error: (error, stackTrace) => ErrorText(error: error.toString()), 
      loading: () => Loader()),
    );
  }
}