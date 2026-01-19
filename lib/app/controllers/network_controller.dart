import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final _connectionStatus = ConnectivityResult.none.obs;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  ConnectivityResult get connectionStatus => _connectionStatus.value;
  bool get isConnected => _connectionStatus.value != ConnectivityResult.none;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _connectionStatus.value = result;
    } catch (e) {
      _connectionStatus.value = ConnectivityResult.none;
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    _connectionStatus.value = result;
    
    if (_connectionStatus.value == ConnectivityResult.none) {
      _showNoInternetDialog();
    }
  }

  void _showNoInternetDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text('Please check your internet connection and try again.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _initConnectivity();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}