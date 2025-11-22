import 'package:rimac_app/features/auth/auth.dart';

abstract class AuthDatasource {
  Future<AuthEntity> login(String username, String password);

  Future<int> signup(SignupParams params);

  Future<AuthEntity> checkAuthStatus(String token);

  Future<bool> validateIdentityDocument(
    IdentityDocumentType docType,
    String docNumber,
  );
}
