import 'package:rimac_app/features/auth/auth.dart';

class AuthMapper {
  static AuthEntity fromLoginResponseModel(LoginResponseModel model) {
    return AuthEntity(
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
      tokenType: model.tokenType,
    );
  }

  static AuthEntity fromRefreshResponseModel(RefreshResponseModel model) {
    return AuthEntity(
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
      tokenType: model.tokenType,
    );
  }

  static LoginRequestModel toLoginRequestModel(
    String username,
    String password,
  ) {
    return LoginRequestModel(username: username, password: password);
  }

  static RegisterRequestModel toRegisterRequestModel(SignupParams params) {
    return RegisterRequestModel(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      password: params.password,
      birthday: params.birthday,
    );
  }
}
