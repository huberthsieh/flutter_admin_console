class UserModel {
  final String id;
  final String username;
  final String displayName;
  final String role;
  final String? token;

  const UserModel({
    required this.id,
    required this.username,
    required this.displayName,
    required this.role,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: '${json['id']}',
        username: json['username'] as String? ?? '',
        displayName: json['displayName'] as String? ?? '',
        role: json['role'] as String? ?? 'user',
        token: json['token'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'displayName': displayName,
        'role': role,
        'token': token,
      };
}
