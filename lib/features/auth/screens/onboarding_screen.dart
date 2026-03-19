import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:tradegenz_app/core/storage/secure_storage.dart';
import 'package:tradegenz_app/core/theme/app_colors.dart';
import 'package:tradegenz_app/core/theme/app_text_styles.dart';

class _OnboardingPage {
  final String lottieAsset;
  final String title;
  final String subtitle;
  final Color accentColor;

  const _OnboardingPage({
    required this.lottieAsset,
    required this.title,
    required this.subtitle,
    required this.accentColor,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      lottieAsset: 'assets/animations/business-sales-profit.json',
      title: 'Professional\nTrading Signals',
      subtitle:
          'Get real-time forex signals from\nprofessional Expert Advisors',
      accentColor: AppColors.primary,
    ),
    _OnboardingPage(
      lottieAsset: 'assets/animations/business-win.json',
      title: 'Proven Track\nRecord',
      subtitle: 'Join 10,000+ traders with\nan average 80% win rate',
      accentColor: AppColors.success,
    ),
    _OnboardingPage(
      lottieAsset: 'assets/animations/phone-notification.json',
      title: 'Real-Time\nAlerts',
      subtitle: 'Never miss a signal with\ninstant push notifications',
      accentColor: AppColors.gold,
    ),
    _OnboardingPage(
      lottieAsset: 'assets/animations/rocket.json',
      title: 'Start Trading\nSmarter Today',
      subtitle: 'Free plan available.\nUpgrade anytime for full access.',
      accentColor: AppColors.purple,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onGetStarted() async {
    await SecureStorage.setOnboardingDone();
    if (mounted) context.go('/login');
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;
    final currentAccent = _pages[_currentPage].accentColor;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              currentAccent.withValues(alpha: 0.15),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8),
                  child: TextButton(
                    onPressed: _onGetStarted,
                    child: Text(
                      'Skip',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    return _PageContent(
                      page: _pages[index],
                      key: ValueKey(index),
                    );
                  },
                ),
              ),

              // Dot indicator + button
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => _Dot(
                          isActive: index == _currentPage,
                          color: currentAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    onPressed: isLastPage ? _onGetStarted : _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        isLastPage ? 'Get Started 🚀' : 'Next',
                        key: ValueKey(isLastPage),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  final _OnboardingPage page;
  const _PageContent({required this.page, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie animation
          SizedBox(
                width: 280,
                height: 280,
                child: Lottie.asset(
                  page.lottieAsset,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              )
              .animate()
              .fadeIn(duration: 500.ms)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 500.ms,
                curve: Curves.easeOut,
              ),

          const SizedBox(height: 40),

          // Title — slide up + fade, delay 200ms
          Text(page.title, style: AppTextStyles.h1, textAlign: TextAlign.center)
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms)
              .slideY(
                begin: 0.3, // mulai dari 30% di bawah posisi asli
                end: 0,
                delay: 200.ms,
                duration: 400.ms,
                curve: Curves.easeOut,
              ),

          const SizedBox(height: 16),

          // Subtitle — slide up + fade, delay 400ms
          Text(
                page.subtitle,
                style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              )
              .animate()
              .fadeIn(delay: 400.ms, duration: 400.ms)
              .slideY(
                begin: 0.3,
                end: 0,
                delay: 400.ms,
                duration: 400.ms,
                curve: Curves.easeOut,
              ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool isActive;
  final Color color;
  const _Dot({required this.isActive, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? color : AppColors.textMuted.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
