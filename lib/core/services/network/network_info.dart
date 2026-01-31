import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get connectionStream;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity = Connectivity();

  bool _isConnectedResult(dynamic result) {
    if (result is List<ConnectivityResult>) {
      return result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.ethernet);
    } else if (result is ConnectivityResult) {
      return result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet;
    }
    return false;
  }

  @override
  Future<bool> get isConnected async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _isConnectedResult(results);
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<bool> get connectionStream {
    return _connectivity.onConnectivityChanged
        .map((results) => _isConnectedResult(results))
        .distinct();
  }
}
