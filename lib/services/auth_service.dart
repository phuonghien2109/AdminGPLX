import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signIn(String email, String password) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
    }).catchError((e) {
      
    });
  }
}
