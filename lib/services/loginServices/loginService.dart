import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:poam/services/loginServices/Objects/RegistrationObject.dart';
import 'package:poam/services/loginServices/Objects/SignInObject.dart';

class LoginService {

  late FirebaseAuth auth;
  late FirebaseApp app;
  late UserCredential userCredential;

  LoginService () {

    ///intialize
    auth = FirebaseAuth.instance;
  }

  Future<RegistrationObject> registration(String email, String password) async {

    //Create RegistrationObject which is the Output
    RegistrationObject registrationObject = RegistrationObject();

    try {

      //Firebase Registration
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {

      if (e.code == 'weak-password') {
        registrationObject.isWeakPassword = true;
      } else if (e.code == 'email-already-in-use') {
        registrationObject.isEmailAreadyUsed = true;
      }
    }

    return registrationObject;

  }

  Future<SignInObject> signIn(String email, String password) async {

    //Create SignInObject which is the Output
    SignInObject signInObject = SignInObject();

    try {

      //Firebase SignIn
      userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {
        signInObject.userNotFound = true;
      } else if (e.code == 'wrong-password') {
        signInObject.wrongPassword = true;
      }
    }

    return signInObject;

  }

}