import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_with_username_email/pages/register_page.dart';
import 'package:login_with_username_email/shared/form_field_decoration.dart';
import 'package:login_with_username_email/shared/snackbar.dart';

class UpdatePassword extends StatefulWidget {
  UpdatePassword({Key? key}) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final formkey = GlobalKey<FormState>();
  String? text;
  String? texts;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Container(
                height: 200,
                width: 350,
                child: Stack(
                  children: [
                    Positioned(
                        top: 50,
                        left: 70,
                        child: Text(
                          'Update',
                          style: TextStyle(
                              fontFamily: 'Truneo',
                              fontSize: 60,
                              fontWeight: FontWeight.bold),
                        )),
                    Positioned(
                        top: 108,
                        left: 240,
                        child: CircleAvatar(
                          minRadius: 7,
                          backgroundColor: Colors.green,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Username/Email:',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Truneo',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) => this.text = value,
                      validator: (value) => value!.isEmpty
                          ? 'Username/Email Field cant be empty'
                          : null,
                      keyboardType: TextInputType.text,
                      decoration: textFormDecoration(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ButtonTheme(
                      buttonColor: Colors.green,
                      minWidth: double.infinity,
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(34)),
                      child: RaisedButton(
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            RegExp regex = RegExp(r'@');
                            if (regex.hasMatch(text!)) {
                              print(text);
                              texts = text;
                              try {
                                QuerySnapshot snap = await FirebaseFirestore
                                    .instance
                                    .collection("users")
                                    .where("email", isEqualTo: text)
                                    .get();
                                texts = snap.docs[0]['email'];
                              } catch (e) {
                                print(e);
                                showSnackBar(context, 'Enter a valid email');
                              }
                              print('email: $texts');
                            } else {
                              try {
                                QuerySnapshot snap = await FirebaseFirestore
                                    .instance
                                    .collection("users")
                                    .where("username", isEqualTo: text)
                                    .get();
                                texts = snap.docs[0]['email'];
                              } catch (e) {
                                print(e);
                                showSnackBar(context, 'Enter a valid Username');
                              }

                              print('email: $texts');
                            }
                          }
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Truneo',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('New Account?'),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      },
                      child: Text(
                        'Register Here',
                        style: TextStyle(
                            color: Colors.green,
                            fontFamily: 'Truneo',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
