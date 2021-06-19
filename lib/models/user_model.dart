import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:plantao/models/locais_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:image/image.Dart' as Im;

class UserModel extends Model {

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  AuthResult result;
  Map<String, dynamic> userData = Map();
  LocaisModel locaisModel;

  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  Future<StorageTaskSnapshot> saveImage(File imagemFile, String imagemNome) async{





    StorageUploadTask task = FirebaseStorage.instance.ref().child(imagemNome).putFile(imagemFile);
    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    return taskSnapshot;
  }

  void signUp({@required Map<String, dynamic> userData, @required String pass,
    @required VoidCallback onSuccess, @required VoidCallback onFail, @required File imagemFile}) async{
    print(userData);
    isLoading = true;
    notifyListeners();
    if(imagemFile != null) {
      StorageTaskSnapshot imagem = await saveImage(imagemFile, userData["cpf"]);

      String url = await imagem.ref.getDownloadURL();
      userData.addAll({ "foto": url
      });
    }



    _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: pass
    ).then((user) async {
      result = user;
      firebaseUser = result.user;
      await _saveUserData(userData);
        this.userData = userData;
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){
      onFail();
      isLoading = false;
      notifyListeners();
    });

  }

  void signIn({@required String email, @required String pass,
    @required VoidCallback onSuccess, @required VoidCallback onFail}) async {

    isLoading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(email: email, password: pass).then(
            (user) async {
          firebaseUser = user.user;

          onSuccess();
          isLoading = false;
          notifyListeners();

        }).catchError((e){

      isLoading = false;
      notifyListeners();
      onFail();

    });

  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn(){
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if(firebaseUser == null)
      firebaseUser = await _auth.currentUser();
    if(firebaseUser != null){
      if(userData["name"] == null){
        DocumentSnapshot docUser =
        await Firestore.instance.collection("users").document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }

}