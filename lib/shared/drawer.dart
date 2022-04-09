import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_with_username_email/model/user_provider.dart';
import 'package:login_with_username_email/services/storage.dart';
import 'package:login_with_username_email/shared/loading.dart';
import 'package:login_with_username_email/utils/utils.dart';
import 'package:provider/provider.dart';

class drawers extends StatefulWidget {
  UserProvider userProvider;
  drawers({required this.userProvider});

  @override
  State<drawers> createState() => _drawersState();
}

class _drawersState extends State<drawers> {
  Uint8List? _image;
  StorageMethods storageMethods = StorageMethods();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  selectImageCamera() async {
    Uint8List im = await pickImage(ImageSource.camera);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  selectImageGallery() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  uploadToFirebase() async {
    String url = await storageMethods.uploadFile(
        _image!); // this will upload the file and store url in the variable 'url'
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      //use update to update the doc fields.
      'url': url
    });
  }

  @override
  Widget build(BuildContext context) {
    var userData = widget.userProvider.currentUserData;
    String? url = userData!.url;
    return Drawer(
      child: ListView(padding: EdgeInsets.all(0), children: <Widget>[
        /*DrawerHeader(
          child: Text('Hello'),
          decoration: BoxDecoration(
            color: Colors.red,
          ),
        ),*/

        userData.email == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : UserAccountsDrawerHeader(
                accountName: Text(userData.username!),
                accountEmail: Text(userData.email!),
                currentAccountPicture:
                    Stack(overflow: Overflow.visible, children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                              url ?? 'https://i.stack.imgur.com/l60Hf.png'),
                        ),
                  Positioned(
                    top: 32,
                    left: 40,
                    child: IconButton(
                        onPressed: (() async {
                          await showModalBottomSheet(
                              context: context,
                              builder: (builder) => bottomSheet());

                          await uploadToFirebase();
                        }),
                        icon: Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 20,
                        )),
                  )
                ]),
              ),
        ListTile(
          leading: Icon(Icons.person_search),
          title: Text('Edit Profile'),
          onTap: () {},
        )
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 70,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: FlatButton.icon(
                    onPressed: () async {
                      await selectImageCamera();
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text('Camera')),
              ),
              Expanded(
                child: FlatButton.icon(
                    onPressed: () async {
                      await selectImageGallery();
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.photo_size_select_actual_rounded),
                    label: Text('Gallery')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
