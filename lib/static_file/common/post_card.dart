import 'package:any_link_preview/any_link_preview.dart';
import 'package:blogapp/features/auth/controller/auth_controller.dart';
import 'package:blogapp/features/post/controller/post_controller.dart';
import 'package:blogapp/model/post_model.dart';
import 'package:blogapp/static_file/constants/constants.dart';
import 'package:blogapp/theme/colors_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCard extends ConsumerWidget{
  final Post post;
  PostCard({
    super.key,
    required this.post,
  });

  void deletePost(WidgetRef ref,BuildContext context){
    ref.read(postControllerProvider.notifier).deletePost(context, post);
  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final isImageType = post.type == 'image';
    final isTextType = post.type == 'text';
    final isLinkType = post .type == 'link';

    final currentTheme  = ref.read(ThemeNotifierProvider);
    final user = ref.read(userProvider)!; 

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets
                      .symmetric(vertical: 4,horizontal: 16)
                      .copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(post.communityProfilePic),
                                    radius: 16,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'r/${post.communityName}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'u/${post.Username}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ), 
                                ],
                              ),
                              if(post.uid == user.uid)...[
                                    IconButton(
                                      onPressed: () => deletePost(ref, context), 
                                      icon: Icon(
                                        Icons.delete,
                                        color: ColorCodes.redColor,
                                        ))
                                  ],
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if(isImageType)...[
                            SizedBox(
                              height: MediaQuery.of(context).size.height*.35,
                              width: double.infinity,
                              child: Image.network(post.link!,fit: BoxFit.cover,),
                            )
                          ],
                          if(isLinkType)...[
                            SizedBox(
                              height: MediaQuery.of(context).size.height*.35,
                              width: double.infinity,
                              child: AnyLinkPreview(
                                displayDirection: UIDirection.uiDirectionHorizontal,
                                link: post.link!),
                            )
                          ],
                          if(isTextType)...[
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                post.description!,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          ],
                          Row(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: (){}, 
                                    icon: Icon(
                                      Constants.up,
                                      size: 30,
                                    color: post.upvotes.contains(user.uid)? Colors.red : null,
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        '${post.upvotes.length-post.downvotes.length==0?
                                         "Vote" : post.upvotes.length-post.downvotes.length}'),
                                    ),
                                    IconButton(
                                    onPressed: (){}, 
                                    icon: Icon(
                                      Constants.down,
                                      size: 30,
                                    color: post.downvotes.contains(user.uid)? Colors.blue : null,
                                    )),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: (){}, 
                                    icon: Icon(
                                      Icons.comment,
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        '${post.commentCount==0?
                                         "comment" : post.commentCount}'),
                                    ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}