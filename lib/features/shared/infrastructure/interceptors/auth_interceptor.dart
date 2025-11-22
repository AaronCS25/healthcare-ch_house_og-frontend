import 'package:dio/dio.dart';
import 'package:rimac_app/features/auth/auth.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  final AuthCubit authCubit;

  AuthInterceptor({required this.dio, required this.authCubit});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        await authCubit.checkAuthStatus();

        final newAccessToken = authCubit.state.auth?.accessToken;

        if (newAccessToken != null) {
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          final response = await dio.fetch(options);
          return handler.resolve(response);
        }

        return handler.reject(err);
      } on DioException catch (e) {
        return handler.reject(e);
      }
    }

    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = authCubit.state.auth?.accessToken;
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }
}
