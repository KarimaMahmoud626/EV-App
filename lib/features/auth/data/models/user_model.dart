import 'package:equatable/equatable.dart';

const String kName = 'name';
const String kEmail = 'email';
const String kPhotoUrl = 'photoUrl';

/// User model representing authenticated user data.
///
/// This model is used to store user information in Firestore.
/// Note: Passwords are NEVER stored - Firebase handles authentication tokens.
class UserModel extends Equatable {
  final String? name;
  final String email;
  final String? photoUrl;

  const UserModel({required this.email, this.name, this.photoUrl});

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      email: data[kEmail] as String,
      name: (data[kName] as String?) ?? '',
      photoUrl: (data[kPhotoUrl] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {kName: name, kEmail: email, kPhotoUrl: photoUrl};
  }

  @override
  List<Object?> get props => [name, email, photoUrl];
}
