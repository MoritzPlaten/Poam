import 'package:flutter/material.dart';
import 'package:poam/services/loginServices/Objects/SignInObject.dart';
import 'package:poam/services/loginServices/loginService.dart';
import 'package:poam/widgets/PoamLogin/PoamLogin.dart';

/*

This Page is at the moment not working

* */
///TODO: Login Page

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late LoginService loginService;
  String emailText = "", passwordText = "", Warn = "";


  @override
  Widget build(BuildContext context) {

    void onPressed() {
      Future<SignInObject> signInObject = loginService.signIn(emailText, passwordText);
      signInObject.then((value) => {

        if (value.wrongPassword == true) {
          Warn = "Sie haben das falsche Password eingegeben!"
        } else if (value.userNotFound == true) {
          Warn = "Dieser User konnte nicht gefunden werden!"
        }

      });
    }

    void onEmailChanged(String value) {
      emailText = value;
    }

    void onPasswordChanged(String value) {
      passwordText = value;
    }

    return Scaffold(
      body: PoamLogin(
        Title: "Login",
        Warn: Warn,
        onPressed: onPressed,
        onEmailChanged: onEmailChanged,
        onPasswordChanged: onPasswordChanged,
      ),
    );
  }
}
