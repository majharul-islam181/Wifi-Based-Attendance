// import 'package:network_info_plus/network_info_plus.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class WifiService {
//   final String companySsid = 'Taghyeer';

//   Future<bool> isConnectedToCompanyWifi() async {
//     final wifiName = await Connectivity().getWifiName();
//     print("Connected Wi-Fi SSID: $wifiName"); // Debug log
//     return wifiName == companySsid;
//   }
// }

// class WifiService {
//   final NetworkInfo _info = NetworkInfo();

//   Future<String?> getCurrentSSID() async {
//     return await _info.getWifiName();
//   }
// }

// import 'package:wifi_info_flutter/wifi_info_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';

// class WifiService {
//   final String companySsid = 'Taghyeer';

//   Future<String?> getCurrentSSID() async {
//     var status = await Permission.location.request();
//     if (!status.isGranted) {
//       print("Location permission not granted.");
//       return null;
//     }

//     try {
//       final ssid = await WifiInfo().getWifiName();
//       print("Current Wi-Fi SSID: $ssid");
//       return ssid;
//     } catch (e) {
//       print("Error fetching SSID: $e");
//       return null;
//     }
//   }
// }

import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

class WifiService {
  final String companySsid = 'Taghyeer';

  Future<String?> getCurrentSSID() async {
    var status = await Permission.location.request();
    if (!status.isGranted) {
      print("Location permission is not granted. Cannot fetch SSID.");
      return null;
    }

    try {
      final ssid = await WifiInfo().getWifiName();
      print("Current Wi-Fi SSID: $ssid");
      return ssid;
    } catch (e) {
      print("Error fetching SSID: $e");
      return null;
    }
  }

  // Method to automatically check and mark attendance if connected to company Wi-Fi
  Future<bool> checkAndMarkAttendance() async {
    final ssid = await getCurrentSSID();
    if (ssid == companySsid) {
      return true; // Connected to company Wi-Fi
    }
    return false; // Not connected to company Wi-Fi
  }
}
