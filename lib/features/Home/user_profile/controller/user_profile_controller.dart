import 'dart:io';

import 'package:blogapp/features/Home/user_profile/repository/user_profile_repo.dart';
import 'package:blogapp/features/auth/controller/auth_controller.dart';
import 'package:blogapp/model/usermodel.dart';
import 'package:blogapp/static_file/constants/utils.dart';
import 'package:blogapp/static_file/providers/storage_repo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';


final userProifileControllerProvider = StateNotifierProvider<UserProfileController,bool>((ref) =>
 UserProfileController(
  userProfileRepository: ref.watch(UserProileRepoistoryProvider),
  storageRepo: ref.watch(firebaseStorageProvider),
  ref: ref
  ));

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final firebaseStorageRepo _storageRepo;

  UserProfileController({
    required UserProfileRepository userProfileRepository, 
    required Ref ref, 
    required firebaseStorageRepo storageRepo,
    })
   : _userProfileRepository = userProfileRepository, 
   _ref = ref,
   _storageRepo = storageRepo,
   super(false);

  void editProfile({
    required File? profileFile,
    required File? bannerFile,
    required String name,
    required BuildContext context,
    }) async {
      state=true;
      UserModel user = _ref.watch(userProvider)!;
      if(profileFile!=null){
        //storing profile photo and getting a download url 
      final res = await _storageRepo.storeFile(
        path: 'users/profile', 
        id: user.uid, 
        file: profileFile);

        res.fold(
          (l) => ShowSnackBar(context,l.message),
          (r) => user = user.copyWith(profilePic: r));

      }

      if(bannerFile!=null){
        //storing banner photo and getting a download url 
      final res = await _storageRepo.storeFile(
        path: 'users/banner', 
        id: user.uid, 
        file: bannerFile);

        res.fold(
          (l) => ShowSnackBar(context,l.message),
          (r) => user = user.copyWith(banner: r));

      }

      user.copyWith(name: name);
      final res = await _userProfileRepository.editProfile(user);
      state=false;
      res.fold(
        (l) => ShowSnackBar(context,l.message), 
        (r) {
          _ref.read(userProvider.notifier).update((state) => user);
          Routemaster.of(context).pop();
          },
        );
  }

}