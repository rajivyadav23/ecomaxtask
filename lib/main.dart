// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:battery/battery.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BatteryPercentageScreen(),
    );
  }
}

class BatteryPercentageScreen extends StatefulWidget {
  const BatteryPercentageScreen({super.key});

  @override
  _BatteryPercentageScreenState createState() =>
      _BatteryPercentageScreenState();
}

class _BatteryPercentageScreenState extends State<BatteryPercentageScreen> {
  // ignore: unused_field
  final Battery _battery = Battery();
  String _batteryPercentage = 'Unknown';
  String _wifiState = 'Unknown';
  String _macAddress = 'Unknown';
  List<String> _bluetoothProtocols = []; // Add Bluetooth protocols list

  // Define method channels
  static const batteryPlatform = MethodChannel('battery_percentage');
  static const wifiPlatform = MethodChannel('wifi_state');
  static const macAddressPlatform = MethodChannel('mac_address');
  static const bluetoothPlatform =
      MethodChannel('bluetooth_protocols'); // Add Bluetooth protocols channel

  Future<void> getBatteryPercentage() async {
    try {
      final String result =
          await batteryPlatform.invokeMethod('getBatteryPercentage');
      setState(() {
        _batteryPercentage = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _batteryPercentage = 'Error: ${e.message}';
      });
    }
  }

  Future<void> getWifiState() async {
    try {
      final String result = await wifiPlatform.invokeMethod('getWifiState');
      setState(() {
        _wifiState = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _wifiState = 'Error: ${e.message}';
      });
    }
  }

  Future<void> getMacAddress() async {
    try {
      final String result =
          await macAddressPlatform.invokeMethod('getMacAddress');
      setState(() {
        _macAddress = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _macAddress = 'Error: ${e.message}';
      });
    }
  }

  // Add a method to fetch Bluetooth protocols
  Future<void> fetchBluetoothProtocols() async {
    try {
      final List<dynamic> result =
          await bluetoothPlatform.invokeMethod('getBluetoothProtocols');
      final List<String> protocols = result.cast<String>();
      setState(() {
        _bluetoothProtocols = protocols;
      });
    } on PlatformException catch (e) {
      setState(() {
        _bluetoothProtocols = ['Error: ${e.message}'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoMaxGo Task'), // Updated app title
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Battery Percentage:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              _batteryPercentage,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getBatteryPercentage,
              child: const Text('Get Battery Percentage'),
            ),
            const SizedBox(height: 20), // Add spacing
            const Text(
              'Wi-Fi State:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              _wifiState,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getWifiState,
              child: const Text('Fetch Wi-Fi State'),
            ),
            const SizedBox(height: 20), // Add spacing
            const Text(
              'MAC Address:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              _macAddress,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getMacAddress,
              child: const Text('Fetch and Show MAC Address'),
            ),
            const SizedBox(height: 20), // Add spacing
            const Text(
              'Bluetooth Protocols:', // Display Bluetooth protocols
              style: TextStyle(fontSize: 18),
            ),
            Column(
              children: _bluetoothProtocols
                  .map((protocol) => Text(protocol))
                  .toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  fetchBluetoothProtocols, // Invoke method to fetch Bluetooth protocols
              child: const Text('Fetch and List Bluetooth Protocols'),
            ),
          ],
        ),
      ),
    );
  }
}
