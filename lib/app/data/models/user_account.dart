class UserAccount {
  final String account;
  final String name;
  final String? email;
  final String employeeId;
  final bool enabled; // true=啟用, false=待驗證
  final String? createdAt;
  final String? updatedAt;

  const UserAccount({
    required this.account,
    required this.name,
    this.email,
    required this.employeeId,
    required this.enabled,
    this.createdAt,
    this.updatedAt,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        account: json['account'] as String? ?? '',
        name: json['name'] as String? ?? '',
        email: json['email'] as String?,
        employeeId: json['employeeId'] as String? ?? '',
        enabled: (json['status'] as String?) == '啟用',
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?,
      );
}
