import 'package:rimac_app/features/auth/auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  const AuthRepositoryImpl(this.datasource);

  @override
  Future<AuthEntity> checkAuthStatus(String token) {
    return datasource.checkAuthStatus(token);
  }

  @override
  Future<AuthEntity> login(String username, String password) {
    return datasource.login(username, password);
  }

  @override
  Future<int> signup(SignupParams params) {
    return datasource.signup(params);
  }

  @override
  Future<bool> validateIdentityDocument(
    IdentityDocumentType docType,
    String docNumber,
  ) {
    return datasource.validateIdentityDocument(docType, docNumber);
  }
}
