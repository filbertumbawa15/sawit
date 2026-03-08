import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sawit/features/kontrol_operasional/data/datasources/kontrol_operasional_data_source.dart';
import 'package:sawit/features/kontrol_operasional/presentation/bloc/kontroloperasional_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/data/datasources/auth_data_source.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() {
    final options = BaseOptions(
      baseUrl: 'http://10.0.2.2:8050',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    final dio = Dio(options);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = sl<SharedPreferences>().getString('auth_token');

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          //Control refresh token in here
          return handler.next(e);
        },
      ),
    );

    return dio;
  });

  sl.registerLazySingleton(() => AuthDataSource(dio: sl(), prefs: sl()));

  sl.registerFactory(() => AuthBloc(dataSource: sl()));

  sl.registerLazySingleton(
      () => KontrolOperasionalDataSource(dio: sl()));

  sl.registerFactory(() => KontrolOperasionalBloc(dataSource: sl()));
}
