import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:nuuz_bluetooth_tester/controller/main_controller.dart';

import 'connected_screen.dart';
import 'widgets/main_appbar.dart';
import 'widgets/scan_result_tile.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var statusHeight = MediaQuery.of(context).viewPadding.top;

    return GetBuilder<MainController>(builder: (controller) {
      return Scaffold(
        appBar: const MainAppbar(
          back: false,
          setting: true,
          title: 'Nuuz Bluetooth Tester',
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: StreamBuilder<List<ScanResult>>(
                //스캔한 장비들이 나타난다.
                stream: FlutterBluePlus.instance.scanResults,
                initialData: const [],
                builder: (c, snapshot) => SizedBox(
                  height: Get.height - statusHeight - 50 - 58,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: snapshot.data!
                        .map(
                          (r) => ScanResultTile(
                              result: r,
                              onTap: () async {
                                //디바이스를 연결하고
                                await controller.connect(r.device);
                                Get.to(
                                    () => ConnectedScreen(
                                        connectedDevice: r.device),
                                    transition: Transition.noTransition);
                                controller.isLoading.value = false;
                              }),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            InkWell(
                onTap: () => controller.startScan(),
                child: Container(
                  color: Colors.lightBlue,
                  width: Get.width,
                  height: 50,
                  child: const Center(
                      child: Text('검색하기',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700))),
                ))
          ],
        ),
      );
    });
  }
}
