class AuthEntity {
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });
}
