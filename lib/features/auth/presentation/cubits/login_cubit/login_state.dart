part of 'login_cubit.dart';

enum LoginStatus {
  initial,
  checkingIdentity,
  identityVerified,
  submitting,
  success,
  failure,
}

class LoginState extends Equatable {
  final LoginStatus status;
  final IdentityDocumentType docType;
  final String docNumber;
  final String password;
  final String errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.docType = IdentityDocumentType.dni,
    this.docNumber = '',
    this.password = '',
    this.errorMessage = '',
  });

  bool get checkingIdentity => status == LoginStatus.checkingIdentity;
  bool get identityVerified => status == LoginStatus.identityVerified;

  bool get isSubmitting => status == LoginStatus.submitting;
  bool get isSuccess => status == LoginStatus.success;
  bool get isFailure => status == LoginStatus.failure;

  @override
  List<Object> get props => [
    status,
    docType,
    docNumber,
    password,
    errorMessage,
  ];

  LoginState copyWith({
    LoginStatus? status,
    IdentityDocumentType? docType,
    String? docNumber,
    String? password,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      docType: docType ?? this.docType,
      docNumber: docNumber ?? this.docNumber,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
