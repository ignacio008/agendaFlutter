

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class QuerysService{

  final _fireStore = FirebaseFirestore.instance;


  Future<QuerySnapshot>getAdmin(id)async{
    return await _fireStore.collection("usuarios").where("id",isEqualTo:id).get();
  }
  //para ver login
  Future<DocumentSnapshot> getAdimDocument(id) async{
   return await _fireStore.collection("usuarios").doc(id).get();
   }

    Future<bool> SaveGeneralNota({String reference, String id, Map<String, dynamic> collectionValues}) async {
    bool error = false;
    SetOptions setOptions = SetOptions(merge: true);
    return await _fireStore.collection(reference).doc(id).set(collectionValues, setOptions).catchError((onError){
      error = true;
      return true;
    }).then((onValue){
      if(!error){
        error = false;
        return error;
      }
      else{
        error = true;
        return error;
      }
    });
  }


  Future<bool> SaveGeneralInfoSticker({String reference, String id, Map<String, dynamic> collectionValues}) async {
    bool error = false;
    SetOptions setOptions = SetOptions(merge: true);
    return await _fireStore.collection(reference).doc(id).set(collectionValues, setOptions).catchError((onError){
      error = true;
      return true;
    }).then((onValue){
      if(!error){
        error = false;
        return error;
      }
      else{
        error = true;
        return error;
      }
    });
  }
  Future<bool> actualizarInfoNote({String reference, String id, Map<String, dynamic> collectionValues}) async {
    bool error = false;
    return await _fireStore.collection(reference).doc(id).update(collectionValues).catchError((onError){
      error = true;
      return true;
    }).then((onValue){
      if(!error){
        error = false;
        return error;
      }
      else{
        error = true;
        return error;
      }
    });
  }
  Future<QuerySnapshot> getTopSticker() async{
    return await _fireStore.collection("stickers").orderBy("idSticker").get();
  }
  // Future<QuerySnapshot> getTopNote() async{
  //   return await _fireStore.collection("note").orderBy("idNote").get();
  // }
   Future<QuerySnapshot> getTopNote(String reference) {
    return  _fireStore.collection("note").where("idNote", isEqualTo: reference).get();
  }

}