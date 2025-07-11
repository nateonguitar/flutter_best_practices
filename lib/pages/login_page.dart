import 'package:flutter/material.dart';
import 'package:flutter_best_practices/provider.dart';
import 'package:flutter_best_practices/services/auth_service.dart';
import 'package:flutter_best_practices/themes/core_theme.dart';
import 'package:flutter_best_practices/utils/logging.dart';

class _Controllers {
  final username = TextEditingController();
  final password = TextEditingController();

  void trimAll() {
    username.text = username.text.trim();
    password.text = password.text.trim();
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Logging {
  final _authService = Provider.get<AuthService>();

  bool _loggingIn = false;

  final _controllers = _Controllers();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: CoreTheme.pageContentMaxWidth,
            ),
            child: Padding(
              padding: CoreTheme.pagePadding,
              child: _bodyWidget(),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Login'),
    );
  }

  Widget _bodyWidget() {
    return Column(
      spacing: 16,
      children: [
        _formWidget(),
        Align(
          alignment: Alignment.centerRight,
          child: _forgotPasswordButton(),
        ),
      ],
    );
  }

  Widget _formWidget() {
    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: CoreTheme.cardSectionPadding,
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _usernameField(),
              _passwordField(),
              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _usernameField() {
    return TextFormField(
      controller: _controllers.username,
      decoration: const InputDecoration(
        labelText: 'Username',
      ),
      enabled: !_loggingIn,
      validator: (value) {
        value = (value ?? '').trim();
        if (value.isEmpty) {
          return 'Required';
        }
        return null;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _controllers.password,
      decoration: const InputDecoration(
        labelText: 'Password',
      ),
      enabled: !_loggingIn,
      obscureText: true,
      validator: (value) {
        value = (value ?? '').trim();
        if (value.isEmpty) {
          return 'Required';
        }
        return null;
      },
    );
  }

  Widget _saveButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _loggingIn ? null : _save,
            child: const Text('Login'),
          ),
        ),
      ],
    );
  }

  Widget _forgotPasswordButton() {
    return TextButton(
      onPressed: () {
        log('Forgot password button pressed');
      },
      child: const Text('Forgot Password?'),
    );
  }

  Future<void> _save() async {
    _controllers.trimAll();
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    final username = _controllers.username.text.trim();
    final password = _controllers.password.text.trim();

    _loggingIn = true;
    setState(() {});
    try {
      await _authService.login(
        username: username,
        password: password,
      );
    } catch (e) {
      log('Login failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    } finally {
      _loggingIn = false;
      if (mounted) {
        setState(() {});
      }
    }
  }
}
