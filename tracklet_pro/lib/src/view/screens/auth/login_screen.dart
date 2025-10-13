import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_text_field_widget.dart';
import 'package:tracklet_pro/src/utils/index.dart';
import 'package:tracklet_pro/src/navigation/unified_main_screen.dart';
import 'package:tracklet_pro/src/view_model/index.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final authProvider = context.read<AuthProvider>();
        await authProvider.login(
          _emailController.text.trim(),
          _passwordController.text,
        );

        // Check user role and navigate accordingly
        if (authProvider.user != null) {
          Logger.debug(
            'LoginScreen: Auth provider user role: ${authProvider.user!.role}',
          );

          if (authProvider.isGasPlantUser() ||
              authProvider.isDistributorUser()) {
            Logger.debug('LoginScreen: Navigating to Unified Main Screen');
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const UnifiedMainScreen(),
                ),
              );
            }
          } else {
            Logger.warn(
              'LoginScreen: User role is neither gas_plant nor distributor, got: ${authProvider.user!.role}',
            );
            setState(() {
              _errorMessage = 'Invalid user role';
              _isLoading = false;
            });
          }
        } else {
          Logger.warn('LoginScreen: User is null after login');
          setState(() {
            _errorMessage = 'Login failed';
            _isLoading = false;
          });
        }
      } catch (e) {
        Logger.error('LoginScreen: Login error: $e');
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Logo or App Name
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.darkBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.local_gas_station,
                      color: AppColors.lightBlueBackground,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Welcome text
                const Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sign in to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: AppColors.onBackground),
                ),
                const SizedBox(height: 40),
                // Email field
                CustomTextFieldWidget(
                  controller: _emailController,
                  label: AppStrings.loginEmailLabel,
                  hint: AppStrings.loginEmailHint,
                  prefixIcon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.emailRequired;
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Password field
                CustomTextFieldWidget(
                  controller: _passwordController,
                  label: AppStrings.loginPasswordLabel,
                  hint: AppStrings.loginPasswordHint,
                  obscureText: true,
                  prefixIcon: Icons.lock,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.passwordRequired;
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Remember me checkbox
                Row(
                  children: [
                    Checkbox(
                      value: viewModel.rememberMe,
                      onChanged: (value) {
                        Logger.debug(
                          'LoginScreen: Remember me checkbox changed to: $value',
                        );
                        viewModel.toggleRememberMe();
                      },
                      activeColor: AppColors.onBackground,
                      checkColor: AppColors.darkBlue,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.onBackground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Error message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                // Login button
                CustomButtonWidget(
                  onPressed: _isLoading ? () {} : () => _login(),
                  text: _isLoading ? 'Signing in...' : AppStrings.loginButton,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 20),
                // Gas Plant hint
                const Text(
                  AppStrings.loginGasPlantHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.disabledTextColor,
                  ),
                ),
                const SizedBox(height: 10),
                // Distributor hint
                const Text(
                  AppStrings.loginDistributorHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.disabledTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
