import 'package:blogapp/model/comunity_model.dart';
import 'package:blogapp/model/post_model.dart';
import 'package:blogapp/static_file/constants/firebase_const.dart';
import 'package:blogapp/static_file/failure.dart';
import 'package:blogapp/static_file/providers/firebase_provider.dart';
import 'package:blogapp/static_file/type_defs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';


final postRepositoryProvider = Provider((ref) => 
PostRepository(firestore: ref.watch(firestoreProvider)));


class PostRepository{
  final FirebaseFirestore _firestore;
  PostRepository({
    required FirebaseFirestore firestore,
  }):_firestore=firestore;

  CollectionReference get _posts => 
  _firestore.collection(FirebaseConstants.postsCollection);


  FutureVoid addPost(Post post) async {
    try{
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e){
      throw e.message!;
    } catch (e){
      return left(Failure(e.toString()));
    }
  }


  Stream<List<Post>> fetchUserPosts(List<Community> communities){
    return 
    _posts.where('communityName',whereIn: communities.map((e) => e.name).toList())
    .orderBy('creationTime',descending: true)
    .snapshots()
    .map((event) => event.docs.map((e) => 
    Post.fromMap(e.data() as Map<String,dynamic>)).toList());
  }





}