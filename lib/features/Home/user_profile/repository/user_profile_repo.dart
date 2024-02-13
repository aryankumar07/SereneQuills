import 'package:blogapp/model/usermodel.dart';
import 'package:blogapp/static_file/constants/firebase_const.dart';
import 'package:blogapp/static_file/failure.dart';
import 'package:blogapp/static_file/providers/firebase_provider.dart';
import 'package:blogapp/static_file/type_defs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final UserProileRepoistoryProvider = Provider((ref) =>
 UserProfileRepository(firestore: ref.read(firestoreProvider)));

class UserProfileRepository{
    final FirebaseFirestore _firestore;
  UserProfileRepository(
    {
      required FirebaseFirestore firestore
    } 
  ):_firestore=firestore;

   CollectionReference get _user => _firestore.collection(FirebaseConstants.usersCollection);

   FutureVoid editProfile(UserModel user) async {
    try{
      return right(_user.doc(user.uid).update(user.toMap()));
    }on FirebaseException catch (e){
      throw e.message!;
    }catch (e){
      return left(Failure(e.toString()));
    }
   }

}