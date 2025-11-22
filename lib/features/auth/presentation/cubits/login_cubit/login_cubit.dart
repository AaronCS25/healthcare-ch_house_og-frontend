import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rimac_app/features/auth/auth.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthCubit authCubit;

  LoginCubit({required this.authCubit}) : super(const LoginState());

  void onDocTypeChanged(IdentityDocumentType? docType) {
    emit(state.copyWith(docType: docType));
  }

  void onDocNumberChanged(String docNumber) {
    emit(state.copyWith(docNumber: docNumber));
  }

  void onPasswordChanged(String password) {
    emit(state.copyWith(password: password));
  }

  Future<void> onIdentitySubmitted() async {
    if (state.checkingIdentity) return;
    emit(
      state.copyWith(status: LoginStatus.checkingIdentity, errorMessage: ''),
    );

    try {
      await Future.delayed(const Duration(seconds: 2));

      // TODO: CALL API TO CHECK IDENTITY DOCUMENT
      // final haveInsurance = ...;

      if (isClosed) return;
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
      await Future.delayed(const Duration(seconds: 2));

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
}
