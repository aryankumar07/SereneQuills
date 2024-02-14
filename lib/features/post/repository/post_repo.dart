import 'package:blogapp/model/comment_model.dart';
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

  CollectionReference get _comments => 
  _firestore.collection(FirebaseConstants.commentsCollection);


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


  FutureVoid deletePost(Post post) async {
    try{
      return right(_posts.doc(post.id).delete());
    }on FirebaseException catch (e){
      throw e.toString();
    }catch (e){
      return left(Failure(e.toString()));
    }
  }

  void upvote(Post post,String userId) async {
    if(post.downvotes.contains(userId)){
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    }
    
    if(post.upvotes.contains(userId)){
      _posts.doc(post.id).update({
        'upvotes':FieldValue.arrayRemove([userId]),
      });
    }else{
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

    void downvote(Post post,String userId) async {
    if(post.upvotes.contains(userId)){
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    }
    
    if(post.downvotes.contains(userId)){
      _posts.doc(post.id).update({
        'downvotes':FieldValue.arrayRemove([userId]),
      });
    }else{
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }


  Stream<Post> getPostUserId(String postId){
    return _posts.doc(postId)
    .snapshots()
    .map((event) => Post.fromMap(event.data() as Map<String,dynamic>));
  }

  FutureVoid addComment(CommentM comment)async{
    try{
      return right(_comments.doc(comment.id).set(comment));
    }on FirebaseException catch (e){
      throw e.message!;
    }catch (e){
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CommentM>> getCommentsofPost(String postId){
    return 
    _comments
    .where('postId',isEqualTo: postId)
    .orderBy('creationTime',descending: true)
    .snapshots()
    .map((event) => event.docs.map((e) => 
    CommentM.fromMap(e.data() as Map<String,dynamic>)).toList());
  }

}