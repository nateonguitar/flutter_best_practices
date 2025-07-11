import 'package:flutter/material.dart';
import 'package:flutter_best_practices/dialogs/confirm_dialog.dart';
import 'package:flutter_best_practices/managers/theme_manager.dart';
import 'package:flutter_best_practices/provider.dart';
import 'package:flutter_best_practices/router.dart';
import 'package:flutter_best_practices/services/auth_service.dart';
import 'package:flutter_best_practices/themes/core_theme.dart';
import 'package:flutter_best_practices/utils/logging.dart';
import 'package:go_router/go_router.dart';

class ThemeModeChoice {
  final ThemeMode mode;
  final String label;
  final IconData icon;

  ThemeModeChoice({
    required this.mode,
    required this.label,
    required this.icon,
  });
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with Logging {
  late ThemeData _theme;
  final _themeManager = Provider.get<ThemeManager>();

  final List<ThemeModeChoice> _themeChoices = [
    ThemeModeChoice(
      mode: ThemeMode.system,
      label: 'System Default',
      icon: Icons.settings,
    ),
    ThemeModeChoice(
      mode: ThemeMode.light,
      label: 'Light',
      icon: Icons.wb_sunny,
    ),
    ThemeModeChoice(
      mode: ThemeMode.dark,
      label: 'Dark',
      icon: Icons.nightlight_round,
    ),
  ];

  @override
  initState() {
    super.initState();
    logWidgetMounted();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _theme.cardTheme.color ?? _theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: CoreTheme.pagePadding,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: CoreTheme.pageContentMaxWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Appearance Section
                Text(
                  'Appearance',
                  style: _theme.textTheme.titleLarge,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Theme',
                        style: _theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      _themeDropdown(),
                    ],
                  ),
                ),

                const Divider(height: 40),

                // Account Section
                Text(
                  'Account',
                  style: _theme.textTheme.titleLarge,
                ),
                _logoutListTile(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _themeDropdown() {
    return DropdownButtonFormField<ThemeMode>(
      dropdownColor: _theme.dropdownMenuTheme.menuStyle?.backgroundColor
          ?.resolve({WidgetState.focused}),
      iconEnabledColor: _theme.textTheme.bodyMedium?.color,
      value: _themeManager.themeMode,
      borderRadius: BorderRadius.zero,
      items: [
        for (final choice in _themeChoices)
          DropdownMenuItem(
            value: choice.mode,
            child: Row(
              spacing: 8,
              children: [
                Icon(
                  choice.icon,
                  color: _theme.colorScheme.primary,
                ),
                Text(
                  choice.label,
                  style: _theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
      ],
      onChanged: (ThemeMode? value) {
        if (value != null) {
          _themeManager.setThemeMode(value);
          setState(() {});
        }
      },
    );
  }

  Widget _logoutListTile() {
    return ListTile(
      leading: Icon(
        Icons.logout,
        color: _theme.colorScheme.primary,
      ),
      title: Text(
        'Logout',
        style: _theme.textTheme.titleMedium,
      ),
      onTap: () => _showLogoutDialog(),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: const Text(
          'Are you sure you?',
        ),
        body: const Text(
          'You will be logged out.',
        ),
        cancelText: 'Cancel',
        confirmText: 'Logout',
        onConfirmPressed: () async {
          Provider.get<AuthService>().authToken.value = null;
        },
      ),
    );
  }
}
