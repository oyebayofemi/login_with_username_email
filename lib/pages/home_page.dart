import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_with_username_email/model/userModel.dart';
import 'package:login_with_username_email/model/user_provider.dart';
import 'package:login_with_username_email/pages/forgot_username_email_password_dialog.dart';
import 'package:login_with_username_email/services/auth_controller.dart';
import 'package:login_with_username_email/shared/drawer.dart';
import 'package:login_with_username_email/shared/loading.dart';
import 'package:login_with_username_email/utils/car_repo.dart';
import 'package:login_with_username_email/utils/state_repo.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:login_with_username_email/model/state_model.dart';
import 'package:flutter/services.dart' as rootBundle;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Repository repo = Repository();
  CarRepository carRepo = CarRepository();

  List<String> _states = ["Choose a state"];
  List<String> _lgas = ["Choose .."];
  String? _selectedState;
  String _selectedLGA = "Choose ..";

  List<String> _make = ["Choose a Car"];
  List<String> _brand = ["Choose .."];
  String _selectedMake = "Choose a Car";
  String? _selectedbrand;
  List<String> category = ["choose"];
  int indexs = 0;

  bool _isLoading = false;

  // list = json.decode(response.body)['results']
  //     .map((data) => Model.fromJson(data))
  //     .toList();

  // Future<String> readJsonData() async {
  //   final jsondata =
  //       await rootBundle.rootBundle.loadString('json_file/states_lga.json');
  //   final list = jsonDecode(jsondata);
  //   final statelist =
  //       jsonDecode(jsondata)['state'].map((data) => StateModel.fromJson(data));
  //   //     .toList();

  //   setState(() {
  //     data = list;
  //     state = statelist;
  //   });

  //   return 'success';
  // }
  void _onSelectedState(String value) async {
    setState(() {
      _selectedLGA = "Choose ..";
      _selectedState = value;
      _lgas = ["Choose .."];
      _isLoading = true;
    });

    _lgas = List.from(_lgas)..addAll(await repo.getLocalByState(value));

    setState(() {
      _isLoading = false;
    });
  }

  void _onSelectedLGA(String value) {
    setState(() => _selectedLGA = value);
  }

  void _onSelectedMake(String value) async {
    setState(() {
      _selectedbrand = "Choose ..";
      _selectedMake = value;
      _brand = ["Choose .."];

      _isLoading = true;
    });

    _brand = List.from(_brand)..addAll(await carRepo.getBrands(value));
    category = List.from(category)..addAll(await carRepo.getCategory(value));

    setState(() {
      _isLoading = false;
    });
  }

  void _onSelectedBrand(String value) async {
    setState(() => _selectedbrand = value);
  }

  void getIndex(String value) {
    setState(() {});
    indexs = _brand.indexWhere((item) => item == value);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _states = List.from(_states)..addAll(repo.getStates());
    _make = List.from(_make)..addAll(carRepo.getMakes());
  }

  @override
  Widget build(BuildContext context) {
    // UserProvider userData = Provider.of<UserProvider>(context);
    // String username;
    // if (userData.ds == null) {
    //   userData.getUserData();
    // }

    // username = userData.ds!['username'];
    //print(data['Abia']);

    UserProvider userProvider = Provider.of(context);
    userProvider.getUserData();
    print(_make);
    print(_brand);
    print(category);
    print(indexs);
    print(category[indexs]);

    var userData = userProvider.currentUserData;

    FirebaseAuth _auth = FirebaseAuth.instance;

    //String username = userData!.username;
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        drawer: drawers(userProvider: userProvider),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Text(userData!.email!),
                Text('LoggedIN'),
                CircleAvatar(
                  radius: 64,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(
                      userData.url ?? 'https://i.stack.imgur.com/l60Hf.png'),
                ),
                DropdownButton<String>(
                  underline: Container(),
                  isExpanded: true,
                  hint: Text('State'), // Not necessary for Option 1
                  value: _selectedState,
                  onChanged: (newValue) {
                    _onSelectedState(newValue!);
                  },
                  items: _states.map((item) {
                    return DropdownMenuItem(
                      child: Text(item),
                      value: item.toString(),
                    );
                  }).toList(),
                ),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : DropdownButton<String>(
                        underline: Container(),
                        isExpanded: true,
                        hint: Text('LGA'), // Not necessary for Option 1
                        value: _selectedLGA,
                        onChanged: (newValue) {
                          _onSelectedLGA(newValue!);
                        },
                        items: _lgas.map((item) {
                          return DropdownMenuItem(
                            child: Text(item),
                            value: item.toString(),
                          );
                        }).toList(),
                      ),
                FlatButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => Home(),
                      //     ));
                    },
                    child: Text('hOME')),
                FlatButton.icon(
                    color: Colors.yellow,
                    onPressed: () async {
                      final auth =
                          Provider.of<AuthController>(context, listen: false);

                      await AuthController().signout();
                    },
                    icon: Icon(Icons.logout_outlined),
                    label: Text('Loggout')),
                DropdownButton<String>(
                  underline: Container(),
                  isExpanded: true,
                  hint: Text('Car'), // Not necessary for Option 1
                  value: _selectedMake,
                  onChanged: (newValue) {
                    _onSelectedMake(newValue!);
                  },
                  items: _make.map((item) {
                    return DropdownMenuItem(
                      child: Text(item),
                      value: item.toString(),
                    );
                  }).toList(),
                ),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : DropdownButton<String>(
                        underline: Container(),
                        isExpanded: true,
                        hint: Text('Brand'), // Not necessary for Option 1
                        value: _selectedbrand,
                        onChanged: (newValue) {
                          _onSelectedBrand(newValue!);
                          try {
                            getIndex(newValue);
                          } catch (e) {
                            print(e);
                          }
                        },
                        items: _brand.map((item) {
                          return DropdownMenuItem(
                            child: Text(item),
                            value: item.toString(),
                          );
                        }).toList(),
                      ),
                FlatButton(
                    color: Colors.blue,
                    onPressed: () {
                      showDialog(
                        context: OneContext().context!,
                        builder: (BuildContext context) {
                          return Error2Dialog('This is the second error');
                        },
                      );
                    },
                    child: Text('Error 2')),
                InkWell(
                  onTap: () {
                    showinfo(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 2),
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Username/Email/Password?',
                      style: TextStyle(
                          color: Color(0xff991F36),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          fontSize: 15),
                      //textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void showinfo(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text('About Flutter Torch'),
      content: Text('app made by alik kumar ghosh'),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}

class Error2Dialog extends StatelessWidget {
  final title;

  Error2Dialog(this.title);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      child: Container(
        height: 200,
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Icon(
                  Icons.account_balance_wallet,
                  size: 60,
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.orange,
                child: SizedBox.expand(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Expanded(child: Text(title)),
                        ButtonTheme(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: FlatButton(
                              color: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'okay',
                                style: TextStyle(color: Colors.orange),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
