import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String email;
  final String fullName;
  final String userType;
  final DateTime createdAt;
  
  const UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.userType,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'userType': userType,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      userType: map['userType'] ?? 'user',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  @override
  List<Object> get props => [uid, email, fullName, userType, createdAt];
}