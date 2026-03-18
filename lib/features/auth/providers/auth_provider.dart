import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      final user = User.fromJson(data['user'] as Map<String, dynamic>);

      await SecureStorage.saveToken(token);

      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
