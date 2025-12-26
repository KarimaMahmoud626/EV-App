import 'package:dartz/dartz.dart';
import 'package:ev_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ev_app/features/auth/data/models/user_model.dart';
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
      await dataSource.saveUserData(
        UserModel(email: user.user!.email!, name: user.user!.displayName),
      );

      return Right(user);
    } catch (e) {
      print('google error');
      print(e);
      return Left(Exception('Something went wrong while google sign in'));
    }
  }

  @override
  Future<Either<Exception, UserCredential>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final user = await dataSource.createWithEmail(email, password);
      await dataSource.saveUserData(
        UserModel(email: user.user!.email!, name: user.user!.displayName),
      );

      return Right(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        final user = await dataSource.signInWithEmail(email, password);
        await dataSource.saveUserData(
          UserModel(email: user.user!.email!, name: user.user!.displayName),
        );
        return Right(user);
      }
      return Left(Exception('FirebaseAuthException: $e'));
    } catch (e) {
      return Left(Exception(e));
    }
  }
}
