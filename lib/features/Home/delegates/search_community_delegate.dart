import 'package:blogapp/features/communuty/controller/communty_controller.dart';
import 'package:blogapp/static_file/common/error_text.dart';
import 'package:blogapp/static_file/common/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDelegate(
    this.ref
    );
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(
      onPressed: (){
        query='';
      },
       icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchcommunityProvider(query)).when
    (data: (communities) =>ListView.builder(
      itemCount: communities.length,
      itemBuilder: (BuildContext context,int index){
        final community = communities[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(community.avatar),
          ),
          title: Text('b/${community.name}'),
          onTap: () => goToCommunty(context, community.name),
        );
      }),
       error: ((error, stackTrace) => ErrorText(error: error.toString())),
        loading: () => Loader());
  }

    void goToCommunty(BuildContext context,String communityName){
    Routemaster.of(context).push('b/$communityName');
  }

}