class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        tokenType: json["token_type"],
      );
}
