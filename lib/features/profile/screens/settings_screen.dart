import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green[800]),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notifications Section
          Card(
            child: Column(
              children: [
                _SectionHeader(title: 'Notifications'),
                _SettingsTile(
                  icon: Icons.notifications,
                  title: 'Care Reminders',
                  subtitle: 'Daily plant care notifications',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
                _SettingsTile(
                  icon: Icons.tips_and_updates,
                  title: 'Weekly Tips',
                  subtitle: 'Plant care tips and advice',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
                _SettingsTile(
                  icon: Icons.cloud,
                  title: 'Weather Alerts',
                  subtitle: 'Weather-based care suggestions',
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // App Preferences Section
          Card(
            child: Column(
              children: [
                _SectionHeader(title: 'App Preferences'),
                _SettingsTile(
                  icon: Icons.palette,
                  title: 'Theme',
                  subtitle: 'Light',
                  onTap: () => _showThemeDialog(context),
                ),
                _SettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () => _showLanguageDialog(context),
                ),
                _SettingsTile(
                  icon: Icons.save,
                  title: 'Auto-save Photos',
                  subtitle: 'Save identified plant photos',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
                _SettingsTile(
                  icon: Icons.offline_bolt,
                  title: 'Offline Mode',
                  subtitle: 'Use cached data when offline',
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Privacy & Security Section
          Card(
            child: Column(
              children: [
                _SectionHeader(title: 'Privacy & Security'),
                _SettingsTile(
                  icon: Icons.fingerprint,
                  title: 'Biometric Lock',
                  subtitle: 'Use fingerprint or face unlock',
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
                _SettingsTile(
                  icon: Icons.analytics,
                  title: 'Analytics',
                  subtitle: 'Help improve the app',
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
                _SettingsTile(
                  icon: Icons.backup,
                  title: 'Backup Data',
                  subtitle: 'Export your plant collection',
                  onTap: () => _showBackupDialog(context),
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
          
          const SizedBox(height: 16),
          
          // About Section
          Card(
            child: Column(
              children: [
                _SectionHeader(title: 'About'),
                _SettingsTile(
                  icon: Icons.info,
                  title: 'App Version',
                  subtitle: '1.0.0',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  subtitle: 'How we protect your data',
                  onTap: () => _showPrivacyPolicy(context),
                ),
                _SettingsTile(
                  icon: Icons.description,
                  title: 'Terms of Service',
                  subtitle: 'App usage terms',
                  onTap: () => _showTermsOfService(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Light'),
              value: 'light',
              groupValue: 'light',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('Dark'),
              value: 'dark',
              groupValue: 'light',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('System'),
              value: 'system',
              groupValue: 'light',
              onChanged: (value) => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languages = ['English', 'Spanish', 'French', 'German'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              return RadioListTile<String>(
                title: Text(languages[index]),
                value: languages[index],
                groupValue: 'English',
                onChanged: (value) => Navigator.pop(context),
              );
            },
          ),
        ),
      ),
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
                const SnackBar(content: Text('Data exported successfully!')),
              );
            },
            child: const Text('Export'),
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
                  content: Text('All data cleared successfully!'),
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

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'By using this app, you agree to these terms.\n\n'
            'The app is provided for personal, non-commercial use. Plant identification is for informational purposes only.\n\n'
            'We are not responsible for plant care decisions. Always verify plant identity before consumption.\n\n'
            'Contact us at legal@plantidentifier.com for questions.',
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
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
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
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
}