import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tradegenz_app/features/signals/data/signals_api.dart';
import 'package:tradegenz_app/features/signals/models/signal_model.dart';

class SignalsState {
  final List<Signal> signals;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String? error;

  const SignalsState({
    this.signals = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
  });

  SignalsState copyWith({
    List<Signal>? signals,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? error,
  }) {
    return SignalsState(
      signals: signals ?? this.signals,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error ?? this.error,
    );
  }
}

class SignalNotifier extends Notifier<SignalsState> {
  @override
  SignalsState build() => const SignalsState();

  Future<void> fetchInitial({
    String? direction,
    String? scope,
    String? historyStatus,
  }) async {
    state = state.copyWith(isLoading: true, error: null, signals: []);
    try {
      final signals = scope == 'history'
          ? await SignalsApi.getHistory(page: 1, status: historyStatus)
          : await SignalsApi.getSignals(
              page: 1,
              direction: direction,
              scope: scope,
            );

      state = state.copyWith(
        signals: signals,
        isLoading: false,
        currentPage: 1,
        hasMore: signals.length == 20,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch signals',
      );
    }
  }

  Future<void> fetchMore({
    String? direction,
    String? scope,
    String? historyStatus,
  }) async {
    if (!state.hasMore || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true, error: null);

    try {
      final nextPage = state.currentPage + 1;
      final newSignals = scope == 'history'
          ? await SignalsApi.getHistory(page: nextPage, status: historyStatus)
          : await SignalsApi.getSignals(
              page: nextPage,
              direction: direction,
              scope: scope,
            );

      state = state.copyWith(
        signals: [...state.signals, ...newSignals],
        isLoadingMore: false,
        currentPage: nextPage,
        hasMore: newSignals.length == 20,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: 'Failed to fetch more signals',
      );
    }
  }
}

final signalsProvider = NotifierProvider<SignalNotifier, SignalsState>(
  SignalNotifier.new,
);

/// Provider terpisah untuk History screen — tidak konflik dengan Feed.
final historySignalsProvider = NotifierProvider<SignalNotifier, SignalsState>(
  SignalNotifier.new,
);
