part of 'auth_cubit.dart';

enum AuthStatus { checking, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthEntity? auth;
  final AuthStatus status;
  final String errorMessage;

  const AuthState({
    this.auth,
    this.status = AuthStatus.checking,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [auth, status, errorMessage];

  AuthState copyWith({
    AuthEntity? auth,
    AuthStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
      auth: auth ?? this.auth,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
