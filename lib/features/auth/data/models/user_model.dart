import 'package:equatable/equatable.dart';
import 'package:ev_app/core/constants.dart';

class UserModel extends Equatable {
  final String? name;
  final String email;
  final String? password;

  const UserModel({this.name, required this.email, this.password});

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      email: data[kEmail] ?? '',
      name: data[kName] ?? '',
      password: data[kPassword] ?? '',
    );
  }

  toJson() {
    return {kName: name, kEmail: email, kPassword: password};
  }

  @override
  List<Object?> get props => [name, email, password];
}
