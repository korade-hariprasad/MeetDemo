import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkHelper {
  final Connectivity _connectivity = Connectivity();

  Future<bool> isConnected() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false; // Not connected to any network.
    }

    // Perform a ping to check for internet access.
    return await _hasInternetAccess();
  }

  Future<bool> _hasInternetAccess() async {
    try {
      // Try pinging a reliable server like google.com.
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      // If an error occurs, it means there is no internet access.
      return false;
    }
  }
}