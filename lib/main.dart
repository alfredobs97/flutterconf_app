import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterconf/auth/auth.dart';
import 'package:flutterconf/config/config.dart';
import 'package:flutterconf/favorites/favorites.dart';
import 'package:flutterconf/firebase_options.dart';
import 'package:flutterconf/profile/cubit/profile_cubit.dart';
import 'package:flutterconf/profile/cubit/scanned_profiles_cubit.dart';
import 'package:flutterconf/profile/data/profile_repository.dart';
import 'package:flutterconf/profile/data/scanned_profiles_repository.dart';
import 'package:flutterconf/config/router.dart';
import 'package:flutterconf/theme/theme.dart';
import 'package:flutterconf/updater/updater.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

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
        RepositoryProvider(create: (_) => ScannedProfilesRepository()),
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
          BlocProvider(
            create: (context) => ScannedProfilesCubit(
              repository: context.read<ScannedProfilesRepository>(),
            )..loadProfiles(),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(context.read<AuthCubit>());
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select(
      (ThemeCubit cubit) => cubit.state.toThemeMode(),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: _router,
      builder: (context, child) {
        return BlocListener<AuthCubit, AuthState>(
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
          child: child,
        );
      },
    );
  }
}

extension on ThemeState {
  ThemeMode toThemeMode() {
    return this == ThemeState.dark ? ThemeMode.dark : ThemeMode.light;
  }
}
