import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  String? _validationError; // error dari validasi lokal (sebelum hit API)

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    // Reset validation error dulu
    setState(() => _validationError = null);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validasi lokal — sebelum panggil API
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _validationError = 'All fields are required');
      return;
    }

    if (password.length < 8) {
      setState(() => _validationError = 'Password minimum 8 characters');
      return;
    }

    if (password != confirmPassword) {
      setState(() => _validationError = 'Passwords do not match');
      return;
    }

    await ref.read(authProvider.notifier).register(name, email, password);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Gabungkan error lokal dan error dari API
    final errorMessage = _validationError ?? authState.error;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              Text('Create Account', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                'Join TradeGenZ and start trading smarter',
                style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
              ),

              const SizedBox(height: 48),

              _InputLabel('Full Name'),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: AppTextStyles.body,
                decoration: _inputDecoration('Enter your full name'),
              ),

              const SizedBox(height: 20),

              _InputLabel('Email'),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: AppTextStyles.body,
                decoration: _inputDecoration('Enter your email'),
              ),

              const SizedBox(height: 20),

              _InputLabel('Password'),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: AppTextStyles.body,
                decoration: _inputDecoration('Min. 8 characters').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.textMuted,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _InputLabel('Confirm Password'),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscurePassword,
                style: AppTextStyles.body,
                decoration: _inputDecoration('Re-enter your password'),
              ),

              // Error message — lokal atau dari API
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  errorMessage,
                  style: AppTextStyles.label.copyWith(color: AppColors.error),
                ),
              ],

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _onRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Create Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: AppTextStyles.body),
                  GestureDetector(
                    onTap: () => context.pop(), // kembali ke login
                    child: Text(
                      'Login',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _InputLabel(String text) {
    return Text(text, style: AppTextStyles.label);
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.body.copyWith(color: AppColors.textMuted),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}
