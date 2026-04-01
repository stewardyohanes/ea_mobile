import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tradegenz_app/features/auth/providers/auth_provider.dart';
import 'package:tradegenz_app/features/subscription/data/iap_service.dart';
import 'package:tradegenz_app/features/subscription/data/subscription_api.dart';

class SubscriptionState {
  final Map<String, ProductDetails> products;
  final bool isLoading;
  final bool isPurchasing;
  final String? error;
  final bool purchaseSuccess;

  const SubscriptionState({
    this.products = const {},
    this.isLoading = false,
    this.isPurchasing = false,
    this.error,
    this.purchaseSuccess = false,
  });

  SubscriptionState copyWith({
    Map<String, ProductDetails>? products,
    bool? isLoading,
    bool? isPurchasing,
    String? error,
    bool? purchaseSuccess,
    bool clearError = false,
  }) {
    return SubscriptionState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      error: clearError ? null : (error ?? this.error),
      purchaseSuccess: purchaseSuccess ?? this.purchaseSuccess,
    );
  }
}

class SubscriptionNotifier extends Notifier<SubscriptionState> {
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  @override
  SubscriptionState build() {
    // Listen ke stream pembelian dari Play Store
    _purchaseSubscription = IAPService.instance.purchaseStream.listen(
      _handlePurchaseUpdate,
      onError: (error) {
        state = state.copyWith(
          isPurchasing: false,
          error: 'Purchase stream error: $error',
        );
      },
    );

    // Cleanup saat provider di-dispose
    ref.onDispose(() => _purchaseSubscription?.cancel());

    return const SubscriptionState();
  }

  /// Load ProductDetails dari Play Store (harga dalam Rupiah).
  Future<void> loadProducts() async {
    final available = await IAPService.instance.isAvailable();
    if (!available) {
      state = state.copyWith(error: 'Play Store is not available');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final products = await IAPService.instance.loadProducts();
      state = state.copyWith(products: products, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Mulai alur pembelian subscription.
  Future<void> purchase(String productId) async {
    final product = state.products[productId];
    if (product == null) {
      state = state.copyWith(error: 'Product not found. Please try again.');
      return;
    }

    state = state.copyWith(isPurchasing: true, clearError: true, purchaseSuccess: false);
    try {
      await IAPService.instance.buySubscription(product);
      // Hasil pembelian akan masuk via _handlePurchaseUpdate
    } catch (e) {
      state = state.copyWith(isPurchasing: false, error: e.toString());
    }
  }

  /// Restore purchases untuk user yang reinstall app.
  Future<void> restore() async {
    state = state.copyWith(isPurchasing: true, clearError: true);
    try {
      await IAPService.instance.restorePurchases();
    } catch (e) {
      state = state.copyWith(isPurchasing: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void clearSuccess() {
    state = state.copyWith(purchaseSuccess: false);
  }

  Future<void> _handlePurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _verifyAndActivate(purchase);
          break;

        case PurchaseStatus.error:
          state = state.copyWith(
            isPurchasing: false,
            error: purchase.error?.message ?? 'Purchase failed. Please try again.',
          );
          await IAPService.instance.completePurchase(purchase);
          break;

        case PurchaseStatus.canceled:
          state = state.copyWith(isPurchasing: false);
          break;

        case PurchaseStatus.pending:
          // Pembayaran pending (transfer bank, dll) — biarkan loading
          break;
      }
    }
  }

  Future<void> _verifyAndActivate(PurchaseDetails purchase) async {
    try {
      // Verifikasi ke backend → backend verifikasi ke Google Play API
      await SubscriptionApi.verifyPurchase(
        purchaseToken: purchase.verificationData.serverVerificationData,
        productId: purchase.productID,
      );

      // Tandai selesai ke Play Store
      await IAPService.instance.completePurchase(purchase);

      // Refresh user state agar UI langsung unlock premium
      await ref.read(authProvider.notifier).refreshUser();

      state = state.copyWith(isPurchasing: false, purchaseSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isPurchasing: false,
        error: 'Purchase verification failed: ${e.toString()}',
      );
      // Complete purchase to avoid stuck state
      await IAPService.instance.completePurchase(purchase);
    }
  }
}

final subscriptionProvider =
    NotifierProvider<SubscriptionNotifier, SubscriptionState>(
  SubscriptionNotifier.new,
);
