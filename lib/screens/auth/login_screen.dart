import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/constants/app_assets.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_background.dart';
import 'package:sawaliyatrader/core/widgets/app_message.dart';
import 'package:sawaliyatrader/core/widgets/app_primary_button.dart';
import 'package:sawaliyatrader/core/widgets/app_text_field.dart';
import 'package:sawaliyatrader/core/theme/theme_context.dart';
import 'package:sawaliyatrader/core/widgets/theme_toggle_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

String? _validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your email';
  }
  if (!RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(value.trim())) {
    return 'Enter a valid email address';
  }
  return null;
}

String? _validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  return null;
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  void _togglePasswordVisibility() {
    final selection = _passwordController.selection;
    setState(() => _obscurePassword = !_obscurePassword);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _passwordController.selection = selection;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await _authService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;

      context.go(AppRoutes.dashboard);
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      await showAppErrorMessage(context, message: error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      await showAppErrorMessage(
        context,
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: context.appColors.surface,
      resizeToAvoidBottomInset: false,
      body: AppBackground(
        showOverlay: Theme.of(context).brightness == Brightness.dark,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.noScaling,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const horizontalPadding = 24.0;
                    const verticalPadding = 24.0;
                    final contentWidth =
                        constraints.maxWidth - (horizontalPadding * 2);
                    final logoWidth =
                        (contentWidth * 0.42).clamp(120.0, 160.0);
                    final minContentHeight = constraints.maxHeight -
                        (verticalPadding * 2) -
                        bottomInset;

                    final form = Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppAssets.logo,
                            width: logoWidth,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Welcome Back',
                            style: AppTextStyles.heading(context),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Sign in to Shree Sawaliya Multitrade',
                            style: AppTextStyles.subtitle(context),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          AppTextField(
                            controller: _emailController,
                            label: 'Email Address',
                            hint: 'Enter your email',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            enableSuggestions: false,
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Enter your password',
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _onLogin(),
                            autocorrect: false,
                            enableSuggestions: false,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: context.appColors.shinyGold
                                    .withValues(alpha: 0.75),
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                            validator: _validatePassword,
                          ),
                          const SizedBox(height: 28),
                          AppPrimaryButton(
                            label: 'Login',
                            onPressed: _isSubmitting ? null : _onLogin,
                          ),
                        ],
                      ),
                    );

                    return SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        verticalPadding,
                        horizontalPadding,
                        verticalPadding + bottomInset,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: minContentHeight),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [form],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: ThemeToggleButton(),
              ),
            ),
            if (_isSubmitting)
              const AppLoadingOverlay(message: 'Signing in...'),
          ],
        ),
      ),
    );
  }
}
