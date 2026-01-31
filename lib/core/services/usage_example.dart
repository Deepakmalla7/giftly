// Example: How to use NetworkInfo and RemoteAuthService in your widgets
//
// 1. Check internet connection before calling API:
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:giftly/core/providers/service_providers.dart';
//
// class LoginPage extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authRepository = ref.watch(authRepositoryProvider);
//     final connectionStatus = ref.watch(connectionStatusProvider);
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: connectionStatus.when(
//         data: (isConnected) {
//           return Column(
//             children: [
//               // Show connection status
//               Container(
//                 color: isConnected ? Colors.green : Colors.red,
//                 padding: EdgeInsets.all(8),
//                 child: Text(
//                   isConnected ? '✓ Online' : '✗ Offline',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               // Login form
//               if (isConnected)
//                 ElevatedButton(
//                   onPressed: () async {
//                     try {
//                       final result = await authRepository.login(
//                         'user@example.com',
//                         'password123',
//                       );
//                       // Handle success
//                       print('Login successful: $result');
//                     } catch (e) {
//                       // Handle error
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Error: ${e.toString()}')),
//                       );
//                     }
//                   },
//                   child: Text('Login'),
//                 )
//               else
//                 Text('No internet connection. Please connect and try again.'),
//             ],
//           );
//         },
//         loading: () => Center(child: CircularProgressIndicator()),
//         error: (error, stack) => Center(child: Text('Error: $error')),
//       ),
//     );
//   }
// }
//
// 2. Alternative: Direct NetworkInfo check
//
// final networkInfo = ref.watch(networkInfoProvider);
// final isConnected = await networkInfo.isConnected;
// if (isConnected) {
//   // Make API call
// } else {
//   // Show offline message
// }
