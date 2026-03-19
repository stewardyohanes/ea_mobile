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

  Future<void> fetchInitial({String? direction}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final signals = await SignalsApi.getSignals(
        page: 1,
        direction: direction,
      );

      final result = signals.isEmpty ? _mockSignals(direction) : signals;

      state = state.copyWith(
        signals: result,
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

  Future<void> fetchMore({String? direction}) async {
    if (!state.hasMore || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true, error: null);

    try {
      final nextPage = state.currentPage + 1;
      final newSignals = await SignalsApi.getSignals(
        page: nextPage,
        direction: direction,
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

  List<Signal> _mockSignals(String? direction) {
    final all = [
      Signal(
        id: '1',
        pair: 'XAUUSD',
        direction: 'BUY',
        status: 'active',
        entryPrice: 2345.50,
        stopLoss: 2330.00,
        takeProfit1: 2365.00,
        takeProfit2: 2380.00,
        takeProfit3: 2400.00,
        riskRewardRatio: 3,
        createdAt: DateTime.now().toIso8601String(),
      ),
      Signal(
        id: '2',
        pair: 'EURUSD',
        direction: 'SELL',
        status: 'tp_hit',
        entryPrice: 1.0850,
        stopLoss: 1.0900,
        takeProfit1: 1.0800,
        takeProfit2: 1.0770,
        riskRewardRatio: 2,
        createdAt: DateTime.now()
            .subtract(const Duration(hours: 3))
            .toIso8601String(),
        closedAt: DateTime.now().toIso8601String(),
      ),
      Signal(
        id: '3',
        pair: 'GBPUSD',
        direction: 'BUY',
        status: 'active',
        entryPrice: 1.2650,
        stopLoss: 1.2600,
        takeProfit1: 1.2720,
        riskRewardRatio: 2,
        createdAt: DateTime.now()
            .subtract(const Duration(hours: 1))
            .toIso8601String(),
      ),
      Signal(
        id: '4',
        pair: 'USDJPY',
        direction: 'SELL',
        status: 'sl_hit',
        entryPrice: 149.50,
        stopLoss: 150.20,
        takeProfit1: 148.50,
        riskRewardRatio: 1,
        createdAt: DateTime.now()
            .subtract(const Duration(hours: 5))
            .toIso8601String(),
        closedAt: DateTime.now()
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
      ),
      Signal(
        id: '5',
        pair: 'XAUUSD',
        direction: 'SELL',
        status: 'closed',
        entryPrice: 2360.00,
        stopLoss: 2375.00,
        takeProfit1: 2340.00,
        takeProfit2: 2320.00,
        riskRewardRatio: 2,
        createdAt: DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
        closedAt: DateTime.now()
            .subtract(const Duration(hours: 10))
            .toIso8601String(),
      ),
    ];

    // Filter berdasarkan direction kalau ada
    if (direction != null) {
      return all.where((s) => s.direction == direction).toList();
    }
    return all;
  }
}

final signalsProvider = NotifierProvider<SignalNotifier, SignalsState>(
  SignalNotifier.new,
);
