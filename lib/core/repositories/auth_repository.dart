import '../models/user.dart';
import '../services/hive/hive_auth_service.dart';
import '../services/remote/remote_auth_service.dart';

class AuthRepository {
  final HiveAuthService _hiveAuthService;
  final RemoteAuthService _remoteAuthService;

  AuthRepository(this._hiveAuthService, this._remoteAuthService);

  // Remote operations
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final result = await _remoteAuthService.register(
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    // Create user from response and store locally
    final userData = result['newUser'] ?? result['user'];
    final user = User.fromJson(userData);
    user.password = password; // Store password locally for offline use

    await _hiveAuthService.signUp(user);
    await _hiveAuthService.setCurrentUser(user);

    return result;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await _remoteAuthService.login(email, password);

    // Create user from response and store locally
    final userData = result['newUser'] ?? result['user'];
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

  Future<Map<String, dynamic>> getProfile({String? userId}) async {
    return await _remoteAuthService.getProfile(userId: userId);
  }

  Future<User> updateProfile({
    required String firstName,
    required String lastName,
    required String username,
    String? imagePath,
  }) async {
    final currentUser = _hiveAuthService.getCurrentUser();
    if (currentUser?.id == null || currentUser!.id!.isEmpty) {
      throw Exception('User ID not found. Please login again.');
    }
    final result = await _remoteAuthService.updateProfile(
      userId: currentUser.id!,
      firstName: firstName,
      lastName: lastName,
      username: username,
      imagePath: imagePath,
    );
    final userData = result['user'] ?? result['data'] ?? result;
    final updatedUser = User.fromJson(userData);

    if (currentUser != null) {
      if (updatedUser.password.isEmpty) {
        updatedUser.password = currentUser.password;
      }
      if ((updatedUser.profilePicture == null ||
              updatedUser.profilePicture!.isEmpty) &&
          (currentUser.profilePicture != null &&
              currentUser.profilePicture!.isNotEmpty)) {
        updatedUser.profilePicture = currentUser.profilePicture;
      }
      if ((updatedUser.firstName == null ||
              updatedUser.firstName!.trim().isEmpty) &&
          (currentUser.firstName != null &&
              currentUser.firstName!.trim().isNotEmpty)) {
        updatedUser.firstName = currentUser.firstName;
      }
      if ((updatedUser.lastName == null ||
              updatedUser.lastName!.trim().isEmpty) &&
          (currentUser.lastName != null &&
              currentUser.lastName!.trim().isNotEmpty)) {
        updatedUser.lastName = currentUser.lastName;
      }
      if ((updatedUser.username == null ||
              updatedUser.username!.trim().isEmpty) &&
          (currentUser.username != null &&
              currentUser.username!.trim().isNotEmpty)) {
        updatedUser.username = currentUser.username;
      }
    }

    await _hiveAuthService.updateUser(
      updatedUser,
      previousEmail: currentUser?.email,
    );

    return updatedUser;
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

  /// Request password reset OTP
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    return await _remoteAuthService.forgotPassword(email);
  }

  /// Verify OTP code
  Future<Map<String, dynamic>> verifyOTP(String email, String otp) async {
    return await _remoteAuthService.verifyOTP(email, otp);
  }

  /// Reset password with OTP
  Future<Map<String, dynamic>> resetPasswordWithOTP({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await _remoteAuthService.resetPasswordWithOTP(
      email: email,
      otp: otp,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
