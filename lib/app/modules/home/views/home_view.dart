import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HomeView'),
          centerTitle: true,
        ),
        body: Column(children: [
          Obx(() => Text('Status: \t' + controller.bluetoothState.toString())),
          Obx(() => Text('Local Address:\t' + controller.address.value)),
          Obx(() => Text('Local Adapter:\t' + controller.name.value)),
          IconButton(
              onPressed: controller.startDiscovery, icon: Icon(Icons.search)),
          Obx(() {
            if (controller.discovering.value) {
              return CircularProgressIndicator();
            } else {
              return Text('asdf');
            }
          })
        ]));
  }
}
