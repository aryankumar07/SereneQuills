import 'dart:io';
import 'package:blogapp/features/communuty/controller/communty_controller.dart';
import 'package:blogapp/model/comunity_model.dart';
import 'package:blogapp/static_file/common/error_text.dart';
import 'package:blogapp/static_file/common/loader.dart';
import 'package:blogapp/static_file/constants/constants.dart';
import 'package:blogapp/static_file/constants/utils.dart';
import 'package:blogapp/theme/colors_scheme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditCommunityScreen extends ConsumerStatefulWidget{
  final String name;
  EditCommunityScreen({super.key,required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _EditCommunityScreenState();
  }
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen>{
  File? bannerFile;
  File? profileFile;

  void save(Community community,){
    ref.read(CommunityControllerProvider.notifier).editCommunity(
      community: community, 
      profileFile: profileFile, 
      bannerFile: bannerFile, 
      context: context);
  }


  void selectBannerImage() async {
    final res = await pickImage();

    if(res!=null){
      setState(() {
      bannerFile = File(res.files.first.path!); 
      });
    }
  }

    void selectProfileImage() async {
    final res = await pickImage();

    if(res!=null){
      setState(() {
      profileFile = File(res.files.first.path!); 
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final isLoading = ref.watch(CommunityControllerProvider);
    return ref.watch(getCommunityByNameProvider(widget.name))
    .when(
      data:(community) => Scaffold(
      backgroundColor: ColorCodes.darkModeAppTheme.backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        title: Text('Edit Community'),
        actions: [
          TextButton(
            onPressed: (){
              save(community);
            }, 
            child: Text('Save'))
        ],
      ),
      body: isLoading?
       Loader() :
       Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: selectBannerImage,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(16),
                      color: Colors.white,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: bannerFile !=null ?
                         Image.file(bannerFile!) :
                         community.banner.isEmpty || community.banner == Constants.bannerDefault?
                        Center(
                          child: Icon(Icons.camera_alt_outlined,size: 40,),
                        )
                        :
                        Image.network(community.banner)
                      )),
                  ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: GestureDetector(
                        onTap: selectProfileImage,
                        child: profileFile!=null?
                         CircleAvatar(
                          backgroundImage:  FileImage(profileFile!),
                          radius: 32,
                        )
                         :
                         CircleAvatar(
                          backgroundImage:  NetworkImage(community.avatar),
                          radius: 32,
                        ),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      )
    ),
    error: (error, stackTrace) => ErrorText(error: error.toString()),
    loading: () => Loader(),
    );
  }
}