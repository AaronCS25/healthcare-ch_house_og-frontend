part of 'login_cubit.dart';

enum LoginStatus {
  initial,
  checkingIdentity,
  identityVerified,
  identityNotVerified,
  submitting,
  success,
  failure,
}

class LoginState extends Equatable {
  final LoginStatus status;
  final IdentityDocumentType docType;
  final String docNumber;
  final String password;
  final bool passwordObscured;
  final String errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.docType = IdentityDocumentType.dni,
    this.docNumber = '',
    this.password = '',
    this.passwordObscured = true,
    this.errorMessage = '',
  });

  bool get checkingIdentity => status == LoginStatus.checkingIdentity;
  bool get identityVerified => status == LoginStatus.identityVerified;
  bool get identityNotVerified => status == LoginStatus.identityNotVerified;

  bool get isSubmitting => status == LoginStatus.submitting;
  bool get isSuccess => status == LoginStatus.success;
  bool get isFailure => status == LoginStatus.failure;

  @override
  List<Object> get props => [
    status,
    docType,
    docNumber,
    password,
    passwordObscured,
    errorMessage,
  ];

  LoginState copyWith({
    LoginStatus? status,
    IdentityDocumentType? docType,
    String? docNumber,
    String? password,
    bool? passwordObscured,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      docType: docType ?? this.docType,
      docNumber: docNumber ?? this.docNumber,
      password: password ?? this.password,
      passwordObscured: passwordObscured ?? this.passwordObscured,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
