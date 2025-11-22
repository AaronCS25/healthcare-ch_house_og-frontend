import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rimac_app/features/auth/auth.dart';

class AppRouterNotifier extends ChangeNotifier {
  final AuthCubit authCubit;
  late AuthStatus _currentStatus;
  StreamSubscription? _authSubscription;

  AppRouterNotifier(this.authCubit) {
    _currentStatus = authCubit.state.status;
    _authSubscription = authCubit.stream.listen((authState) {
      if (authState.status != _currentStatus) {
        _currentStatus = authState.status;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
