import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> signInWithEmail(String email, String password);
  Future<UserCredential> createWithEmail(String email, String password);
}
