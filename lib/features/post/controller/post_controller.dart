import 'dart:io';

import 'package:blogapp/features/auth/controller/auth_controller.dart';
import 'package:blogapp/features/post/repository/post_repo.dart';
import 'package:blogapp/model/comment_model.dart';
import 'package:blogapp/model/comunity_model.dart';
import 'package:blogapp/model/post_model.dart';
import 'package:blogapp/static_file/constants/utils.dart';
import 'package:blogapp/static_file/providers/firebase_provider.dart';
import 'package:blogapp/static_file/providers/storage_repo_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final getPostCommentsProvider = StreamProvider.family((ref,String postId){
  final postController = ref.read(postControllerProvider.notifier);
  return postController.getCommentsofPost(postId);
});

final getPostIdProvider = StreamProvider.family((ref,String postId){
  final postController = ref.read(postControllerProvider.notifier);
  return postController.getPostUserId(postId);
});

final postControllerProvider = StateNotifierProvider<PostController,bool>((ref) {
  return PostController(
    postRepository: ref.watch(postRepositoryProvider), 
    ref: ref, 
    storageRepo: ref.watch(firebaseStorageProvider));
});

final userPostProvider = StreamProvider.family((ref,List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

class PostController extends StateNotifier<bool>{
  final PostRepository _postRepository;
  final Ref _ref;
  final firebaseStorageRepo _storageRepo;

  PostController({
    required PostRepository postRepository, 
    required Ref ref,
    required firebaseStorageRepo storageRepo
    }) 
    : _postRepository = postRepository, 
    _ref = ref,
    _storageRepo=storageRepo,
    super(false);

    void shareTextpost({
      required BuildContext context,
      required Community selectedCommunity,
      required String title,
      required String description,
    }) async {
      state=true;
      final String postid = Uuid().v1();
      final user = _ref.read(userProvider)!;
      Post post = Post(
        id: postid, 
        title: title, 
        description: description, 
        communityName: selectedCommunity.name, 
        communityProfilePic: selectedCommunity.avatar, 
        upvotes: [], 
        downvotes: [], 
        commentCount: 0, 
        Username: user.name, 
        uid: user.uid, 
        type: 'text', 
        creationTime: DateTime.now(), 
        awards: [], 
        link: null);

        final res = await _postRepository.addPost(post);
        state=false;
        res.fold(
          (l) => ShowSnackBar(context,l.message), 
        (r) {
          ShowSnackBar(context, 'Post Created Successfully');
        return Routemaster.of(context).pop();
        }); 
    }

     void shareLinkpost({
      required BuildContext context,
      required Community selectedCommunity,
      required String title,
      required String link,
    }) async {
      state=true;
      final String postid = Uuid().v1();
      final user = _ref.read(userProvider)!;
      Post post = Post(
        id: postid, 
        title: title, 
        description: null, 
        communityName: selectedCommunity.name, 
        communityProfilePic: selectedCommunity.avatar, 
        upvotes: [], 
        downvotes: [], 
        commentCount: 0, 
        Username: user.name, 
        uid: user.uid, 
        type: 'link', 
        creationTime: DateTime.now(), 
        awards: [], 
        link: link);

        final res = await _postRepository.addPost(post);
        state=false;
        res.fold(
          (l) => ShowSnackBar(context,l.message), 
        (r) {
        ShowSnackBar(context, 'Post Created Successfully');
        return Routemaster.of(context).pop();
        });
      }

      void shareImagepost({
      required BuildContext context,
      required Community selectedCommunity,
      required String title,
      required File? file, 
    }) async {
      state=true;
      final String postid = Uuid().v1();
      final user = _ref.read(userProvider)!;
      final imageRes = await _storageRepo.storeFile(
        path: 'posts/${selectedCommunity.name}', 
        id: postid, 
        file: file);

      imageRes.fold((l) => ShowSnackBar(context,l.message), (r) async {
        Post post = Post(
        id: postid, 
        title: title, 
        description: null, 
        communityName: selectedCommunity.name, 
        communityProfilePic: selectedCommunity.avatar, 
        upvotes: [], 
        downvotes: [], 
        commentCount: 0, 
        Username: user.name, 
        uid: user.uid, 
        type: 'image', 
        creationTime: DateTime.now(), 
        awards: [], 
        link: r);

        final res = await _postRepository.addPost(post);
        state=false;
        res.fold(
          (l) => ShowSnackBar(context,l.message), 
        (r) {
          ShowSnackBar(context, 'Posted Successfully');
          Routemaster.of(context).pop();
        });
      });
    }

    Stream<List<Post>> fetchUserPosts(List<Community> communities){
      if(communities.isNotEmpty){
        Stream<List<Post>> res = _postRepository.fetchUserPosts(communities);
        print('list of post $res');
        return res;
      }else{
        return Stream.value([]);
      }
    }

    void deletePost(BuildContext context , Post post) async {
      final res =  await _postRepository.deletePost(post);
      res.fold((l) => ShowSnackBar(context,l.message),
       (r) => ShowSnackBar(context, 'Deleted succesfully'));
    }

    void upvote(Post post) async {
      final userId = _ref.read(userProvider)!.uid;
      _postRepository.upvote(post, userId);
    }

    void downvote(Post post) async {
      final userId = _ref.read(userProvider)!.uid;
      _postRepository.downvote(post, userId);
    }

    Stream<Post> getPostUserId(String postId){
      return _postRepository.getPostUserId(postId);
    }

    void addComment({
      required BuildContext context,
      required String text,
      required Post post,
    }) async {
      final user = _ref.read(userProvider)!;
      String commentid = Uuid().v1();
      CommentM comment = CommentM(
        id: commentid, 
        text: text, 
        creationTime: DateTime.now() , 
        postId: post.id, 
        username: user.name, 
        profilepic: user.profilePic);
      final res = await _postRepository.addComment(comment);
      res.fold((l) => ShowSnackBar(context,l.message), (r) => null);
    }

    Stream<List<CommentM>> getCommentsofPost(String postId){
      return _postRepository.getCommentsofPost(postId);
    }

      
}