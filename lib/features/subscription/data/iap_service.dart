import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

const Set<String> kProductIds = {'premium_monthly', 'premium_yearly'};

class IAPService {
  IAPService._();

  static final IAPService instance = IAPService._();

  final InAppPurchase _iap = InAppPurchase.instance;

  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  Future<bool> isAvailable() => _iap.isAvailable();

  /// Load ProductDetails dari Play Store (harga dalam mata uang lokal user).
  Future<Map<String, ProductDetails>> loadProducts() async {
    final response = await _iap.queryProductDetails(kProductIds);
    final map = <String, ProductDetails>{};
    for (final product in response.productDetails) {
      map[product.id] = product;
    }
    return map;
  }

  /// Mulai alur pembelian subscription.
  Future<void> buySubscription(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    // Subscription di Android menggunakan buyNonConsumable
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Restore purchases (untuk pengguna yang reinstall app).
  Future<void> restorePurchases() => _iap.restorePurchases();

  /// Tandai purchase sebagai selesai diproses.
  Future<void> completePurchase(PurchaseDetails purchase) =>
      _iap.completePurchase(purchase);
}
