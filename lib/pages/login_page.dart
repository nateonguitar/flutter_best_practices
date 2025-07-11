import 'package:flutter/material.dart';
import 'package:flutter_best_practices/build_config.dart';
import 'package:flutter_best_practices/provider.dart';
import 'package:flutter_best_practices/services/auth_service.dart';
import 'package:flutter_best_practices/themes/core_theme.dart';
import 'package:flutter_best_practices/utils/logging.dart';

class _Controllers {
  final username = TextEditingController();
  final password = TextEditingController();

  void initFromAutofill(LoginAutofill loginAutofill) {
    username.text = loginAutofill.username;
    password.text = loginAutofill.password;
  }

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
  late ThemeData _theme;
  final _authService = Provider.get<AuthService>();

  bool _loggingIn = false;
  bool _showPassword = false;

  final _controllers = _Controllers();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final loginAutofill = BuildConfig.instance.loginAutofill;
    if (loginAutofill != null) {
      _controllers.initFromAutofill(loginAutofill);
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      spacing: 24,
      children: [
        _logoWidget(),
        Card(
          child: Padding(
            padding: CoreTheme.cardSectionPadding,
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _usernameField(),
                  _passwordField(),
                  Row(
                    children: [
                      Expanded(
                        child: _saveButton(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: _forgotPasswordButton(),
        ),
      ],
    );
  }

  Widget _logoWidget() {
    return Text(
      'Logo goes here',
      style: _theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
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
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _showPassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            _showPassword = !_showPassword;
            setState(() {});
          },
        ),
      ),
      enabled: !_loggingIn,
      obscureText: !_showPassword,
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
    return ElevatedButton(
      onPressed: _loggingIn ? null : _save,
      child: const Text('Login'),
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
