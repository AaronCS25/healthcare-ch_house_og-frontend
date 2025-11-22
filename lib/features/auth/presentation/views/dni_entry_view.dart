import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rimac_app/features/auth/auth.dart';
import 'package:rimac_app/features/shared/shared.dart';

class DniEntryView extends StatelessWidget {
  const DniEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: const Scaffold(body: _DniEntryViewBody()),
    );
  }
}

class _DniEntryViewBody extends StatelessWidget {
  const _DniEntryViewBody();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final double headerHeight = size.height * 0.45;

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
                      'https://images.pexels.com/photos/6668312/pexels-photo-6668312.jpeg',
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
                        "¡Qué gusto verte en la App RIMAC!",
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
                            "Ingresa tu documento",
                            style: textTheme.titleSmall,
                          ),
                          const SizedBox(height: 24),
                          IdentityDocumentInput(
                            selectedType: state.docType,
                            onDocumentTypeChanged: context
                                .read<LoginCubit>()
                                .onDocTypeChanged,
                            onDocumentNumberChanged: context
                                .read<LoginCubit>()
                                .onDocNumberChanged,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton(
                              onPressed: state.checkingIdentity
                                  ? null
                                  : () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      context
                                          .read<LoginCubit>()
                                          .onIdentitySubmitted();
                                    },
                              child: const Text("Continuar"),
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

class IdentityDocumentInput extends StatelessWidget {
  final IdentityDocumentType? selectedType;
  final Function(IdentityDocumentType?)? onDocumentTypeChanged;
  final Function(String)? onDocumentNumberChanged;
  final String? errorText;
  final bool enabled;

  const IdentityDocumentInput({
    super.key,
    this.selectedType,
    this.onDocumentTypeChanged,
    this.onDocumentNumberChanged,
    this.errorText,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomTextFormField(
      hintText: 'Nro. de documento',
      isEnabled: enabled,
      errorMessage: errorText,
      keyboardType: selectedType == IdentityDocumentType.dni
          ? TextInputType.number
          : TextInputType.text,
      onChanged: onDocumentNumberChanged,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownMenu<IdentityDocumentType>(
              initialSelection: selectedType,
              onSelected: onDocumentTypeChanged,
              width: 140,
              enabled: enabled,

              inputDecorationTheme: const InputDecorationTheme(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),

              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: enabled
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.38),
              ),

              trailingIcon: Icon(
                Icons.expand_more,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),

              selectedTrailingIcon: Icon(
                Icons.expand_less,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),

              dropdownMenuEntries: IdentityDocumentType.values.map((tipo) {
                return DropdownMenuEntry<IdentityDocumentType>(
                  value: tipo,
                  label: tipo.alias,
                  style: MenuItemButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                );
              }).toList(),
            ),

            Container(
              width: 1,
              height: 24,
              color: colorScheme.outline.withValues(alpha: 0.5),
              margin: const EdgeInsets.only(right: 12, left: 4),
            ),
          ],
        ),
      ),
    );
  }
}
