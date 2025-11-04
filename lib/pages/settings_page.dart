import 'package:flutter/material.dart';
import 'package:to_do_app/pages/trash_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionCard(
            title: 'Data Management',
            icon: Icons.storage,
            iconColor: Colors.blue,
            children: [
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Trash'),
                subtitle: const Text('View and restore deleted tasks'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const TrashPage()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Backup & Restore',
            icon: Icons.backup,
            iconColor: Colors.green,
            children: [
              ListTile(
                leading: const Icon(Icons.cloud_upload, color: Colors.blue),
                title: const Text('Backup Data'),
                subtitle: const Text('Save your tasks to the cloud'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showComingSoonDialog('Backup Data');
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.cloud_download, color: Colors.orange),
                title: const Text('Restore Data'),
                subtitle: const Text('Restore your tasks from backup'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showComingSoonDialog('Restore Data');
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.schedule, color: Colors.purple),
                title: const Text('Auto Backup'),
                subtitle: const Text('Automatically backup daily'),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    _showComingSoonDialog('Auto Backup');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Security',
            icon: Icons.security,
            iconColor: Colors.red,
            children: [
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.blue),
                title: const Text('App Lock'),
                subtitle: const Text('Protect with pattern or fingerprint'),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    _showComingSoonDialog('App Lock');
                  },
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.fingerprint, color: Colors.purple),
                title: const Text('Fingerprint'),
                subtitle: const Text('Use fingerprint to unlock'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showComingSoonDialog('Fingerprint Authentication');
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.pattern, color: Colors.orange),
                title: const Text('Pattern Lock'),
                subtitle: const Text('Set a pattern to unlock'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showComingSoonDialog('Pattern Lock');
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'About',
            icon: Icons.info,
            iconColor: Colors.blue,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.blue),
                title: const Text('Version'),
                subtitle: const Text('1.0.0'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.construction, color: Colors.orange.shade600),
              const SizedBox(width: 8),
              const Text('Coming Soon'),
            ],
          ),
          content: Text(
            '$feature feature is under development and will be available in a future update.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
