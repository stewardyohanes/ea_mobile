import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradegenz_app/features/signals/providers/signal_provider.dart';
import '../models/signal_model.dart';
import '../widgets/history_card.dart';
import '../widgets/skeleton_card.dart';
import '../widgets/filter_tab_bar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _scrollController = ScrollController();
  // Filter by status: ALL | TP HIT | SL HIT
  String _activeFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(historySignalsProvider.notifier).fetchInitial(),
    );
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
      ref.read(historySignalsProvider.notifier).fetchMore();
    }
  }

  void _onFilterChanged(String filter) {
    setState(() => _activeFilter = filter);
    // Filter dilakukan client-side dari data yang sudah ada
  }

  List<Signal> _filtered(List<Signal> signals) {
    switch (_activeFilter) {
      case 'TP HIT':
        return signals.where((s) => s.isTpHit).toList();
      case 'SL HIT':
        return signals.where((s) => s.isSlHit).toList();
      default:
        // ALL: tampilkan semua yang sudah selesai (tp_hit + sl_hit + closed)
        return signals.where((s) => !s.isActive).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final signalsState = ref.watch(historySignalsProvider);
    final allCompleted = signalsState.signals.where((s) => !s.isActive).toList();
    final filtered = _filtered(signalsState.signals);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.terminal, size: 20),
            const SizedBox(width: 8),
            const Text('Signal History'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats 2×2 grid — selalu pakai semua completed signals (bukan filtered)
          if (!signalsState.isLoading && allCompleted.isNotEmpty)
            _StatsGrid(signals: allCompleted),

          // Filter tab: ALL | TP HIT | SL HIT
          FilterTabBar(
            activeFilter: _activeFilter,
            onFilterChanged: _onFilterChanged,
          ),

          // List history mengisi sisa ruang
          Expanded(child: _buildBody(signalsState, filtered)),
        ],
      ),
    );
  }

  Widget _buildBody(SignalsState state, List<Signal> filtered) {
    if (state.isLoading) {
      return ListView.builder(
        itemCount: 6,
        itemBuilder: (_, _) => const SkeletonCard(),
      );
    }

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📭', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text('No signals found', style: AppTextStyles.body),
            const SizedBox(height: 8),
            Text(
              _activeFilter == 'ALL'
                  ? 'No completed signals yet'
                  : 'No $_activeFilter signals found',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: () =>
          ref.read(historySignalsProvider.notifier).fetchInitial(),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: filtered.length + 1,
        itemBuilder: (context, index) {
          if (index == filtered.length) {
            return state.isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }
          return HistoryCard(signal: filtered[index]);
        },
      ),
    );
  }
}

// ─── Stats 2×2 Grid ──────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  final List<Signal> signals;
  const _StatsGrid({required this.signals});

  @override
  Widget build(BuildContext context) {
    final total = signals.length;
    final win = signals.where((s) => s.isTpHit).length;
    final loss = signals.where((s) => s.isSlHit).length;
    final winRate = total > 0 ? (win / total * 100) : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _StatTile(
                  label: 'TOTAL',
                  value: total.toString(),
                  color: AppColors.primary,
                ),
                const SizedBox(height: 8),
                _StatTile(
                  label: 'LOSS',
                  value: loss.toString(),
                  color: AppColors.error,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                _StatTile(
                  label: 'WIN',
                  value: win.toString(),
                  color: AppColors.secondaryContainer,
                ),
                const SizedBox(height: 8),
                _StatTile(
                  label: 'WIN RATE',
                  value: '${winRate.toStringAsFixed(0)}%',
                  color: AppColors.tertiary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
