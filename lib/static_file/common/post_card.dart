import 'package:any_link_preview/any_link_preview.dart';
import 'package:blogapp/features/auth/controller/auth_controller.dart';
import 'package:blogapp/model/post_model.dart';
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


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final isImageType = post.type == 'image';
    final isTextType = post.type == 'text';
    final isLinkType = post .type == 'link';

    final user = ref.watch(userProvider)!;

    final currentTheme = ref.watch(ThemeNotifierProvider);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Column(
                children: [
                  Expanded(child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 16
                        ).copyWith(right: 0 ),
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
                                          Text('b/${post.CommunityName}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          ),
                                          Text('b/${post.Username}',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if(post.uid==user.uid)...[
                                      IconButton(
                                      onPressed: (){}, 
                                      icon: Icon(
                                        Icons.delete,
                                        color: ColorCodes.redColor,
                                      )
                                    )
                                  ],
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(post.title,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold
                              ),),
                            ),
                            if(isImageType)...[
                              SizedBox(
                                height: MediaQuery.of(context).size.height*0.35,
                                width: double.infinity,
                                child: Image.network(
                                  post.link!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                            if(isLinkType)...[
                              SizedBox(
                                height: MediaQuery.of(context).size.height*0.35,
                                width: double.infinity,
                                child: AnyLinkPreview(
                                  displayDirection: UIDirection.uiDirectionHorizontal,
                                  link: post.link! ) 
                              )
                            ],
                            if(isTextType)...[
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: Padding( 
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    post.description!,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ],
                        ),
                      )
                    ],
                  ))
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}