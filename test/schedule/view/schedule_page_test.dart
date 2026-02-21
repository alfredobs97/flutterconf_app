import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterconf/auth/auth.dart';
import 'package:flutterconf/favorites/favorites.dart';
import 'package:flutterconf/location/location.dart';
import 'package:flutterconf/schedule/schedule.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {}
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late Storage storage;
  late AuthRepository authRepository;

  setUp(() {
    storage = MockStorage();
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    HydratedBloc.storage = storage;

    authRepository = MockAuthRepository();
    when(() => authRepository.user).thenAnswer((_) => const Stream.empty());
  });

  group('SchedulePage', () {
    testWidgets('renders VenueBanner in Day 1', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => FavoritesCubit()),
              BlocProvider(create: (_) => AuthCubit(authRepository: authRepository)),
            ],
            child: const SchedulePage(),
          ),
        ),
      );

      expect(find.text('CONFERENCE VENUE'), findsWidgets);
      expect(find.text('GSEC Málaga'), findsOneWidget);
    });

    testWidgets('renders VenueBanner in Day 2', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => FavoritesCubit()),
              BlocProvider(create: (_) => AuthCubit(authRepository: authRepository)),
            ],
            child: const SchedulePage(),
          ),
        ),
      );

      // Tap on Day 2 tab
      await tester.tap(find.text('Day 2'));
      await tester.pumpAndSettle();

      expect(find.text('CONFERENCE VENUE'), findsWidgets);
      expect(find.text('Innovation Campus - Malaga Terrace'), findsOneWidget);
    });
  });
}
