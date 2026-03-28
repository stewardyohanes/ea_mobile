import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradegenz_app/core/theme/app_colors.dart';
import 'package:tradegenz_app/core/theme/app_text_styles.dart';
import 'package:tradegenz_app/features/auth/data/auth_api.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _otpSent = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await AuthApi.forgotPassword(email);
      if (mounted) setState(() => _otpSent = true);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Gagal mengirim OTP. Periksa koneksi internet kamu.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () {
            if (_otpSent) {
              setState(() => _otpSent = false);
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: _otpSent ? _buildOTPSentView() : _buildEmailView(),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────
  // STEP 01: Enter Email
  // ──────────────────────────────────────────
  Widget _buildEmailView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // Page header
        Text('Account Recovery', style: AppTextStyles.h2),
        const SizedBox(height: 8),
        Text(
          'Review the three-step flow for resetting secure access to your TradeGenZ terminal.',
          style: AppTextStyles.body.copyWith(color: AppColors.onSurfaceVariant),
        ),

        const SizedBox(height: 32),

        // Step card
        _StepCard(
          stepLabel: 'STEP_01',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step title
              Text('Enter Email', style: AppTextStyles.h3),
              const SizedBox(height: 8),
              Text(
                'Input your registered terminal identifier to initiate the account recovery sequence.',
                style: AppTextStyles.body.copyWith(color: AppColors.onSurfaceVariant),
              ),

              const SizedBox(height: 24),

              // Field label
              _FieldLabel('TERMINAL ADDRESS'),
              const SizedBox(height: 8),

              // Email TextField
              _MonoTextField(
                controller: _emailController,
                hint: 'operator@tradegenz.io',
                prefixIcon: Icons.alternate_email,
                keyboardType: TextInputType.emailAddress,
              ),

              // Error
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
                ),
              ],

              const SizedBox(height: 28),

              // Send OTP button
              _GradientButton(
                isLoading: _isLoading,
                onPressed: _sendOTP,
                label: 'SEND OTP',
                icon: Icons.send,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────
  // STEP 02: OTP Sent
  // ──────────────────────────────────────────
  Widget _buildOTPSentView() {
    final email = _emailController.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // Page header (same branding)
        Text('Account Recovery', style: AppTextStyles.h2),
        const SizedBox(height: 8),
        Text(
          'Review the three-step flow for resetting secure access to your TradeGenZ terminal.',
          style: AppTextStyles.body.copyWith(color: AppColors.onSurfaceVariant),
        ),

        const SizedBox(height: 32),

        // Step card
        _StepCard(
          stepLabel: 'STEP_02',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Green check icon
              const Icon(
                Icons.check_circle,
                color: AppColors.secondaryContainer,
                size: 36,
              ),
              const SizedBox(height: 12),

              Text('Verification Sent', style: AppTextStyles.h3),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: AppTextStyles.body.copyWith(color: AppColors.onSurfaceVariant),
                  children: [
                    const TextSpan(text: 'An encrypted sync key has been dispatched to '),
                    TextSpan(
                      text: email,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _FieldLabel('ENTER OTP CODE'),
              const SizedBox(height: 8),

              // OTP hint box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.pin, color: AppColors.outline, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Enter 6-digit OTP on next screen',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 14,
                        color: AppColors.outline.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),

              // Error
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
                ),
              ],

              const SizedBox(height: 28),

              // Verify OTP button
              _GradientButton(
                isLoading: false,
                onPressed: () => context.push('/otp-verification', extra: email),
                label: 'VERIFY OTP',
                icon: Icons.verified_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────
// Shared internal widgets
// ──────────────────────────────────────────

class _StepCard extends StatelessWidget {
  final String stepLabel;
  final Widget child;

  const _StepCard({required this.stepLabel, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step label chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Text(
              stepLabel,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurfaceVariant,
        letterSpacing: 2.0,
      ),
    );
  }
}

class _MonoTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final TextInputType keyboardType;

  const _MonoTextField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 14,
        color: AppColors.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          color: AppColors.outline.withValues(alpha: 0.4),
        ),
        fillColor: AppColors.surfaceContainerLowest,
        filled: true,
        prefixIcon: Icon(prefixIcon, color: AppColors.outline, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String label;
  final IconData icon;

  const _GradientButton({
    required this.isLoading,
    required this.onPressed,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onPrimary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onPrimary,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(icon, color: AppColors.onPrimary, size: 18),
                ],
              ),
      ),
    );
  }
}
