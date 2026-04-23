import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auth
import 'package:task_manager/features/Auth/data/datasources/auth_local_data_source.dart';
import 'package:task_manager/features/Auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_manager/features/Auth/data/repositories/auth_repository_impl.dart';
import 'package:task_manager/features/Auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/Auth/domain/usecases/login_usecase.dart';
import 'package:task_manager/features/Auth/domain/usecases/register_usecase.dart';
import 'package:task_manager/features/Auth/presentation/cubit/auth_cubit.dart';
import 'package:task_manager/features/Auth/presentation/cubit/login_cubit.dart';
import 'package:task_manager/features/Auth/presentation/cubit/register_cubit.dart';

// Task
import 'package:task_manager/features/task/data/datasources/task_remote_data_source.dart';
import 'package:task_manager/features/task/data/repositories/task_repository_impl.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';
import 'package:task_manager/features/task/domain/usecases/get_task_by_id_usecase.dart';
import 'package:task_manager/features/task/presentation/cubit/task_cubit.dart';

final sl = GetIt.instance;


Future<void> init() async {
  // ── Auth ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => AuthCubit(authRepository: sl()));
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));

  sl.registerFactory(() => RegisterCubit(registerUseCase: sl()));

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));
  sl.registerLazySingleton(() => AuthLocalDataSource(sl()));

  // ── Task ──────────────────────────────────────────────────────────────────
  sl.registerFactory(() => TaskCubit(repository: sl()));

  sl.registerLazySingleton(() => GetTaskByIdUseCase(sl()));

  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => TaskRemoteDataSource(sl(), sl()));

  // ── Core & External ───────────────────────────────────────────────────────
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 100),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
      ),
    );
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = sl<AuthLocalDataSource>().getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await sl<AuthLocalDataSource>().deleteToken();
          sl<AuthCubit>().loggedOut();
        }
        handler.next(error);
      },
    ));
    // dio.interceptors.add(
    //   LogInterceptor(
    //   requestBody: true,
    //   responseBody: true,
    //   error: true,
    // ));
    return dio;
  });
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
}
