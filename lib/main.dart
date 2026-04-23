import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_theme.dart';
import 'package:task_manager/di/injection_container.dart' as di;
import 'package:task_manager/features/Auth/presentation/cubit/auth_state.dart';
import 'package:task_manager/features/Auth/presentation/cubit/auth_cubit.dart';
import 'package:task_manager/features/Auth/presentation/cubit/login_cubit.dart';
import 'package:task_manager/features/Auth/presentation/screens/login_screen.dart';
import 'package:task_manager/features/Auth/presentation/screens/splash_screen.dart';
import 'package:task_manager/features/task/presentation/cubit/task_cubit.dart';
import 'package:task_manager/features/task/presentation/screens/task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => di.sl<AuthCubit>()..appStarted(),
        ),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial) return const SplashScreen();
            if (state is AuthAuthenticated) {
              return BlocProvider<TaskCubit>(
                create: (_) => di.sl<TaskCubit>()..loadTasks(),
                child: const TaskListScreen(),
              );
            }
            return BlocProvider<LoginCubit>(
              create: (_) => di.sl<LoginCubit>(),
              child: const LoginScreen(),
            );
          },
        ),
      ),
    );
  }
}
