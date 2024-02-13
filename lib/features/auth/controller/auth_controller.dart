import 'dart:ffi';

import 'package:blogapp/model/usermodel.dart';
import 'package:blogapp/static_file/constants/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blogapp/features/auth/repository/auth_repo.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final AuthControllerProvider = StateNotifierProvider<AuthController,bool>
((ref) =>
 AuthController(
  authRepository: ref.watch(AuthRepositoryProvider),
  ref: ref
  ));


final authStateChangeProvider = StreamProvider((ref) {
  final authController =  ref.watch(AuthControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref,String uid) {
  final authController =  ref.watch(AuthControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool>{
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  }) : _authRepository = authRepository ,_ref = ref,super(false);
  final AuthRepository _authRepository;
  final Ref _ref;
  

  void SignInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.SignInWithGoogle();
    state = false;
    // print("in the auth Controller first");
    user.fold((l) => ShowSnackBar(context,l.message), (userModel) =>
     _ref.read(userProvider.notifier).update((state) => userModel));
    // print("updated the usermodel");
  }

  void SignInAsaGuest(BuildContext context) async {
    state = true;
    final user = await _authRepository.SignInAsaGuest  ();
    state = false;
    // print("in the auth Controller first");
    user.fold((l) => ShowSnackBar(context,l.message), (userModel) =>
     _ref.read(userProvider.notifier).update((state) => userModel));
    // print("updated the usermodel");
  }

  

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Stream<UserModel>getUserData(String uid) {
    // print('going to authrepo to fetch data');
    // print(uid);
    return _authRepository.getUserData(uid);
  }

  void logout() async {
    _authRepository.Logout();
  }

}