import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/storage/secure_storage.dart';

class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  bool _hasScrolledToBottom = false;
  bool _isAccepted = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Detect kalau user sudah scroll sampai bawah
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Aktifkan checkbox kalau sudah scroll 90% ke bawah
    if (currentScroll >= maxScroll * 0.9 && !_hasScrolledToBottom) {
      setState(() => _hasScrolledToBottom = true);
    }
  }

  Future<void> _onAccept() async {
    await SecureStorage.setDisclaimerAccepted();
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Risk Disclaimer')),
      body: Column(
        children: [
          // Disclaimer text — scrollable
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Warning banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.error,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Please read this disclaimer carefully before using TradeGenZ.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  _DisclaimerSection(
                    title: '1. No Financial Advice',
                    content:
                        'The trading signals provided by TradeGenZ are for informational purposes only and do not constitute financial advice. TradeGenZ is not a licensed financial advisor, broker, or dealer.',
                  ),

                  _DisclaimerSection(
                    title: '2. Risk of Loss',
                    content:
                        'Trading in forex, commodities, and other financial instruments involves a high level of risk and may not be suitable for all investors. You may lose some or all of your invested capital. Never trade with money you cannot afford to lose.',
                  ),

                  _DisclaimerSection(
                    title: '3. Past Performance',
                    content:
                        'Past performance of any trading signal or strategy is not indicative of future results. Markets are unpredictable and no signal service can guarantee profits.',
                  ),

                  _DisclaimerSection(
                    title: '4. Your Responsibility',
                    content:
                        'You are solely responsible for your trading decisions. TradeGenZ and its team shall not be held liable for any losses incurred as a result of using our signals or services.',
                  ),

                  _DisclaimerSection(
                    title: '5. Signal Accuracy',
                    content:
                        'While we strive to provide accurate and timely signals, TradeGenZ does not guarantee the accuracy, completeness, or timeliness of any signal. Market conditions can change rapidly.',
                  ),

                  _DisclaimerSection(
                    title: '6. Independent Verification',
                    content:
                        'We strongly recommend that you conduct your own research and analysis before executing any trade. Consider consulting with a qualified financial advisor if needed.',
                  ),

                  _DisclaimerSection(
                    title: '7. Regulatory Compliance',
                    content:
                        'It is your responsibility to ensure that using TradeGenZ services complies with the laws and regulations in your jurisdiction. TradeGenZ is not responsible for any regulatory issues.',
                  ),

                  const SizedBox(height: 16),

                  // Hint kalau belum scroll sampai bawah
                  if (!_hasScrolledToBottom)
                    Center(
                      child: Text(
                        '↓ Scroll to bottom to continue',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // Bottom section — checkbox + button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(
                  color: AppColors.divider.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: Column(
              children: [
                // Checkbox — hanya aktif setelah scroll sampai bawah
                GestureDetector(
                  onTap: _hasScrolledToBottom
                      ? () => setState(() => _isAccepted = !_isAccepted)
                      : null,
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _isAccepted
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _hasScrolledToBottom
                                ? AppColors.primary
                                : AppColors.divider,
                            width: 2,
                          ),
                        ),
                        child: _isAccepted
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'I have read and agree to the risk disclaimer',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: _hasScrolledToBottom
                                ? AppColors.textPrimary
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Accept button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // Hanya aktif kalau sudah scroll dan checklist
                    onPressed: _isAccepted ? _onAccept : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary.withValues(
                        alpha: 0.3,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'I Understand & Accept',
                      style: TextStyle(
                        color: _isAccepted
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclaimerSection extends StatelessWidget {
  final String title;
  final String content;
  const _DisclaimerSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textMuted,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
