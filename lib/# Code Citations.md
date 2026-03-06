# Code Citations

## License: unknown
https://github.com/NickNterm/P2P-CarRentClone/tree/3f377e841be1b925035cbf687c5d4c4bc0949981/p2p_clone/lib/core/network/network_info.dart

```
package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    final result = await connectivity
```

