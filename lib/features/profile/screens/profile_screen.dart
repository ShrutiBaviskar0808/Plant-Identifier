import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Plant Enthusiast',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Member since 2024',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Statistics
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Statistics',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          icon: Icons.local_florist,
                          label: 'Plants',
                          value: '12',
                        ),
                        _StatItem(
                          icon: Icons.camera_alt,
                          label: 'Identified',
                          value: '25',
                        ),
                        _StatItem(
                          icon: Icons.schedule,
                          label: 'Care Tasks',
                          value: '48',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Settings
            Card(
              child: Column(
                children: [
                  _SettingsHeader(title: 'Preferences'),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return _SettingsTile(
                        icon: Icons.palette,
                        title: 'Theme',
                        subtitle: _getThemeText(themeProvider.themeMode),
                        onTap: () => _showThemeDialog(context, themeProvider),
                      );
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage care reminders',
                    onTap: () => _showNotificationSettings(context),
                  ),
                  _SettingsTile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () => _showLanguageSettings(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Column(
                children: [
                  _SettingsHeader(title: 'Data & Privacy'),
                  _SettingsTile(
                    icon: Icons.backup,
                    title: 'Backup Data',
                    subtitle: 'Export your plant collection',
                    onTap: () => _showBackupDialog(context),
                  ),
                  _SettingsTile(
                    icon: Icons.privacy_tip,
                    title: 'Privacy Policy',
                    subtitle: 'How we protect your data',
                    onTap: () => _showPrivacyPolicy(context),
                  ),
                  _SettingsTile(
                    icon: Icons.delete_forever,
                    title: 'Clear Data',
                    subtitle: 'Remove all local data',
                    onTap: () => _showClearDataDialog(context),
                    isDestructive: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Column(
                children: [
                  _SettingsHeader(title: 'About'),
                  _SettingsTile(
                    icon: Icons.info,
                    title: 'App Version',
                    subtitle: '1.0.0',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.help,
                    title: 'Help & Support',
                    subtitle: 'Get help with the app',
                    onTap: () => _showHelpDialog(context),
                  ),
                  _SettingsTile(
                    icon: Icons.star,
                    title: 'Rate App',
                    subtitle: 'Share your feedback',
                    onTap: () => _showRatingDialog(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getThemeText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                themeProvider.setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                themeProvider.setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                themeProvider.setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification settings coming soon!')),
    );
  }

  void _showLanguageSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Language settings coming soon!')),
    );
  }

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup Data'),
        content: const Text('Export your plant collection and care data to a file.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup feature coming soon!')),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Plant Identifier respects your privacy. All plant identification is performed locally on your device using AI models. No images or personal data are sent to external servers.\n\n'
            'Your plant collection and care data are stored locally on your device and are not shared with third parties.\n\n'
            'For questions about privacy, please contact us at privacy@plantidentifier.com',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your plants, identification history, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Clear data feature coming soon!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text(
          'Need help with Plant Identifier?\n\n'
          '• Take clear, well-lit photos for best identification results\n'
          '• Make sure the plant fills most of the frame\n'
          '• Try different angles if identification fails\n'
          '• Check care reminders regularly\n\n'
          'For technical support, email: support@plantidentifier.com',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rate Plant Identifier'),
        content: const Text('Enjoying the app? Please rate us on the app store!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you for your feedback!')),
              );
            },
            child: const Text('Rate Now'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 28,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  final String title;

  const _SettingsHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive 
            ? Theme.of(context).colorScheme.error 
            : Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive 
              ? Theme.of(context).colorScheme.error 
              : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}