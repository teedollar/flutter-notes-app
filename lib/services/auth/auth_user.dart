import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable //this class or any subclass of it cannot change
class AuthUser {
  final String? email;
  final bool isEmailVerified;
  //this is a constructor
  //const AuthUser(this.isEmailVerified);  //Canbe declared like this
  const AuthUser({
    required this.email,
    required this.isEmailVerified,
  }); //declared like this to make it required
  //A factory constructor/initializer
  //Note - .fromFirebase is just a function defined by us. It is not a
  //standard function from firebase. Anywhere, we can just call
  //AuthUser.fromFirebase to get the status of user email verification.

  //Also note, a constructor has to be defined before a factory constructor
  factory AuthUser.fromFirebase(User user) => AuthUser(
        email: user.email,
        isEmailVerified: user.emailVerified,
      );
}
