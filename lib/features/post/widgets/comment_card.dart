import 'package:blogapp/model/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentCard extends ConsumerWidget{
  final CommentM comment;

  CommentCard({
    super.key,
    required this.comment,
  });




  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 4,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(comment.profilepic),
                radius: 18,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('u${comment.username}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                    Text(comment.text),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.reply)),
              Text('Reply')
            ],
          ),

        ],
      ),
    );
  }
}