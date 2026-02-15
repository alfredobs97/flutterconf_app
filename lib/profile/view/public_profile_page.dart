import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterconf/auth/auth.dart';
import 'package:flutterconf/profile/cubit/profile_cubit.dart';
import 'package:flutterconf/profile/cubit/scanned_profiles_cubit.dart';
import 'package:flutterconf/profile/data/profile_repository.dart';
import 'package:flutterconf/profile/models/scanned_profile.dart';
import 'package:flutterconf/profile/view/profile_skeleton.dart';
import 'package:flutterconf/profile/view/profile_view.dart';
import 'package:go_router/go_router.dart';

class PublicProfilePage extends StatelessWidget {
  const PublicProfilePage({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        profileRepository: context.read<ProfileRepository>(),
        authRepository: context.read<AuthRepository>(),
      )..loadProfile(userId: userId),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            final scannedProfile = ScannedProfile(
              id: state.profile.id,
              displayName: state.profile.displayName ?? 'Unknown',
              scannedAt: DateTime.now(),
            );
            context.read<ScannedProfilesCubit>().addProfile(scannedProfile);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Public Profile'),
            leading: context.canPop()
                ? null
                : IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () => context.go('/'),
                  ),
          ),
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading || state is ProfileInitial) {
                return const ProfileSkeleton();
              }

              if (state is ProfileError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      const Text('Failed to load profile.'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<ProfileCubit>().loadProfile(
                              userId: userId,
                            ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is ProfileNotFound) {
                return const Center(child: Text('Profile not found.'));
              }

              if (state is ProfileLoaded) {
                return ProfileView(
                  profile: state.profile,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
