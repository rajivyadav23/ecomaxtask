package com.example.ecomaxtask

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkInfo
import android.net.wifi.WifiInfo
import android.net.wifi.WifiManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.BatteryManager
import android.bluetooth.BluetoothAdapter

class MainActivity: FlutterActivity() {
    private val BATTERY_CHANNEL = "battery_percentage"
    private val WIFI_CHANNEL = "wifi_state"
    private val MAC_ADDRESS_CHANNEL = "mac_address"
    private val BLUETOOTH_CHANNEL = "bluetooth_protocols" // Add Bluetooth protocols channel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Battery percentage method channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getBatteryPercentage") {
                val batteryPercentage = getBatteryPercentage()
                if (batteryPercentage != null) {
                    result.success(batteryPercentage)
                } else {
                    result.error("UNAVAILABLE", "Battery percentage not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }

        // Wi-Fi state method channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIFI_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getWifiState") {
                val wifiState = getWifiState()
                result.success(wifiState)
            } else {
                result.notImplemented()
            }
        }

        // MAC address method channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MAC_ADDRESS_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getMacAddress") {
                val macAddress = getMacAddress()
                result.success(macAddress)
            } else {
                result.notImplemented()
            }
        }

        // Bluetooth protocols method channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BLUETOOTH_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getBluetoothProtocols")
