import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(Uint8List image) async {
    String downloadURL;
    String postId = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("profilepic")
        .child(_auth.currentUser!.uid)
        .child("post_$postId.jpg");
    await ref.putData(image);
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }
}
