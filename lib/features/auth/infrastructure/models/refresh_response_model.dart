class RefreshResponseModel {
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  RefreshResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  factory RefreshResponseModel.fromJson(Map<String, dynamic> json) =>
      RefreshResponseModel(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        tokenType: json["token_type"],
      );
}
