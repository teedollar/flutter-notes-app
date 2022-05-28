import 'package:mynotes/services/auth/auth_user.dart';

abstract class AuthProvider {
  //Initialize function
  Future<void> initialize();
  //Get current user
  AuthUser? get currentUser;
  //Login function
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  //Create user function
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  //Logout function
  Future<void> logout();

  //Send Email Verification function
  Future<void> sendEmailVerification();
}
