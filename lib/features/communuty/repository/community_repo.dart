import 'dart:ffi';

import 'package:blogapp/model/comunity_model.dart';
import 'package:blogapp/static_file/constants/firebase_const.dart';
import 'package:blogapp/static_file/failure.dart';
import 'package:blogapp/static_file/providers/firebase_provider.dart';
import 'package:blogapp/static_file/type_defs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final CommunityRepoistoryProvider = Provider((ref) =>
 CommunityRepoistory(firestore: ref.read(firestoreProvider)));

class CommunityRepoistory {
  final FirebaseFirestore _firestore;
  CommunityRepoistory(
    {
      required FirebaseFirestore firestore
    } 
  ):_firestore=firestore;

  CollectionReference get _communities => _firestore.collection(FirebaseConstants.communitiesCollection);
  

  FutureVoid createCommunity(Community community) async {
    try{
      var communitydoc = await _communities.doc(community.name).get();
      if(communitydoc.exists){
        throw 'Community with same name exits';
      }
      print('entered in creating community repo');
      return right(_communities.doc(community.name).set(community.toMap()));
    }on FirebaseException catch (e){
      throw e.message!;
    }catch (e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid joinCommunity(String communityname,String userid) async {
    try{
      return right(
        _communities.doc(communityname).update({
          'member': FieldValue.arrayUnion([userid]),
        })
      );
    }on FirebaseException catch (e){
      throw e.message!;
    }catch (e){
      return left(Failure(e.toString()));
    }
  }


  FutureVoid leaveCommunity(String communityname,String userid) async {
    try{
      return right(
        _communities.doc(communityname).update({
          'member': FieldValue.arrayRemove([userid]),
        })
      );
    }on FirebaseException catch (e){
      throw e.message!;
    }catch (e){
      return left(Failure(e.toString()));
    }
  }
  

  Stream<List<Community>> getUserCommunity(String uid){
    return _communities.where('member',arrayContains: uid).snapshots().map((event) {
      List<Community> communities=[];
      for(var doc in event.docs){
        communities.add(Community.fromMap(doc.data() as Map<String,dynamic>));
      }
      return communities;
    });
  }

  Stream<Community> getCommunityByName(String name){
    return _communities.doc(name)
    .snapshots().map((event) => 
    Community.fromMap(event.data() as Map<String,dynamic>));
  }

  Stream<List<Community>> searchCommunity(String query){
    return _communities.where('name',
    isGreaterThanOrEqualTo: query.isEmpty? 0 : query,
    isLessThan: query.isEmpty? null :
     query.substring(0,query.length-1) +
    String.fromCharCode(query.codeUnitAt(query.length-1)+1),
    ).snapshots().map((event) { 
      List<Community> communities=[];
      for(var community in event.docs){
        communities.add(Community.fromMap(community.data() as Map<String,dynamic>));
      }
      return communities;
    });
  }

  FutureVoid editCommunity(Community community) async {
    try{
      return right(_communities.doc(community.name).update(community.toMap()));
    }on FirebaseException catch (e){
      throw e.message!;
    }catch (e){
      return left(Failure(e.toString()));
    }
  }
  
  FutureVoid addMods(String communityName , List<String> uids) async {
    try{
      return right(
        _communities.doc(communityName).update({
          'mods':uids
        })
      );
    }on FirebaseException catch (e){
      throw e.message!;
    }catch (e){
      return left(Failure(e.toString()));
    }
  }
}