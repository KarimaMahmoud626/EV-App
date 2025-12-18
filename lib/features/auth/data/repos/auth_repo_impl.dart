import 'package:dartz/dartz.dart';
import 'package:ev_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ev_app/features/auth/data/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource dataSource;

  AuthRepoImpl({required this.dataSource});

  @override
  Future<Either<Exception, UserCredential>> loginWithGoogle() async {
    // Trigger the authentication flow
    print('entering google sign in');
    try {
      final user = await dataSource.signInWithGoogle();
      return Right(user);
    } catch (e) {
      print('google error');
      print(e);
      return Left(Exception('Something went wrong while google sign in'));
    }
  }

  Future<Either<Exception, UserCredential>> createUserEmailAndPassword(
    String emailAddress,
    String password,
  ) async {
    // Trigger the authentication flow
    print('entering email sign in');
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
      return Right(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        await loginWithEmailAndPassword(emailAddress, password);
      }
      return Left(Exception('FirebaseAuthException: $e'));
    } catch (e) {
      return Left(Exception('Something went wrong while sign in'));
    }
  }

  Future<Either<Exception, UserCredential>> loginWithEmailAndPassword(
    String emailAddress,
    String password,
  ) async {
    // Trigger the authentication flow
    print('entering email sign in');
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return Right(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return Left(Exception('FirebaseAuthException: $e'));
    } catch (e) {
      return Left(Exception('Something went wrong while sign in'));
    }
  }

  @override
  Future<Either<Exception, UserCredential>> signInWithEmail(
    String email,
    String password,
  ) {
    // TODO: implement signInWithEmail
    throw UnimplementedError();
  }
}
