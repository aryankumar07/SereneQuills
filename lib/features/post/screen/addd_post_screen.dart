import 'package:blogapp/theme/colors_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget{
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context,String type){
    Routemaster.of(context).push('/add_post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme  = ref.watch(ThemeNotifierProvider); 
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => navigateToType(context, 'image'),
          child: SizedBox(
            height: 120,
            width: 120,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)
              ),
              color: currentTheme.backgroundColor,
              elevation: 16,
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 60,
                  ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => navigateToType(context, 'text'),
          child: SizedBox(
            height: 120,
            width: 120,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)
              ),
              color: currentTheme.backgroundColor,
              elevation: 16,
              child: Center(
                child: Icon(
                  Icons.font_download_outlined,
                  size: 60,
                  ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => navigateToType(context, 'link'),
          child: SizedBox(
            height: 120,
            width: 120,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)
              ),
              color: currentTheme.backgroundColor,
              elevation: 16,
              child: Center(
                child: Icon(
                  Icons.link_outlined,
                  size: 60,
                  ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}