import 'package:blogapp/features/auth/controller/auth_controller.dart';
import 'package:blogapp/features/communuty/controller/communty_controller.dart';
import 'package:blogapp/static_file/common/error_text.dart';
import 'package:blogapp/static_file/common/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddModerator extends ConsumerStatefulWidget{
  final String name;
  AddModerator({super.key,required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddModeratorState();
  }
}

class _AddModeratorState extends ConsumerState<AddModerator>{
  int ctr=0;
  Set<String> uids = {};


  void addUids(String uid){
    setState(() {
      uids.add(uid);
    });
  }

  void removeUids(String uid){
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods(){
    ref.read(CommunityControllerProvider.notifier)
    .addMods(widget.name, uids.toList(), context);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (){
              saveMods();
            },
           icon: Icon(Icons.save)),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name))
      .when(
        data: (community) => ListView.builder(
          itemCount: community.member.length,
          itemBuilder: (context, index) {
            final member = community.member[index];
            return ref.watch(getUserDataProvider(member)).when(
              data: (user) {
                if(community.mods.contains(user.uid) && ctr==0){
                  uids.add(user.uid);
                }
                ctr++;
            return CheckboxListTile(
            value: uids.contains(user.uid), 
            onChanged: (val) {
              if(val!){
                addUids(user.uid);
              }else{
                removeUids(user.uid);
              }
            },
            title: Text(user.name),
            );
            },
            error: ((error, stackTrace) => ErrorText(error: error.toString())), 
            loading: ()=>Loader()
            );
          }), 
      error: ((error, stackTrace) => ErrorText(error: error.toString())), 
      loading: ()=>Loader())
    );
  }
}