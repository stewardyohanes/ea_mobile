import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradegenz_app/core/extensions/l10n_extension.dart';
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
  String _activeFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(historySignalsProvider.notifier)
          .fetchInitial(scope: 'history'),
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
      ref.read(historySignalsProvider.notifier).fetchMore(scope: 'history');
    }
  }

  void _onFilterChanged(String filter) {
    setState(() => _activeFilter = filter);
  }

  List<Signal> _outcomes(List<Signal> signals) {
    return signals.where((s) => s.isTpHit || s.isSlHit || s.isClosed).toList();
  }

  List<Signal> _systemEvents(List<Signal> signals) {
    return signals.where((s) => s.isReplaced || s.isCancelled).toList();
  }

  List<Signal> _filtered(List<Signal> signals) {
    final outcomes = _outcomes(signals);
    final system = _systemEvents(signals);
    switch (_activeFilter) {
      case 'WIN':
        return outcomes.where((s) => s.isTpHit || s.isClosedWin).toList();
      case 'LOSS':
        return outcomes
            .where((s) => s.isSlHit || (s.isClosed && !s.isClosedWin))
            .toList();
      case 'SYSTEM':
        return system;
      default:
        return outcomes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final signalsState = ref.watch(historySignalsProvider);
    final allOutcomes = _outcomes(signalsState.signals);
    final filtered = _filtered(signalsState.signals);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.terminal, size: 20),
            const SizedBox(width: 8),
            Text(l10n.signalHistoryTitle),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      body: Column(
        children: [
          if (!signalsState.isLoading &&
              allOutcomes.isNotEmpty &&
              _activeFilter != 'SYSTEM')
            _StatsGrid(signals: allOutcomes),

          FilterTabBar(
            activeFilter: _activeFilter,
            onFilterChanged: _onFilterChanged,
          ),

          Expanded(child: _buildBody(context, signalsState, filtered)),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SignalsState state,
    List<Signal> filtered,
  ) {
    final l10n = context.l10n;
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
            Text(l10n.noSignalsFound, style: AppTextStyles.body),
            const SizedBox(height: 8),
            Text(
              _activeFilter == 'ALL'
                  ? l10n.noCompletedSignalsYet
                  : l10n.noFilterSignalsFound(_activeFilter),
              style: AppTextStyles.caption,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: () => ref
          .read(historySignalsProvider.notifier)
          .fetchInitial(scope: 'history'),
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

class _StatsGrid extends StatelessWidget {
  final List<Signal> signals;
  const _StatsGrid({required this.signals});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = signals.length;
    final win = signals.where((s) => s.isTpHit || s.isClosedWin).length;
    final loss = signals
        .where((s) => s.isSlHit || (s.isClosed && !s.isClosedWin))
        .length;
    final winRate = total > 0 ? (win / total * 100) : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _StatTile(
                  label: l10n.totalLabel,
                  value: total.toString(),
                  color: AppColors.primary,
                ),
                const SizedBox(height: 8),
                _StatTile(
                  label: l10n.lossLabel,
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
                  label: l10n.winLabel,
                  value: win.toString(),
                  color: AppColors.secondaryContainer,
                ),
                const SizedBox(height: 8),
                _StatTile(
                  label: l10n.winRateLabel,
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
