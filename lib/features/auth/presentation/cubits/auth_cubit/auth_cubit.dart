import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rimac_app/features/auth/auth.dart';
import 'package:rimac_app/features/shared/shared.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final DictStorageService dictStorageService;

  AuthCubit({required this.authRepository, required this.dictStorageService})
    : super(const AuthState());

  Future<void> checkAuthStatus() async {
    final refreshToken = await dictStorageService.get<String>('refresh_token');
    if (refreshToken == null) return logout();

    try {
      final auth = await authRepository.checkAuthStatus(refreshToken);
      await _setLoggedUser(auth);
    } catch (e) {
      logout();
    }
  }

  Future<void> login(String username, String password) async {
    try {
      final auth = await authRepository.login(username, password);
      await _setLoggedUser(auth);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Login - An unexpected error occurred');
    }
  }

  Future<void> signup(SignupParams params) async {
    try {
      await authRepository.signup(params);
    } on CustomError catch (e) {
      logout(e.message);
      throw CustomError(e.message, e.errorCode);
    } catch (e) {
      logout('Signup - An unexpected error occurred');
      throw Exception('Signup - An unexpected error occurred');
    }
  }

  Future<void> _setLoggedUser(AuthEntity auth) async {
    await dictStorageService.save<String>('access_token', auth.accessToken);
    await dictStorageService.save<String>('refresh_token', auth.refreshToken);

    emit(
      state.copyWith(
        auth: auth,
        status: AuthStatus.authenticated,
        errorMessage: '',
      ),
    );
  }

  Future<void> logout([String? errorMessage]) async {
    await dictStorageService.delete('access_token');
    await dictStorageService.delete('refresh_token');

    emit(
      state.copyWith(
        auth: null,
        status: AuthStatus.unauthenticated,
        errorMessage: errorMessage,
      ),
    );
  }

  void reset() {
    emit(const AuthState());
  }
}
