class AppUserModel {
  String iam;
  String tokenId;
  String phone;
  String email;
  String password;
  String accessToken;
  String remoteCode;
  DateTime accessExpireTime;
  DateTime authExpireTime;

  AppUserModel({
    required this.iam,
    required this.tokenId,
    required this.email,
    required this.phone,
    required this.remoteCode,
    required this.password,
    required this.accessToken,
    required this.accessExpireTime,
    required this.authExpireTime,
  });

  bool get isValid =>
      accessToken.isNotEmpty && DateTime.now().isBefore(accessExpireTime);

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      iam: json['iam'],
      tokenId: json['tokenId'],
      email: json['email'],
      phone: json['phone'],
      remoteCode: json["remoteCode"],
      password: json['password'],
      accessToken: json['accessToken'],
      accessExpireTime: DateTime.parse(json['accessExpireTime']),
      authExpireTime: DateTime.parse(json['authExpireTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iam': iam,
      'remoteCode': remoteCode,
      'tokenId': tokenId,
      'email': email,
      'password': password,
      'phone': phone,
      'accessToken': accessToken,
      'accessExpireTime': accessExpireTime.toIso8601String(),
      'authExpireTime': authExpireTime.toIso8601String(),
    };
  }
}
