import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rimac_app/features/auth/auth.dart';
import 'package:rimac_app/features/shared/shared.dart';

class PasswordEntryView extends StatelessWidget {
  const PasswordEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: const Scaffold(body: _PasswordEntryViewBody()),
    );
  }
}

class _PasswordEntryViewBody extends StatelessWidget {
  const _PasswordEntryViewBody();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final double headerHeight = size.height * 0.48;

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: headerHeight,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.pexels.com/photos/34794806/pexels-photo-34794806.jpeg',
                    ),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Una nueva forma de usar tu seguro",
                        textAlign: TextAlign.center,
                        style: textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: headerHeight - 30),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: size.height - (headerHeight - 30),
                      ),
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "Ingresa tu contraseña",
                            style: textTheme.titleSmall,
                          ),
                          const SizedBox(height: 24),
                          CustomTextFormField(
                            hintText: "Contraseña",
                            obscureText: state.passwordObscured,
                            onChanged: context
                                .read<LoginCubit>()
                                .onPasswordChanged,
                            suffixIcon: IconButton(
                              onPressed: context
                                  .read<LoginCubit>()
                                  .togglePasswordObscured,
                              icon: state.passwordObscured
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: () {},
                            child: const Text("¿Olvidaste tu contraseña?"),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton(
                              onPressed: state.isSubmitting
                                  ? null
                                  : () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      context
                                          .read<LoginCubit>()
                                          .onPasswordSubmitted();
                                    },
                              child: const Text("Iniciar Sesión"),
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Divider(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
