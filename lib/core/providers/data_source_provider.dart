import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:giftly/core/api/api_client.dart';
import 'package:giftly/core/services/network/network_info.dart';
import 'package:giftly/core/services/remote/auth_remote_data_source.dart';

// Network Info Provider
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});

// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Auth Remote Data Source Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return AuthRemoteDataSource(apiClient: apiClient, networkInfo: networkInfo);
});
