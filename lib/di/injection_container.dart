import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

// Auth
import 'package:task_manager/features/Auth/data/datasources/auth_local_data_source.dart';
import 'package:task_manager/features/Auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_manager/features/Auth/data/repositories/auth_repository_impl.dart';
import 'package:task_manager/features/Auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/Auth/domain/usecases/login_usecase.dart';
import 'package:task_manager/features/Auth/domain/usecases/register_usecase.dart';
import 'package:task_manager/features/Auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager/features/Auth/presentation/bloc/auth_event.dart';
import 'package:task_manager/features/Auth/presentation/bloc/login_bloc.dart';
import 'package:task_manager/features/Auth/presentation/bloc/register_bloc.dart';

// Task
import 'package:task_manager/features/task/data/datasources/task_remote_data_source.dart';
import 'package:task_manager/features/task/data/repositories/task_repository_impl.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';
import 'package:task_manager/features/task/domain/usecases/create_task_usecase.dart';
import 'package:task_manager/features/task/domain/usecases/delete_task_usecase.dart';
import 'package:task_manager/features/task/domain/usecases/get_tasks_usecase.dart';
import 'package:task_manager/features/task/domain/usecases/get_task_by_id_usecase.dart';
import 'package:task_manager/features/task/domain/usecases/update_task_usecase.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/bloc/task_details_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── Auth ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => LoginBloc(loginUseCase: sl()));

  sl.registerFactory(() => RegisterBloc(registerUseCase: sl()));

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));
  sl.registerLazySingleton(() => AuthLocalDataSource(sl()));

  // ── Task ──────────────────────────────────────────────────────────────────
  sl.registerFactory(
    () => TaskBloc(
      getTasksUseCase: sl(),
      createTaskUseCase: sl(),
      updateTaskUseCase: sl(),
      deleteTaskUseCase: sl(),
    ),
  );
  sl.registerFactory(() => TaskDetailsBloc(getTaskByIdUseCase: sl()));

  sl.registerLazySingleton(() => GetTasksUseCase(sl()));
  sl.registerLazySingleton(() => GetTaskByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));

  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => TaskRemoteDataSource(sl()));

  // ── Core & External ───────────────────────────────────────────────────────
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await sl<AuthLocalDataSource>().getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await sl<AuthLocalDataSource>().deleteToken();
          sl<AuthBloc>().add(const AuthEvent.loggedOut());
        }
        handler.next(error);
      },
    ));
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
    return dio;
  });
  sl.registerLazySingleton(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );
}
