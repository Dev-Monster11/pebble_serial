import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  var address = ''.obs;
  var name = ''.obs;
  var discovering = false.obs;
  Rx<BluetoothState> bluetoothState =
      Rx<BluetoothState>(BluetoothState.UNKNOWN);

  Timer? _discoverableTimer;

  @override
  void onInit() async {
    super.onInit();
    await FlutterBluetoothSerial.instance.requestEnable();
    FlutterBluetoothSerial.instance.state.then((value) {
      bluetoothState.value = value;
    });
    Future.doWhile(() async {
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      FlutterBluetoothSerial.instance.address.then((value) {
        address.value = value!;
      });
    });
    FlutterBluetoothSerial.instance.name.then((value) {
      name.value = value!;
    });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      bluetoothState.value = state;

      _discoverableTimer = null;
    });
    var _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      if (r.device.name!.startsWith('SR01')) {
        Get.snackbar("Hi", "Pebble1 Found");
        BluetoothConnection.toAddress(r.device.address).then((value) {
          value.output.add(ascii.encode("COM 090002550003000"));
          value.output.add(ascii.encode("DEL 05000"));
          value.output.add(ascii.encode("WRD pebble1_"));
          value.input!.listen((event) {
            Get.snackbar("Income", event.toString());
          });
        });
      } else if (r.device.name!.startsWith('SR02')) {
        Get.snackbar("Hi", "Pebble2 Found");
        BluetoothDevice device = r.device;
        BluetoothConnection.toAddress(r.device.address).then((value) {
          value.output.add(ascii.encode("COM 090002550003000"));
          value.output.add(ascii.encode("DEL 05000"));
          value.output.add(ascii.encode("WRD pebble2_"));
          value.input!.listen((event) {
            Get.snackbar("Income", event.toString());
          });
        });
      }
    });
    _streamSubscription.onDone(() {
      discovering.value = false;
    });
  }

  void startDiscovery() async {
    await FlutterBluetoothSerial.instance.requestDiscoverable(10);
    discovering.value = true;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
