import 'package:ev_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth auth;

  AuthRemoteDataSourceImpl(this.auth, this.googleSignIn);
  @override
  Future<UserCredential> signInWithEmail(String emailAddress, String password) {
    return auth.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(code: 'sign_in_canceled');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    print('compelete google sign in');
    return await auth.signInWithCredential(credential);
  }

  @override
  Future<UserCredential> createWithEmail(String emailAddress, String password) {
    return auth.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  }
}
