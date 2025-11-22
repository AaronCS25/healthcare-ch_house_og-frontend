import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rimac_app/features/auth/auth.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthCubit authCubit;
  final AuthRepository repository;

  LoginCubit({required this.authCubit, required this.repository})
    : super(const LoginState());

  void onDocTypeChanged(IdentityDocumentType? docType) {
    emit(state.copyWith(docType: docType));
  }

  void onDocNumberChanged(String docNumber) {
    emit(state.copyWith(docNumber: docNumber));
  }

  void onPasswordChanged(String password) {
    emit(state.copyWith(password: password));
  }

  void togglePasswordObscured() {
    emit(state.copyWith(passwordObscured: !state.passwordObscured));
  }

  Future<void> onIdentitySubmitted() async {
    if (state.checkingIdentity) return;
    emit(
      state.copyWith(status: LoginStatus.checkingIdentity, errorMessage: ''),
    );

    try {
      final haveInsurance = await repository.validateIdentityDocument(
        state.docType,
        state.docNumber,
      );
      if (isClosed) return;

      if (!haveInsurance) {
        emit(
          state.copyWith(
            status: LoginStatus.identityNotVerified,
            errorMessage: '',
          ),
        );
        return;
      }

      emit(
        state.copyWith(status: LoginStatus.identityVerified, errorMessage: ''),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> onPasswordSubmitted() async {
    if (state.isSubmitting) return;
    emit(state.copyWith(status: LoginStatus.submitting, errorMessage: ''));
    try {
      await authCubit.login(state.docNumber, state.password);

      if (isClosed) return;
      emit(state.copyWith(status: LoginStatus.success, errorMessage: ''));
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: LoginStatus.initial, errorMessage: ''));
  }
}
