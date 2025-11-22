import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rimac_app/config/config.dart';
import 'package:rimac_app/features/auth/auth.dart';
import 'package:rimac_app/features/shared/shared.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        authCubit: ServiceLocator.get<AuthCubit>(),
        repository: ServiceLocator.get<AuthRepository>(),
      ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.unauthenticated &&
                  state.errorMessage.isNotEmpty) {
                SnackBarHelper.showError(context, message: state.errorMessage);
                context.read<AuthCubit>().reset();
              }

              if (state.status == AuthStatus.authenticated) {
                SnackBarHelper.showSuccess(
                  context,
                  message: 'Inicio de sesión exitoso!',
                );
              }
            },
          ),
          BlocListener<LoginCubit, LoginState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.identityNotVerified) {
                HelpDialog.show(
                  context,
                  title: 'Estamos aquí para ayudarte',
                  message:
                      'Verifica tu documento, si el error persiste llámanos al (01) 411-1111.',
                );
                context.read<LoginCubit>().resetStatus();
              }
            },
          ),
        ],
        child: const _LoginScreenContent(),
      ),
    );
  }
}

class _LoginScreenContent extends StatelessWidget {
  const _LoginScreenContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        if (state.identityVerified || state.isSubmitting || state.isSuccess) {
          return const PasswordEntryView();
        }
        return const DniEntryView();
      },
    );
  }
}
