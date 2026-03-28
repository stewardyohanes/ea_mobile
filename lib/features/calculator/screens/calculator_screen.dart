import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tradegenz_app/features/calculator/widgets/pair_selector.dart';
import 'package:tradegenz_app/features/calculator/widgets/result_card.dart';
import 'package:tradegenz_app/features/calculator/widgets/risk_slider.dart';
import 'package:tradegenz_app/features/calculator/widgets/section_card.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _balanceController = TextEditingController(text: '1000');
  final _slPipsController = TextEditingController(text: '50');

  String _selectedPair = 'XAUUSD';
  double _riskPercent = 2.0;

  double? _lotSize;
  double? _riskAmount;

  String get _riskLabel {
    if (_riskPercent <= 1) return 'Conservative';
    if (_riskPercent <= 2) return 'Moderate';
    if (_riskPercent <= 3) return 'Aggressive';
    return 'Very High Risk';
  }

  Color get _riskColor {
    if (_riskPercent <= 1) return AppColors.success;
    if (_riskPercent <= 2) return AppColors.primary;
    if (_riskPercent <= 3) return AppColors.gold;
    return AppColors.error;
  }

  double _getPipValue(String pair) {
    switch (pair) {
      case 'XAUUSD':
        return 0.10;
      case 'XAGUSD':
        return 0.05;
      case 'USDJPY':
        return 0.067;
      default:
        return 0.10;
    }
  }

  @override
  void initState() {
    super.initState();
    _balanceController.addListener(_calculate);
    _slPipsController.addListener(_calculate);
    _calculate();
  }

  @override
  void dispose() {
    _balanceController.dispose();
    _slPipsController.dispose();
    super.dispose();
  }

  void _calculate() {
    final balance = double.tryParse(_balanceController.text);
    final slPips = double.tryParse(_slPipsController.text);

    if (balance == null || slPips == null) return;
    if (balance <= 0 || slPips <= 0) return;

    final pipValuePerMicroLot = _getPipValue(_selectedPair);
    final riskAmount = balance * (_riskPercent / 100);
    final microLots = riskAmount / (slPips * pipValuePerMicroLot);

    setState(() {
      _riskAmount = riskAmount;
      _lotSize = microLots / 100;
    });
  }

  void _reset() {
    HapticFeedback.lightImpact();
    _balanceController.text = '1000';
    _slPipsController.text = '50';
    setState(() {
      _selectedPair = 'XAUUSD';
      _riskPercent = 2.0;
    });
    _calculate();
  }

  InputDecoration _inputDecoration({
    String? hint,
    String? prefix,
    String? suffix,
    Color? focusColor,
  }) {
    return InputDecoration(
      prefixText: prefix,
      suffixText: suffix,
      prefixStyle: AppTextStyles.h3.copyWith(color: AppColors.textMuted),
      suffixStyle: AppTextStyles.body.copyWith(color: AppColors.textMuted),
      hintText: hint,
      hintStyle: AppTextStyles.h3.copyWith(color: AppColors.divider),
      filled: true,
      fillColor: AppColors.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: focusColor ?? AppColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.terminal, size: 20),
            const SizedBox(width: 8),
            const Text('Lot Size Calculator'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded),
            onPressed: _reset,
            tooltip: 'Reset',
          ),
        ],
      ),
      body: Column(
        children: [
          // Result card — FIXED, tidak ikut scroll
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: ResultCard(
              lotSize: _lotSize,
              riskAmount: _riskAmount,
              riskPercent: _riskPercent,
              riskColor: _riskColor,
              riskLabel: _riskLabel,
              pair: _selectedPair,
            ).animate().fadeIn(duration: 400.ms),
          ),

          const SizedBox(height: 8),

          Divider(color: AppColors.divider.withValues(alpha: 0.5), height: 1),

          // Input area — scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SectionCard(
                    title: 'Trading Pair',
                    icon: Icons.currency_exchange,
                    child: PairSelector(
                      selectedPair: _selectedPair,
                      onChanged: (pair) {
                        setState(() => _selectedPair = pair);
                        _calculate();
                      },
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                  const SizedBox(height: 12),

                  SectionCard(
                    title: 'Account Balance',
                    icon: Icons.account_balance_wallet_rounded,
                    child: TextField(
                      controller: _balanceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d*'),
                        ),
                      ],
                      style: AppTextStyles.h3,
                      decoration: _inputDecoration(hint: '1000', prefix: '\$ '),
                    ),
                  ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

                  const SizedBox(height: 12),

                  SectionCard(
                    title: 'Risk per Trade',
                    icon: Icons.shield_rounded,
                    iconColor: _riskColor,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _riskColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _riskLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: _riskColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    child: RiskSlider(
                      value: _riskPercent,
                      riskColor: _riskColor,
                      riskLabel: _riskLabel,
                      onChanged: (value) {
                        setState(() => _riskPercent = value);
                        _calculate();
                      },
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                  const SizedBox(height: 12),

                  SectionCard(
                    title: 'Stop Loss',
                    icon: Icons.remove_circle_outline_rounded,
                    iconColor: AppColors.error,
                    child: TextField(
                      controller: _slPipsController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d*'),
                        ),
                      ],
                      style: AppTextStyles.h3,
                      decoration: _inputDecoration(
                        hint: '50',
                        suffix: 'pips',
                        focusColor: AppColors.error,
                      ),
                    ),
                  ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

                  const SizedBox(height: 24),

                  // CALCULATE POSITION button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryContainer],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        _calculate();
                      },
                      icon: const Icon(
                        Icons.calculate_outlined,
                        color: AppColors.onPrimary,
                        size: 20,
                      ),
                      label: Text(
                        'CALCULATE POSITION',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
