import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tradegenz_app/core/notifications/fcm_service.dart';
import 'package:tradegenz_app/core/storage/secure_storage.dart';
import 'package:tradegenz_app/features/auth/data/auth_api.dart';
import 'package:tradegenz_app/shared/models/user_model.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get isAuthenticated => user != null;
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await AuthApi.login(email: email, password: password);
      final token = data['token'] as String;
      final refreshToken = data['refresh_token'] as String;
      final user = User.fromJson(data['user'] as Map<String, dynamic>);

      await SecureStorage.saveToken(token);
      await SecureStorage.saveRefreshToken(refreshToken);
      state = state.copyWith(user: user, isLoading: false);

      if (user.isPremium) {
        await FcmService.initialize();
      }
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] as String? ??
          e.response?.data['error'] as String? ??
          'Something went wrong. Please try again.';
      state = state.copyWith(isLoading: false, error: message);
    } on Exception {
      state = state.copyWith(
        isLoading: false,
        error: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await AuthApi.register(
        name: name,
        email: email,
        password: password,
      );
      final token = data['token'] as String;
      final user = User.fromJson(data['user'] as Map<String, dynamic>);

      await SecureStorage.saveToken(token);
      state = state.copyWith(user: user, isLoading: false);
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] as String? ??
          e.response?.data['error'] as String? ??
          'Something went wrong. Please try again.';
      state = state.copyWith(isLoading: false, error: message);
    } on Exception {
      state = state.copyWith(
        isLoading: false,
        error: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> checkSession() async {
    final token = await SecureStorage.getToken();
    if (token == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await AuthApi.getMe();
      state = state.copyWith(user: user, isLoading: false);
      if (user.isPremium) await FcmService.initialize();
    } on Exception {
      await SecureStorage.deleteToken();
      state = const AuthState();
    }
  }

  /// Dipanggil setelah IAP berhasil diverifikasi backend — refresh JWT + data user.
  Future<void> refreshUser() async {
    try {
      // Refresh JWT so the new token contains updated plan (premium)
      final refreshToken = await SecureStorage.getRefreshToken();
      if (refreshToken != null) {
        final tokenData = await AuthApi.refresh(refreshToken);
        await SecureStorage.saveToken(tokenData['token'] as String);
        if (tokenData['refresh_token'] != null) {
          await SecureStorage.saveRefreshToken(tokenData['refresh_token'] as String);
        }
      }

      final user = await AuthApi.getMe();
      state = state.copyWith(user: user);
      if (user.isPremium) await FcmService.initialize();
    } on Exception {
      // If refresh fails, keep existing state — no logout needed
    }
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
    await SecureStorage.deleteRefreshToken();
    await FcmService.deleteToken();
    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
