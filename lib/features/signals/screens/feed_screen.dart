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
  String _activeFilter = 'ALL';

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

  void _onFilterChanged(String filter) {
    setState(() => _activeFilter = filter);
  }

  @override
  Widget build(BuildContext context) {
    final signalsState = ref.watch(signalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.terminal, size: 20),
            const SizedBox(width: 8),
            Text(
              'TradeGenZ',
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            color: AppColors.textMuted,
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Horizontal scrollable filter chips
          _FilterChipsRow(
            activeFilter: _activeFilter,
            onFilterChanged: _onFilterChanged,
          ),
          // Main content
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              onRefresh: () =>
                  ref.read(signalsProvider.notifier).fetchInitial(),
              child: _buildBody(signalsState),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SignalsState state) {
    // Filter signals by active symbol filter
    final filtered = _activeFilter == 'ALL'
        ? state.signals
        : state.signals
            .where((s) => s.symbol == _activeFilter)
            .toList();

    if (state.isLoading) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (_, _) => const SkeletonCard(),
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

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 48,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'No signals yet',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 8),
            Text(
              _activeFilter == 'ALL'
                  ? 'Check back later for new signals'
                  : 'No signals for $_activeFilter',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: filtered.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) return const MarketSessionWidget();
        if (index == filtered.length + 1) {
          return state.isLoadingMore
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              : const SizedBox.shrink();
        }
        return SignalCard(signal: filtered[index - 1]);
      },
    );
  }
}

// --- Horizontal scrollable filter chips ---
class _FilterChipsRow extends StatelessWidget {
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  static const _filters = ['ALL', 'XAUUSD', 'XAGUSD', 'EURUSD', 'USDJPY'];

  const _FilterChipsRow({
    required this.activeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isActive = activeFilter == filter;
          return GestureDetector(
            onTap: () => onFilterChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filter,
                style: AppTextStyles.label.copyWith(
                  color: isActive ? AppColors.onPrimary : AppColors.textMuted,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
