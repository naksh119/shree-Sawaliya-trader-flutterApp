import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sawaliyatrader/core/api/api_exception.dart';
import 'package:sawaliyatrader/core/auth/auth_service.dart';
import 'package:sawaliyatrader/core/constants/app_assets.dart';
import 'package:sawaliyatrader/core/loading/app_loading.dart';
import 'package:sawaliyatrader/core/routing/app_routes.dart';
import 'package:sawaliyatrader/core/theme/app_text_styles.dart';
import 'package:sawaliyatrader/core/widgets/app_background.dart';
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message,
            style: AppTextStyles.body(context).copyWith(color: Colors.white),
          ),
          backgroundColor: context.appColors.textPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong. Please try again.',
            style: AppTextStyles.body(context).copyWith(color: Colors.white),
          ),
          backgroundColor: context.appColors.textPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final logoWidth = (screenSize.width * 0.45).clamp(0.0, 180.0);
    final topPadding = (screenSize.height * 0.1).clamp(40.0, 96.0);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: context.appColors.surface,
      resizeToAvoidBottomInset: false,
      body: AppBackground(
        child: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  24,
                  topPadding,
                  24,
                  24 + bottomInset,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                          Image.asset(
                            AppAssets.logo,
                            width: logoWidth,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 20),
                          Text('Welcome Back', style: AppTextStyles.heading(context)),
                          const SizedBox(height: 6),
                          Text(
                            'Sign in to Shree Sawaliya Multitrade',
                            style: AppTextStyles.subtitle(context),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 28),
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
                          const SizedBox(height: 18),
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
                                color: context.appColors.shinyGold.withValues(alpha: 0.75),
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                            validator: _validatePassword,
                          ),
                          const SizedBox(height: 32),
                          AppPrimaryButton(
                            label: 'Login',
                            onPressed: _isSubmitting ? null : _onLogin,
                          ),
                    ],
                  ),
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
