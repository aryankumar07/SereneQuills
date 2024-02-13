import 'dart:ffi';
import 'dart:io';
import 'package:blogapp/features/auth/controller/auth_controller.dart';
import 'package:blogapp/features/communuty/repository/community_repo.dart';
import 'package:blogapp/model/comunity_model.dart';
import 'package:blogapp/static_file/constants/constants.dart';
import 'package:blogapp/static_file/constants/utils.dart';
import 'package:blogapp/static_file/failure.dart';
import 'package:blogapp/static_file/providers/storage_repo_provider.dart';
import 'package:blogapp/static_file/type_defs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';


final userCommunityProvider = StreamProvider((ref) {
  final communityController = ref.read(CommunityControllerProvider.notifier);
  return communityController.getUserCommunity();
});

final getCommunityByNameProvider = StreamProvider.family((ref,String name) =>
   ref.watch(CommunityControllerProvider.notifier).getCommunityByName(name)
 );


final CommunityControllerProvider = StateNotifierProvider<CommunityController,bool>((ref) =>
 CommunityController(
  communityRepoistory: ref.watch(CommunityRepoistoryProvider),
  storageRepo: ref.watch(firebaseStorageProvider),
  ref: ref
  ));

  
  final  searchcommunityProvider = StreamProvider.family((ref,String query) =>
  ref.watch(CommunityControllerProvider.notifier).searchCommunity(query)
   );

class CommunityController extends StateNotifier<bool> {
  final CommunityRepoistory _communityRepoistory;
  final firebaseStorageRepo _storageRepo;
  final Ref _ref;

  CommunityController(
    {required CommunityRepoistory communityRepoistory,
    required Ref ref,
    required firebaseStorageRepo storageRepo
    }
  ): _communityRepoistory = communityRepoistory,_storageRepo=storageRepo,_ref=ref,super(false);

  void createCommunity(String name,BuildContext context) async {
    state=true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
    id: uid, 
    name: name, 
    banner: Constants.bannerDefault, 
    avatar: Constants.avatarDefault, 
    member: [uid], 
    mods: [uid]);

    final res = await _communityRepoistory.createCommunity(community);
    state=false;
    res.fold((l) => ShowSnackBar(context,l.message), (r) {
      ShowSnackBar(context,'Community Created Successfuly!');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> getUserCommunity(){
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepoistory.getUserCommunity(uid);
  }

  Stream<Community> getCommunityByName(String name){
    return _communityRepoistory.getCommunityByName(name);
  }

  void editCommunity({
    required Community community,
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
    }) async {
      state=true;
      if(profileFile!=null){
        //storing profile photo and getting a download url 
      final res = await _storageRepo.storeFile(
        path: 'communities/profile', 
        id: community.name, 
        file: profileFile);

        res.fold(
          (l) => ShowSnackBar(context,l.message),
          (r) => community = community.copyWith(avatar: r));

      }

      if(bannerFile!=null){
        //storing banner photo and getting a download url 
      final res = await _storageRepo.storeFile(
        path: 'communities/banner', 
        id: community.name, 
        file: bannerFile);

        res.fold(
          (l) => ShowSnackBar(context,l.message),
          (r) => community = community.copyWith(banner: r));

      }

      final res = await _communityRepoistory.editCommunity(community);
      state=false;
      res.fold(
        (l) => ShowSnackBar(context,l.message), 
        (r) => Routemaster.of(context).pop(),
        );
  }
  
  Stream<List<Community>> searchCommunity(String query){
    return _communityRepoistory.searchCommunity(query);
  }

  void joinCommunity(Community community,BuildContext context) async{
    final user = _ref.watch(userProvider)!;

    Either<Failure,void> res;
    if(community.member.contains(user.uid)){
      res = await _communityRepoistory.leaveCommunity(community.name, user.uid);
    }else{
      res = await _communityRepoistory.joinCommunity(community.name, user.uid);
    }

    res.fold((l) => ShowSnackBar(context,l.message), (r) => {
      if(community.member.contains(user.uid)){
        ShowSnackBar(context,'Successfully Left the community')
      }else{
        ShowSnackBar(context,'You have joined the community')
      }
    });

  }

  void addMods(String communityName,List<String> uids,BuildContext context) async {
    final res = await _communityRepoistory.addMods(communityName, uids);
    res.fold((l) => ShowSnackBar(context,l.message), (r) {
      Routemaster.of(context).pop();
    });
  }


}