import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giftly/core/api/api_client.dart';
import 'package:giftly/core/services/hive/hive_auth_service.dart';
import 'package:giftly/core/services/network/network_info.dart';
import 'package:giftly/core/services/remote/remote_auth_service.dart';
import 'package:giftly/core/repositories/auth_repository.dart';

// Network Info Provider - Singleton
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});

// API Client Provider - Singleton
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Remote Auth Service Provider - Singleton
final remoteAuthServiceProvider = Provider<RemoteAuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return RemoteAuthService(apiClient, networkInfo);
});

// Hive Auth Service Provider - Singleton
final hiveAuthServiceProvider = Provider<HiveAuthService>((ref) {
  return HiveAuthService();
});

// Auth Repository Provider - Singleton
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final hiveService = ref.watch(hiveAuthServiceProvider);
  final remoteService = ref.watch(remoteAuthServiceProvider);
  return AuthRepository(hiveService, remoteService);
});

// Stream for connection status
final connectionStatusProvider = StreamProvider<bool>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  return networkInfo.connectionStream;
});
