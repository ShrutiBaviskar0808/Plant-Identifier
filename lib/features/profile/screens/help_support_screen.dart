import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help & Support',
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
          // Quick Help Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.help_outline,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Quick Help',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickHelpCard(
                          icon: Icons.camera_alt,
                          title: 'Plant ID Tips',
                          subtitle: 'Better photos',
                          onTap: () => _showPlantIdTips(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickHelpCard(
                          icon: Icons.local_florist,
                          title: 'Care Guide',
                          subtitle: 'Plant basics',
                          onTap: () => _showCareGuide(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // FAQ Section
          Text(
            'Frequently Asked Questions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          ..._buildFAQItems(context),
          
          const SizedBox(height: 24),
          
          // Contact Support
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Still Need Help?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ContactOption(
                    icon: Icons.email,
                    title: 'Email Support',
                    subtitle: 'support@plantidentifier.com',
                    onTap: () => _contactEmail(context),
                  ),
                  const Divider(),
                  _ContactOption(
                    icon: Icons.chat,
                    title: 'Live Chat',
                    subtitle: 'Chat with our plant experts',
                    onTap: () => _startLiveChat(context),
                  ),
                  const Divider(),
                  _ContactOption(
                    icon: Icons.bug_report,
                    title: 'Report Bug',
                    subtitle: 'Help us improve the app',
                    onTap: () => _reportBug(context),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // App Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _InfoRow('Version', '1.0.0'),
                  _InfoRow('Last Updated', 'December 2024'),
                  _InfoRow('Developer', 'Plant Care Team'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showPrivacyPolicy(context),
                          icon: const Icon(Icons.privacy_tip),
                          label: const Text('Privacy Policy'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showTermsOfService(context),
                          icon: const Icon(Icons.description),
                          label: const Text('Terms'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFAQItems(BuildContext context) {
    final faqs = [
      {
        'question': 'How accurate is plant identification?',
        'answer': 'Our AI model has 95%+ accuracy for common houseplants. For best results, take clear photos in good lighting with the plant filling most of the frame.',
      },
      {
        'question': 'Why can\'t I identify my plant?',
        'answer': 'Try these tips:\n• Ensure good lighting\n• Clean the camera lens\n• Take photos from different angles\n• Make sure the plant is clearly visible\n• Try photographing leaves and flowers separately',
      },
      {
        'question': 'How do care reminders work?',
        'answer': 'Set up care schedules for each plant in your garden. The app will send notifications when it\'s time to water, fertilize, or perform other care tasks.',
      },
      {
        'question': 'Can I use the app offline?',
        'answer': 'Plant identification requires an internet connection, but you can view your saved plants and care schedules offline.',
      },
      {
        'question': 'How do I backup my plant collection?',
        'answer': 'Go to Profile > Data & Privacy > Backup Data to export your plant collection and care history.',
      },
    ];

    return faqs.map((faq) => Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          faq['question']!,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              faq['answer']!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    )).toList();
  }

  Widget _InfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showPlantIdTips(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Plant Identification Tips'),
        content: const SingleChildScrollView(
          child: Text(
            '📸 Photography Tips:\n'
            '• Use natural lighting when possible\n'
            '• Fill the frame with the plant\n'
            '• Keep the camera steady\n'
            '• Take multiple angles\n\n'
            '🌿 What to Photograph:\n'
            '• Leaves (top and bottom)\n'
            '• Flowers or fruits\n'
            '• Overall plant structure\n'
            '• Stem and bark (for trees)\n\n'
            '✨ Best Results:\n'
            '• Clean, unobstructed view\n'
            '• Good contrast with background\n'
            '• Focus on unique features',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showCareGuide(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Basic Plant Care'),
        content: const SingleChildScrollView(
          child: Text(
            '💧 Watering:\n'
            '• Check soil moisture first\n'
            '• Water thoroughly but infrequently\n'
            '• Use room temperature water\n\n'
            '☀️ Light:\n'
            '• Most plants need bright, indirect light\n'
            '• Rotate plants weekly\n'
            '• Watch for light stress signs\n\n'
            '🌡️ Environment:\n'
            '• Keep temperature consistent\n'
            '• Provide adequate humidity\n'
            '• Ensure good air circulation\n\n'
            '🌱 Maintenance:\n'
            '• Remove dead leaves promptly\n'
            '• Fertilize during growing season\n'
            '• Repot when rootbound',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Thanks!'),
          ),
        ],
      ),
    );
  }

  void _contactEmail(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening email app...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _startLiveChat(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Live chat feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _reportBug(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report a Bug'),
        content: const TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Describe the issue you encountered...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bug report submitted. Thank you!')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const _PolicyScreen(
          title: 'Privacy Policy',
          content: 'Plant Identifier Privacy Policy\n\n'
              'We respect your privacy and are committed to protecting your personal data.\n\n'
              'Data Collection:\n'
              '• Plant photos are processed locally on your device\n'
              '• No images are stored on our servers\n'
              '• Usage analytics are anonymized\n\n'
              'Data Usage:\n'
              '• Plant identification is performed using on-device AI\n'
              '• Care data is stored locally on your device\n'
              '• No personal information is shared with third parties\n\n'
              'Your Rights:\n'
              '• You can delete all data at any time\n'
              '• You control what information is shared\n'
              '• You can opt out of analytics\n\n'
              'Contact us at privacy@plantidentifier.com for questions.',
        ),
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const _PolicyScreen(
          title: 'Terms of Service',
          content: 'Plant Identifier Terms of Service\n\n'
              'By using this app, you agree to these terms.\n\n'
              'Use of Service:\n'
              '• The app is provided for personal, non-commercial use\n'
              '• Plant identification is for informational purposes only\n'
              '• We are not responsible for plant care decisions\n\n'
              'Accuracy:\n'
              '• Plant identification may not always be 100% accurate\n'
              '• Always verify plant identity before consumption\n'
              '• Consult experts for critical plant identification\n\n'
              'Liability:\n'
              '• Use the app at your own risk\n'
              '• We are not liable for plant care outcomes\n'
              '• Always research proper plant care independently\n\n'
              'Contact us at legal@plantidentifier.com for questions.',
        ),
      ),
    );
  }
}

class _QuickHelpCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickHelpCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

class _PolicyScreen extends StatelessWidget {
  final String title;
  final String content;

  const _PolicyScreen({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green[800]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.6,
          ),
        ),
      ),
    );
  }
}