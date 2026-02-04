import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterconf/profile/cubit/profile_cubit.dart';
import 'package:flutterconf/profile/models/user_profile.dart';
import 'package:flutterconf/profile/view/edit_profile_page.dart';
import 'package:flutterconf/profile/view/profile_skeleton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const EditProfilePage(),
                      ),
                    );
                  },
                );
              }
              if (state is ProfileNotFound) {
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const EditProfilePage(),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ProfileCubit>().loadProfile(),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const ProfileSkeleton();
            }

            if (state is ProfileError) {
              return Center(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      const Text('Failed to load profile'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<ProfileCubit>().loadProfile(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is ProfileNotFound) {
              return Center(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 80,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Profile Not Found',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "You haven't set up your profile yet. Create one now "
                        'to share your info with other attendees!',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const EditProfilePage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Create Profile'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is ProfileLoaded) {
              final profile = state.profile;
              final hasBio = profile.bio?.isNotEmpty ?? false;
              final hasSocials =
                  (profile.linkedin?.isNotEmpty ?? false) ||
                  (profile.twitter?.isNotEmpty ?? false) ||
                  (profile.youtube?.isNotEmpty ?? false) ||
                  (profile.medium?.isNotEmpty ?? false);
              final jobAndCompany =
                  '${profile.jobRole ?? ''}'
                  '${profile.company != null ? ' at ${profile.company}' : ''}';

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(32),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 50,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Hero(
                              tag: 'profile-image',
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: profile.photoUrl != null
                                      ? NetworkImage(profile.photoUrl!)
                                      : null,
                                  child: profile.photoUrl == null
                                      ? const Icon(Icons.person, size: 50)
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            profile.displayName ?? 'No Name',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (profile.jobRole != null ||
                              profile.company != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              jobAndCompany,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (profile.workStatus != WorkStatus.none) ...[
                      Center(
                        child: Chip(
                          label: Text(
                            profile.workStatus == WorkStatus.hiring
                                ? 'Hiring'
                                : profile.workStatus == WorkStatus.busy
                                ? 'Busy'
                                : 'Looking for work',
                          ),
                          backgroundColor:
                              profile.workStatus == WorkStatus.hiring
                              ? Colors.green.shade100
                              : profile.workStatus == WorkStatus.busy
                              ? Colors.orange.shade100
                              : Colors.blue.shade100,
                          labelStyle: TextStyle(
                            color: profile.workStatus == WorkStatus.hiring
                                ? Colors.green.shade900
                                : profile.workStatus == WorkStatus.busy
                                ? Colors.orange.shade900
                                : Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 16),
                    if (hasBio || hasSocials)
                      Card(
                        elevation: 0,
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hasBio) ...[
                                Text(
                                  'Bio',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  profile.bio!,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                if (hasSocials) const SizedBox(height: 24),
                              ],
                              if (hasSocials) ...[
                                Text(
                                  'Socials',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                if (profile.linkedin != null &&
                                    profile.linkedin!.isNotEmpty)
                                  _buildSocialTile(
                                    context,
                                    icon: FontAwesomeIcons.linkedin,
                                    label: 'LinkedIn',
                                    value: profile.linkedin!,
                                    color: const Color(0xFF0077B5),
                                  ),
                                if (profile.twitter != null &&
                                    profile.twitter!.isNotEmpty)
                                  _buildSocialTile(
                                    context,
                                    icon: FontAwesomeIcons.twitter,
                                    label: 'Twitter',
                                    value: profile.twitter!,
                                    color: const Color(0xFF1DA1F2),
                                  ),
                                if (profile.youtube != null &&
                                    profile.youtube!.isNotEmpty)
                                  _buildSocialTile(
                                    context,
                                    icon: FontAwesomeIcons.youtube,
                                    label: 'YouTube',
                                    value: profile.youtube!,
                                    color: const Color(0xFFFF0000),
                                  ),
                                if (profile.medium != null &&
                                    profile.medium!.isNotEmpty)
                                  _buildSocialTile(
                                    context,
                                    icon: FontAwesomeIcons.medium,
                                    label: 'Medium',
                                    value: profile.medium!,
                                    color: const Color(0xFF000000),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSocialTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 16,
        color: Theme.of(context).colorScheme.outline,
      ),
      onTap: () {
        // TODO(alfredobs97): Handle social link tap
      },
    );
  }
}
