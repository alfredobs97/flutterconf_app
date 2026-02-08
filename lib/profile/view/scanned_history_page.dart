import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterconf/profile/cubit/scanned_profiles_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ScannedHistoryPage extends StatelessWidget {
  const ScannedHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Scanned Profiles',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<ScannedProfilesCubit, ScannedProfilesState>(
              builder: (context, state) {
                if (state is ScannedProfilesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ScannedProfilesLoaded) {
                  if (state.profiles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 64,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No scanned profiles yet',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.profiles.length,
                    itemBuilder: (context, index) {
                      final profile = state.profiles[index];
                      return Dismissible(
                        key: Key(profile.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          context.read<ScannedProfilesCubit>().removeProfile(
                            profile.id,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile removed')),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(profile.displayName[0].toUpperCase()),
                          ),
                          title: Text(profile.displayName),
                          subtitle: Text(
                            'Scanned: ${DateFormat.yMMMd().add_jm().format(profile.scannedAt)}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // Close the modal before navigating
                            Navigator.pop(context);
                            // Navigate to public profile
                            context.push('/profile/${profile.id}');
                          },
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text('Error loading history.'));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  // Close the modal before navigating to scanner
                  Navigator.pop(context);
                  context.push('/scan-qr');
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan New QR Code'),
              ),
            ),
          ),
          // Add safe area for bottom padding (especially for iOS home indicator)
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
