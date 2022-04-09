import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? email;
  final String? username;
  final String? regNO;
  final String? url;

  UserModel({this.email, this.uid, this.username, this.regNO, this.url});

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'regNO': regNO,
        'url': url,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
        username: snapshot["username"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        url: snapshot["url"],
        regNO: snapshot['regNO']);
  }
}
