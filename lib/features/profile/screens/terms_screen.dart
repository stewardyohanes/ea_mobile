import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.description_outlined, size: 20),
            const SizedBox(width: 8),
            const Text('Terms of Service'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: const [
          _Section(
            title: '1. Acceptance of Terms',
            body:
                'By accessing or using TradeGenZ, you agree to be bound by these Terms of Service. If you do not agree, please do not use the application.',
          ),
          _Section(
            title: '2. Use of Signals',
            body:
                'Trading signals provided by TradeGenZ are for informational purposes only and do not constitute financial advice. You are solely responsible for your own trading decisions.',
          ),
          _Section(
            title: '3. Risk Disclaimer',
            body:
                'Forex and CFD trading carries a high level of risk and may not be suitable for all investors. Past performance of signals does not guarantee future results. You may lose some or all of your invested capital.',
          ),
          _Section(
            title: '4. Subscriptions and Payments',
            body:
                'Premium subscriptions are billed through your device\'s app store. Refunds are subject to the app store\'s refund policy. TradeGenZ reserves the right to modify subscription pricing with prior notice.',
          ),
          _Section(
            title: '5. Account Termination',
            body:
                'TradeGenZ reserves the right to suspend or terminate accounts that violate these terms, engage in fraudulent activity, or abuse the platform.',
          ),
          _Section(
            title: '6. Intellectual Property',
            body:
                'All content, signals, algorithms, and materials within TradeGenZ are the intellectual property of TradeGenZ and may not be reproduced or distributed without permission.',
          ),
          _Section(
            title: '7. Contact',
            body:
                'For questions regarding these terms, please contact us at chloeder29@gmail.com.',
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(body, style: AppTextStyles.body),
        ],
      ),
    );
  }
}
