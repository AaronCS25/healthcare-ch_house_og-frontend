import 'package:dio/dio.dart';

import 'package:rimac_app/config/config.dart';
import 'package:rimac_app/features/auth/auth.dart';
import 'package:rimac_app/features/shared/shared.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final dio = Dio(BaseOptions(baseUrl: '${Environment.apiUrl}/auth'));

  @override
  Future<AuthEntity> checkAuthStatus(String token) async {
    try {
      final response = await dio.post(
        '/refresh',
        data: {'refresh_token': token},
      );
      final authModel = RefreshResponseModel.fromJson(response.data);
      final authEntity = AuthMapper.fromRefreshResponseModel(authModel);
      return authEntity;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data["detail"] ?? 'Token no valido', 401);
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Tiempo de espera agotado', 503);
      }
      throw Exception(
        'Error al verificar el estado de autenticación: ${e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<AuthEntity> login(String username, String password) async {
    try {
      final response = await dio.post(
        '/login',
        data: {'username': username, 'password': password},
      );
      final authModel = LoginResponseModel.fromJson(response.data);
      final authEntity = AuthMapper.fromLoginResponseModel(authModel);
      return authEntity;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          e.response?.data["detail"] ?? 'Credenciales incorrectas',
          401,
        );
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Tiempo de espera agotado', 503);
      }
      throw Exception('Error al iniciar sesión: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<int> signup(SignupParams params) async {
    try {
      final data = AuthMapper.toRegisterRequestModel(params);
      final response = await dio.post('/register', data: data);
      return response.data["id"];
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw CustomError(e.response?.data["detail"] ?? 'Bad request', 401);
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Tiempo de espera agotado', 503);
      }
      throw Exception('Error al registrar usuario: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  @override
  Future<bool> validateIdentityDocument(
    IdentityDocumentType docType,
    String docNumber,
  ) async {
    try {
      final response = await dio.get('/dni/$docNumber/validate');
      return response.data["registered"];
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw CustomError(e.response?.data["detail"] ?? 'Bad request', 401);
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Tiempo de espera agotado', 503);
      }
      throw Exception(
        'Error al validar el documento de identidad: ${e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }
}
