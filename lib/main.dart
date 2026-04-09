import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/app_theme.dart';
import 'package:task_manager/di/injection_container.dart' as di;
import 'package:task_manager/features/Auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager/features/Auth/presentation/bloc/auth_event.dart';
import 'package:task_manager/features/Auth/presentation/bloc/auth_state.dart';
import 'package:task_manager/features/Auth/presentation/bloc/login_bloc.dart';
import 'package:task_manager/features/Auth/presentation/screens/login_screen.dart';
import 'package:task_manager/features/Auth/presentation/screens/splash_screen.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/bloc/task_event.dart';
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
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(const AuthEvent.appStarted()),
        ),
        BlocProvider<LoginBloc>(
          create: (_) => di.sl<LoginBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SplashScreen(),
              unauthenticated: () => const LoginScreen(),
              authenticated: () => BlocProvider<TaskBloc>(
                // Create a fresh TaskBloc and immediately load tasks from the API.
                create: (_) =>
                    di.sl<TaskBloc>()..add(const LoadTasksEvent()),
                child: const TaskListScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
