import 'dart:io';

import 'package:blogapp/features/communuty/controller/communty_controller.dart';
import 'package:blogapp/features/post/controller/post_controller.dart';
import 'package:blogapp/model/comunity_model.dart';
import 'package:blogapp/static_file/common/error_text.dart';
import 'package:blogapp/static_file/common/loader.dart';
import 'package:blogapp/static_file/constants/utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget{
  final String type;
  AddPostTypeScreen({super.key,required this.type});


  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _addPostTypeScreenState();
  }
}

class _addPostTypeScreenState extends ConsumerState<AddPostTypeScreen>{

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  List<Community> communities = [];
  Community? selectedCommunity;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  
  }

  @override
  Widget build(BuildContext context) {
    final isImageType = widget.type == 'image';
    final isTextType = widget.type == 'text';
    final isLinkType = widget.type == 'link';

    


  void selectBannerImage() async {
    final res = await pickImage();

    if(res!=null){
      setState(() {
      // print('enterd for image picking');
      bannerFile = File(res.files.first.path!); 
      // print(bannerFile);
      });
    }else{
      ShowSnackBar(context, 'something went wrong');
    }
  }

  void sharePost(){
    if(isImageType && bannerFile!=null && titleController.text.isNotEmpty){
      ref.read(postControllerProvider.notifier).shareImagepost(
        context: context, 
        selectedCommunity: selectedCommunity??communities[0], 
        title: titleController.text.trim(), 
        file: bannerFile);
    }else if(isTextType && titleController.text.isNotEmpty){
      ref.read(postControllerProvider.notifier).shareTextpost(
        context: context, 
        selectedCommunity: selectedCommunity??communities[0], 
        title: titleController.text.trim(), 
        description: descriptionController.text.trim());
    }else if(isLinkType && linkController.text.isNotEmpty){
      ref.read(postControllerProvider.notifier).shareLinkpost(
        context: context, 
      selectedCommunity: selectedCommunity ?? communities[0], 
      title: titleController.text.trim(), 
      link: linkController.text.trim());
    }else{
      ShowSnackBar(context, 'Please Enter all The Required Field');
    }
  }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('post ${widget.type}')),
        actions: [
          TextButton(
            onPressed: () => sharePost(),
            child: Text('Share'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
                controller: titleController,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Enter Title Here',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18)
                ),
                maxLength: 30,
              ),
              SizedBox(height: 10,),

              if(isImageType)...[
              GestureDetector(
                    onTap: selectBannerImage,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(16),
                      color: Colors.white,
                      child: Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: bannerFile ==null ?
                        Center(
                          child: Icon(Icons.camera_alt_outlined,size: 40,),
                        )
                         :
                        Image.file(bannerFile!)
                      )),
                  ),
              ],

              if(isTextType)...[
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                      filled: true,
                      hintText: 'Enter Description Here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18)
                ),
                maxLines: 5,
              ),
              ],
              
              if(isLinkType)...[
                TextField(
                      controller: linkController,
                      decoration: InputDecoration(
                      filled: true,
                      hintText: 'Enter Link Here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18)
                ),
              ),
              ],
              SizedBox(height: 20,),
              Align(
                alignment: Alignment.topLeft,
                child: Text('Select Your Community')),
              ref.watch(userCommunityProvider).when(
                data: (data) {
                communities = data;
                if(data.isEmpty){
                  return SizedBox();
                }

                return DropdownButton(
                  value: selectedCommunity ?? data[0],
                  items: data.map((e) => 
                  DropdownMenuItem(
                    value: e, 
                    child: Text(e.name))).toList(),
                   onChanged: (val){
                    setState(() {
                      selectedCommunity = val;
                    });
                   });
              } ,
               error: ((error, stackTrace) => ErrorText(error: error.toString())), 
               loading: ()=> Loader())
          ],
        ),
      ),
    );
  }
}