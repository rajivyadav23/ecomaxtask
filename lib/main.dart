import 'package:flutter/material.dart';
import 'package:battery/battery.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BatteryPercentageScreen(),
    );
  }
}

class BatteryPercentageScreen extends StatefulWidget {
  @override
  _BatteryPercentageScreenState createState() =>
      _BatteryPercentageScreenState();
}

class _BatteryPercentageScreenState extends State<BatteryPercentageScreen> {
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
        title: Text('EcoMaxGo Task'), // Updated app title
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Battery Percentage:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              _batteryPercentage,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getBatteryPercentage,
              child: Text('Get Battery Percentage'),
            ),
            SizedBox(height: 20), // Add spacing
            Text(
              'Wi-Fi State:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              _wifiState,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getWifiState,
              child: Text('Fetch Wi-Fi State'),
            ),
            SizedBox(height: 20), // Add spacing
            Text(
              'MAC Address:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              _macAddress,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getMacAddress,
              child: Text('Fetch and Show MAC Address'),
            ),
            SizedBox(height: 20), // Add spacing
            Text(
              'Bluetooth Protocols:', // Display Bluetooth protocols
              style: TextStyle(fontSize: 18),
            ),
            Column(
              children: _bluetoothProtocols
                  .map((protocol) => Text(protocol))
                  .toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  fetchBluetoothProtocols, // Invoke method to fetch Bluetooth protocols
              child: Text('Fetch and List Bluetooth Protocols'),
            ),
          ],
        ),
      ),
    );
  }
}
