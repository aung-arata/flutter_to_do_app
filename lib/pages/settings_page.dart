import 'package:flutter/material.dart';
import 'package:to_do_app/pages/trash_page.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _biometricEnabled = false;
  bool _canCheckBiometrics = false;
  
  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _loadBiometricSetting();
  }
  
  Future<void> _checkBiometricAvailability() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      setState(() {
        _canCheckBiometrics = canCheck && isDeviceSupported;
      });
    } catch (e) {
      setState(() {
        _canCheckBiometrics = false;
      });
    }
  }
  
  Future<void> _loadBiometricSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
    });
  }
  
  Future<void> _toggleBiometric(bool value) async {
    if (!_canCheckBiometrics) {
      _showMessage('Biometric authentication is not available on this device');
      return;
    }
    
    if (value) {
      // User wants to enable biometric - authenticate first
      try {
        final authenticated = await _localAuth.authenticate(
          localizedReason: 'Please authenticate to enable biometric lock',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        
        if (authenticated) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('biometric_enabled', true);
          setState(() {
            _biometricEnabled = true;
          });
          _showMessage('Biometric authentication enabled');
        }
      } catch (e) {
        _showMessage('Authentication failed: ${e.toString()}');
      }
    } else {
      // User wants to disable biometric
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('biometric_enabled', false);
      setState(() {
        _biometricEnabled = false;
      });
      _showMessage('Biometric authentication disabled');
    }
  }
  
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
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
                leading: Icon(
                  Icons.fingerprint, 
                  color: _canCheckBiometrics ? Colors.purple : Colors.grey,
                ),
                title: const Text('Biometric Authentication'),
                subtitle: Text(
                  _canCheckBiometrics 
                      ? 'Use fingerprint or face to unlock' 
                      : 'Not available on this device',
                ),
                trailing: Switch(
                  value: _biometricEnabled,
                  onChanged: _canCheckBiometrics ? _toggleBiometric : null,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.blue),
                title: const Text('App Lock'),
                subtitle: const Text('Protect with pattern lock'),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    _showComingSoonDialog('App Lock');
                  },
                ),
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
