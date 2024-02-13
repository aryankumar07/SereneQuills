

import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolSscreen extends StatelessWidget{
  final String name;
  ModToolSscreen({super.key,required this.name});

  void navigateToEditCommunity(BuildContext context){
    Routemaster.of(context).push('/edit_community/$name');
  }

  void navigateToAddModScreen(BuildContext context){
    Routemaster.of(context).push('/add_mods/$name');
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Mod Tools'),
      ),
      body: Column(
        children: [
          ListTile( 
            leading: Icon(Icons.add_moderator),
            title: Text('Add Moderators'),
            onTap: (){
              navigateToAddModScreen(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.add_moderator),
            title: Text('Edit Community'),
            onTap: (){
              navigateToEditCommunity(context);
            },
          ),
        ],
      ),
    );
  }
}