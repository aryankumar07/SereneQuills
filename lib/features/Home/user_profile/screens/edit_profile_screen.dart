import 'dart:io'; 
import 'package:blogapp/features/Home/user_profile/controller/user_profile_controller.dart';
import 'package:blogapp/features/auth/controller/auth_controller.dart';
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
import 'package:routemaster/routemaster.dart';

class EditProfileScreen extends ConsumerStatefulWidget{
  final String uid;

  EditProfileScreen({super.key,required this.uid});



  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _EdtProfileScreenState();
  }
}

class _EdtProfileScreenState extends ConsumerState<EditProfileScreen>{

  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController; 

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose(); 
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

  void save(){
    ref.read(userProifileControllerProvider.notifier)
    .editProfile(
      profileFile: profileFile, 
      bannerFile: bannerFile, 
      name: nameController.text.trim(), 
      context: context);
  }



  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProifileControllerProvider);
    return ref.watch(getUserDataProvider(widget.uid))
    .when(
      data:(user) => Scaffold(
      backgroundColor: ColorCodes.darkModeAppTheme.backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        title: Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: save, 
            child: Text('Save'))
        ],
      ),
      body: isLoading? 
      Loader() : Padding(
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
                         user.banner.isEmpty || user.banner == Constants.bannerDefault?
                        Center(
                          child: Icon(Icons.camera_alt_outlined,size: 40,),
                        )
                        :
                        Image.network(user.banner)
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
                          backgroundImage:  NetworkImage(user.profilePic),
                          radius: 32,
                        ),
                      ),
                    )
                ],
              ),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                hintText: 'name',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(18)
              ),
            ),
          ],
        ),
      )
    ),
    error: (error, stackTrace) => ErrorText(error: error.toString()),
    loading: () => Loader(),
    );

  }
}