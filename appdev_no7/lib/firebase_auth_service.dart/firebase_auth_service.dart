import 'package:firebase_auth/firebase_auth.dart';


class FirebaseAuthService {
  
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> Signupemailandpassword(String email,String password) async {

    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch (e) {
      print("Some error occured");
    }
    return null;
  }

  Future<User?> SignInemailandpassword(String email,String password) async {

    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch (e) {
      print("Some error occured");
    }
    return null;
  }
}