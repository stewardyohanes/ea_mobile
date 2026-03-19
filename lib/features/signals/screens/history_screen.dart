import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tradegenz_app/features/signals/providers/signal_provider.dart';
import '../widgets/signal_card.dart';
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
  String _activeFilter = 'ALL'; // state lokal untuk filter aktif

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
      final direction = _activeFilter == 'ALL' ? null : _activeFilter;
      ref.read(signalsProvider.notifier).fetchMore(direction: direction);
    }
  }

  void _onFilterChanged(String filter) {
    setState(() => _activeFilter = filter);
    // Fetch ulang dengan filter baru
    final direction = filter == 'ALL' ? null : filter;
    ref.read(signalsProvider.notifier).fetchInitial(direction: direction);
  }

  @override
  Widget build(BuildContext context) {
    final signalsState = ref.watch(signalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: Column(
        children: [
          // Filter tab — selalu tampil di atas
          FilterTabBar(
            activeFilter: _activeFilter,
            onFilterChanged: _onFilterChanged,
          ),

          // List sinyal mengisi sisa ruang
          // Expanded = setara flex: 1 di RN, mengisi sisa tinggi
          Expanded(child: _buildBody(signalsState)),
        ],
      ),
    );
  }

  Widget _buildBody(SignalsState state) {
    if (state.isLoading) {
      return ListView.builder(
        itemCount: 6,
        itemBuilder: (_, __) => const SkeletonCard(),
      );
    }

    if (state.signals.isEmpty) {
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
                  ? 'No signals yet'
                  : 'No ${_activeFilter} signals found',
              style: AppTextStyles.label,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      onRefresh: () {
        final direction = _activeFilter == 'ALL' ? null : _activeFilter;
        return ref
            .read(signalsProvider.notifier)
            .fetchInitial(direction: direction);
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.signals.length + 1,
        itemBuilder: (context, index) {
          if (index == state.signals.length) {
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
          return SignalCard(signal: state.signals[index]);
        },
      ),
    );
  }
}
