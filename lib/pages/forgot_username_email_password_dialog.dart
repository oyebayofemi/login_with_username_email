import 'package:flutter/material.dart';

class ForgotUsernameEmailPasswordDialog extends StatelessWidget {
  const ForgotUsernameEmailPasswordDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        alignment: Alignment.centerLeft,
        height: 200,
        width: 700,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose any option below',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => PolicyRegNoForgotWidget(),
                  //     ));
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 50,
                  //color: Colors.pink,
                  child: Text(
                    'Policy or registration no',
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => UsernameForgot(),
                  //     ));
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 50,
                  //color: Colors.pink,
                  child: Text(
                    'Username',
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => EmailForgotWidget(),
                  //     ));
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 50,
                  //color: Colors.pink,
                  child: Text(
                    'Email',
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
