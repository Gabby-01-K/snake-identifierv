// lib/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/bookmark_list.dart';
import '../services/theme_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();
  final User? _user = FirebaseAuth.instance.currentUser;

  // Use the (default) database
  final _firestore = FirebaseFirestore.instance;

  String? _displayName;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _displayName = _user?.displayName ?? "User";
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _showEditNameDialog() async {
    _nameController.text = _displayName ?? "";

    // Get the Navigator and Messenger *before* the async call
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Change Your Name'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'Please enter your new display name.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : TextField(
                      controller: _nameController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Your name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    navigator.pop();
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: isLoading ? null : () async {
                    setDialogState(() => isLoading = true);

                    final newName = _nameController.text.trim();
                    if (newName.isNotEmpty && _user != null) {
                      try {

                        await _user.updateDisplayName(newName);

                        await _firestore
                            .collection('users')
                            .doc(_user.uid)
                            .set({
                          'displayName': newName,
                        }, SetOptions(merge: true));

                        // Update local state
                        setState(() {
                          _displayName = newName;
                        });
                        navigator.pop(); // Close dialog

                      } catch (e) {
                        messenger.showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    }
                    setDialogState(() => isLoading = false);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // (Helper functions _launchURL and _launchEmail )
  Future<void> _launchURL(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $urlString')),
        );
      }
    }
  }

  Future<void> _launchEmail(BuildContext context) async {
    const String email = 'bineykay75@gmail.com';
    const String subject = 'Snake Identifier App Feedback';
    final String encodedSubject = Uri.encodeComponent(subject);
    final Uri mailtoUri = Uri.parse('mailto:$email?subject=$encodedSubject');

    if (!await launchUrl(mailtoUri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email app.')),
        );
      }
    }
  }
  // -----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Theme Toggle ---
              const Text('Theme', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SegmentedButton<ThemeModeState>(
                segments: const [
                  ButtonSegment(
                    value: ThemeModeState.light,
                    icon: Icon(Icons.light_mode),
                    label: Text('Light'),
                  ),
                  ButtonSegment(
                    value: ThemeModeState.system,
                    icon: Icon(Icons.brightness_auto),
                    label: Text('System'),
                  ),
                  ButtonSegment(
                    value: ThemeModeState.dark,
                    icon: Icon(Icons.dark_mode),
                    label: Text('Dark'),
                  ),
                ],
                selected: {themeManager.themeModeState},
                onSelectionChanged: (Set<ThemeModeState> newSelection) {
                  themeManager.setTheme(newSelection.first);
                },
                showSelectedIcon: false,
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
              ),
              const SizedBox(height: 30),

              // Profile Picture
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 20),

              // MODIFIED NAME AND EMAIL
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _displayName ?? 'User',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
                    onPressed: _showEditNameDialog,
                  ),
                ],
              ),
              Text(
                _user?.email ?? 'Not logged in',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 40),

              // Bookmarks
              Text(
                'My Bookmarks',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const BookmarkList(),
              const SizedBox(height: 10),
              const Divider(),

              // Other Buttons
              _buildProfileButton(
                context,
                icon: Icons.code,
                text: 'Contribute on GitHub',
                onTap: () {
                  _launchURL(context, 'https://github.com/Gabby-01-K/snake_detectorv');
                },
              ),
              const Divider(),
              _buildProfileButton(
                context,
                icon: Icons.contact_mail,
                text: 'Contact Us',
                onTap: () {
                  _launchEmail(context);
                },
              ),
              const Divider(),
              const SizedBox(height: 30),

              // Logout Button
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () async {
                  await _auth.signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context,
      {required IconData icon,
        required String text,
        required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(text, style: Theme.of(context).textTheme.bodyLarge),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}