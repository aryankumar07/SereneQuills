import 'package:any_link_preview/any_link_preview.dart';
import 'package:blogapp/features/auth/controller/auth_controller.dart';
import 'package:blogapp/features/communuty/controller/communty_controller.dart';
import 'package:blogapp/features/post/controller/post_controller.dart';
import 'package:blogapp/model/post_model.dart';
import 'package:blogapp/static_file/common/error_text.dart';
import 'package:blogapp/static_file/common/loader.dart';
import 'package:blogapp/static_file/constants/constants.dart';
import 'package:blogapp/theme/colors_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget{
  final Post post;
  PostCard({
    super.key,
    required this.post,
  });

  void deletePost(WidgetRef ref,BuildContext context){
    ref.read(postControllerProvider.notifier).deletePost(context, post);
  }

  void upVote(WidgetRef ref,BuildContext context){
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downVote(WidgetRef ref,BuildContext context){
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void navigateToUser(BuildContext context){
    Routemaster.of(context).push('/u/${post.uid}');
  }


  void navigateToCommunity(BuildContext context){
    Routemaster.of(context).push('/b/${post.communityName}');
  }

  void navigateToComments(BuildContext context){
    Routemaster.of(context).push('/post/${post.id}/comments');
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
                                  GestureDetector(
                                    onTap: () => navigateToCommunity(context),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(post.communityProfilePic),
                                      radius: 16,
                                    ),
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
                                        GestureDetector(
                                          onTap: () => navigateToUser(context),
                                          child: Text(
                                            'u/${post.Username}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                  child: AnyLinkPreview(
                                    displayDirection: UIDirection.uiDirectionHorizontal,
                                    link: post.link!),
                                ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => upVote(ref, context), 
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
                                    onPressed: () => downVote(ref, context), 
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
                                    onPressed: () => navigateToComments(context), 
                                    icon: Icon(
                                      Icons.comment,
                                    )),
                                    GestureDetector(
                                      onTap: () => navigateToComments(context),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          '${post.commentCount==0?
                                           "comment" : post.commentCount}'),
                                      ),
                                    ),
                                ],
                              ),
                              ref.watch(getCommunityByNameProvider(post.communityName))
                              .when(data: (data){
                                if(data.mods.contains(user.uid)){
                                  return IconButton(
                                    onPressed: () => deletePost(ref, context), 
                                    icon: Icon(
                                      Icons.admin_panel_settings,
                                    ));
                                }
                                return SizedBox();
                              },
                               error: (error, stackTrace) => ErrorText(error: error.toString()), 
                               loading: ()=>Loader()),
                              
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
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