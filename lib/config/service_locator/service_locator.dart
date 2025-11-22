import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:rimac_app/config/config.dart';
import 'package:rimac_app/features/auth/auth.dart';
import 'package:rimac_app/features/chat/chat.dart';
import 'package:rimac_app/features/shared/shared.dart';

class ServiceLocator {
  static final _getIt = GetIt.instance;

  static T get<T extends Object>() => _getIt.get<T>();

  static Future<void> init() async {
    _getIt.registerLazySingleton<DictStorageService>(
      () => DictStorageServiceImpl(),
    );

    _getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(AuthDatasourceImpl()),
    );

    _getIt.registerSingleton<AuthCubit>(
      AuthCubit(
        authRepository: get<AuthRepository>(),
        dictStorageService: get<DictStorageService>(),
      )..checkAuthStatus(),
    );

    _getIt.registerLazySingleton<Dio>(() {
      final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));
      dio.interceptors.add(
        AuthInterceptor(dio: dio, authCubit: get<AuthCubit>()),
      );
      return dio;
    });

    _getIt.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(ChatDatasourceImpl(dio: get<Dio>())),
    );
  }
}
