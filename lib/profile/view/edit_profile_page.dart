import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterconf/auth/auth.dart';
import 'package:flutterconf/profile/cubit/profile_cubit.dart';
import 'package:flutterconf/profile/models/user_profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const EditProfilePage());
  }

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayNameController;
  late TextEditingController _jobRoleController;
  late TextEditingController _companyController;
  late TextEditingController _linkedinController;
  late TextEditingController _twitterController;
  late TextEditingController _youtubeController;
  late TextEditingController _mediumController;
  late TextEditingController _bioController;
  WorkStatus _workStatus = WorkStatus.none;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    final user = state is ProfileLoaded ? state.profile : null;
    _displayNameController = TextEditingController(text: user?.displayName);
    _jobRoleController = TextEditingController(text: user?.jobRole);
    _companyController = TextEditingController(text: user?.company);
    _linkedinController = TextEditingController(text: user?.linkedin);
    _twitterController = TextEditingController(text: user?.twitter);
    _youtubeController = TextEditingController(text: user?.youtube);
    _mediumController = TextEditingController(text: user?.medium);
    _bioController = TextEditingController(text: user?.bio);
    _workStatus = user?.workStatus ?? WorkStatus.none;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _jobRoleController.dispose();
    _companyController.dispose();
    _linkedinController.dispose();
    _twitterController.dispose();
    _youtubeController.dispose();
    _mediumController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final profileCubit = context.read<ProfileCubit>();
      final state = profileCubit.state;
      final currentUser = state is ProfileLoaded ? state.profile : null;

      if (currentUser != null) {
        final updatedProfile = currentUser.copyWith(
          displayName: _displayNameController.text,
          jobRole: _jobRoleController.text,
          company: _companyController.text,
          linkedin: _linkedinController.text,
          twitter: _twitterController.text,
          youtube: _youtubeController.text,
          medium: _mediumController.text,
          bio: _bioController.text,
          workStatus: _workStatus,
        );
        profileCubit.updateProfile(updatedProfile);
        Navigator.of(context).pop();
      } else {
        final authState = context.read<AuthCubit>().state;
        if (authState is Authenticated) {
          final newProfile = UserProfile(
            id: authState.user.uid,
            email: authState.user.email ?? '',
            displayName: _displayNameController.text,
            jobRole: _jobRoleController.text,
            company: _companyController.text,
            linkedin: _linkedinController.text,
            twitter: _twitterController.text,
            youtube: _youtubeController.text,
            medium: _mediumController.text,
            bio: _bioController.text,
            workStatus: _workStatus,
          );
          profileCubit.updateProfile(newProfile);
          Navigator.of(context).pop();
        }
      }
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final photoUrl = authState is Authenticated
        ? authState.user.photoURL
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update profile')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Hero(
                    tag: 'profile-image',
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: photoUrl != null
                          ? NetworkImage(photoUrl)
                          : null,
                      child: photoUrl == null
                          ? const Icon(Icons.person, size: 60)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionHeader('Personal Information'),
                TextFormField(
                  controller: _displayNameController,
                  decoration: _getInputDecoration('Display Name', Icons.badge),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your name'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _jobRoleController,
                  decoration: _getInputDecoration('Job Role', Icons.work),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your job role'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _companyController,
                  decoration: _getInputDecoration('Company', Icons.business),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter your company'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  decoration: _getInputDecoration('Bio', Icons.description),
                  maxLines: 3,
                ),
                _buildSectionHeader('Social Media'),
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: const Text('Social Media Links'),
                    leading: const Icon(Icons.share),
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
                    tilePadding: EdgeInsets.zero,
                    children: [
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _linkedinController,
                        decoration: _getInputDecoration(
                          'LinkedIn URL',
                          FontAwesomeIcons.linkedin,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _twitterController,
                        decoration: _getInputDecoration(
                          'Twitter URL',
                          FontAwesomeIcons.twitter,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _youtubeController,
                        decoration: _getInputDecoration(
                          'YouTube URL',
                          FontAwesomeIcons.youtube,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _mediumController,
                        decoration: _getInputDecoration(
                          'Medium URL',
                          FontAwesomeIcons.medium,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                _buildSectionHeader('Availability'),
                Text(
                  'Do you want to show that you are open to work or do you '
                  'want to hire someone?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<WorkStatus>(
                  initialValue: _workStatus,
                  decoration: _getInputDecoration('Work Status', Icons.info),
                  items: const [
                    DropdownMenuItem(
                      value: WorkStatus.none,
                      child: Text('Not Specified'),
                    ),
                    DropdownMenuItem(
                      value: WorkStatus.hiring,
                      child: Text('Hiring'),
                    ),
                    DropdownMenuItem(
                      value: WorkStatus.openToWork,
                      child: Text('Open to Work'),
                    ),
                    DropdownMenuItem(
                      value: WorkStatus.busy,
                      child: Text('Busy (Not looking)'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _workStatus = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Profile'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
