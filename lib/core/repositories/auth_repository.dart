import '../models/user.dart';
import '../services/hive/hive_auth_service.dart';
import '../services/remote/remote_auth_service.dart';

class AuthRepository {
  final HiveAuthService _hiveAuthService;
  final RemoteAuthService _remoteAuthService;

  AuthRepository(this._hiveAuthService, this._remoteAuthService);

  // Remote operations
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final result = await _remoteAuthService.register(name, email, password);

    // Create user from response and store locally
    final userData = result['user'];
    final user = User.fromJson(userData);
    user.password = password; // Store password locally for offline use

    await _hiveAuthService.signUp(user);
    await _hiveAuthService.setCurrentUser(user);

    return result;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await _remoteAuthService.login(email, password);

    // Create user from response and store locally
    final userData = result['user'];
    final user = User.fromJson(userData);
    user.password = password; // Store password locally for offline use

    // Check if user exists locally, if not create
    final existingUser = _hiveAuthService.login(email, password);
    if (existingUser == null) {
      await _hiveAuthService.signUp(user);
    }

    await _hiveAuthService.setCurrentUser(user);

    return result;
  }

  Future<Map<String, dynamic>> getProfile() async {
    return await _remoteAuthService.getProfile();
  }

  Future<void> logout() async {
    await _remoteAuthService.logout();
    await _hiveAuthService.logout();
  }

  // Local operations (fallback)
  User? getCurrentUser() {
    return _hiveAuthService.getCurrentUser();
  }

  Future<bool> isLoggedIn() async {
    return await _remoteAuthService.isLoggedIn();
  }
}
