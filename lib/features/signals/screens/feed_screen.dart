import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tradegenz_app/features/signals/providers/signal_provider.dart';
import '../widgets/signal_card.dart';
import '../widgets/market_session_widget.dart';
import '../widgets/skeleton_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(signalsProvider.notifier).fetchInitial());
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
    if (currentScroll >= maxScroll - 200) {
      ref.read(signalsProvider.notifier).fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final signalsState = ref.watch(signalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TradeGenZ'),
        actions: [
          if (signalsState.signals.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${signalsState.signals.where((s) => s.isActive).length} Active',
                style: AppTextStyles.caption.copyWith(color: AppColors.primary),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () => ref.read(signalsProvider.notifier).fetchInitial(),
        child: _buildBody(signalsState),
      ),
    );
  }

  Widget _buildBody(SignalsState state) {
    if (state.isLoading) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (_, __) => const SkeletonCard(),
      );
    }

    if (state.error != null && state.signals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.error!, style: AppTextStyles.body),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.read(signalsProvider.notifier).fetchInitial(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.signals.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('📭', style: TextStyle(fontSize: 48)),
            SizedBox(height: 16),
            Text(
              'No signals yet',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Check back later for new signals',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: state.signals.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) return const MarketSessionWidget();
        if (index == state.signals.length + 1) {
          return state.isLoadingMore
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              : const SizedBox.shrink();
        }
        return SignalCard(signal: state.signals[index - 1]);
      },
    );
  }
}
