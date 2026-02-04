import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterconf/auth/auth.dart';
import 'package:flutterconf/config/config.dart';
import 'package:flutterconf/favorites/favorites.dart';
import 'package:flutterconf/firebase_options.dart';
import 'package:flutterconf/launchpad/launchpad.dart';
import 'package:flutterconf/profile/cubit/profile_cubit.dart';
import 'package:flutterconf/profile/data/profile_repository.dart';
import 'package:flutterconf/theme/theme.dart';
import 'package:flutterconf/updater/updater.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final temporaryDirectory = kIsWeb
      ? HydratedStorageDirectory.web
      : HydratedStorageDirectory((await getTemporaryDirectory()).path);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: temporaryDirectory,
  );

  if (kDebugMode) await HydratedBloc.storage.clear();
  runApp(
    RepositoryProvider(
      create: (_) => AuthRepository(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => ShorebirdUpdater()),
        RepositoryProvider(create: (_) => ProfileRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => FavoritesCubit()),
          BlocProvider(
            create: (context) => UpdaterCubit(
              updater: context.read<ShorebirdUpdater>(),
            )..init(),
          ),
          BlocProvider(
            create: (context) => ProfileCubit(
              profileRepository: context.read<ProfileRepository>(),
              authRepository: context.read<AuthRepository>(),
            ),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select(
      (ThemeCubit cubit) => cubit.state.toThemeMode(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthError():
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            case AuthConflict():
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Account Already Exists'),
                  content: Text(
                    'An account already exists with ${state.email}. '
                    'Please sign in with your original provider.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            default:
              break;
          }
          if (state is Authenticated && FeatureFlags.isProfileEnabled) {
            context.read<ProfileCubit>().loadProfile();
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) => switch (state) {
            Authenticated() ||
            Guest() => const UpdateListener(child: LaunchpadPage()),
            AuthLoading() => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            Unauthenticated() ||
            AuthError() ||
            AuthConflict() => const LoginPage(),
          },
        ),
      ),
    );
  }
}

extension on ThemeState {
  ThemeMode toThemeMode() {
    return this == ThemeState.dark ? ThemeMode.dark : ThemeMode.light;
  }
}
