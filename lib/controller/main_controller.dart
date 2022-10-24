import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  @override
  void onInit() {
    ///앱 시작시 호출되는 기능 uuid 를 초기화하고, 블루투스 신호를 스캔한다.
    initialProcess();
    deviceUuid.value = '';
    startScan();
    super.onInit();
  }

  //인디케이터 컨트롤 변수
  var isLoading = false.obs;
  //수신할 데이터가 비어있는지를 확인하는 변수
  var isValueNull = false.obs;
  //현재 연결되어있는 장비 목록을 담을 리스트
  late List<BluetoothDevice> connectedDevice;
  //device uuid 검색에 사용할 디바이스 uuid
  var deviceUuid = '00001816-0000-1000-8000-00805f9b34fb'.obs;
  ///text Controller
  TextEditingController device = TextEditingController();
  RxList uuidList = [].obs;
  var isStreamingButton = false.obs;
  var isStreamingData = ''.obs;


  ///블루투스 스캔
  Future<void> startScan() async {
    isLoading.value = true;
    await FlutterBluePlus.instance.stopScan();
    debugPrint("startScan=====================>");
    deviceUuid.value == ''
        ? await FlutterBluePlus.instance.startScan(
            timeout: const Duration(seconds: 3),
          )
        : await FlutterBluePlus.instance.startScan(
            timeout: const Duration(seconds: 3),
            withServices: [Guid(deviceUuid.value)],
          );
    debugPrint('<=====================scan finish');
    isLoading.value = false;
  }
  ///블루투스 연결
  connect(BluetoothDevice device) async {
    isLoading.value = true;
    await device.connect();
  }
  ///블루투스 연결끊기
  disconnect(BluetoothDevice device) async {
    isLoading = true.obs;
    Timer(const Duration(seconds: 1), () => isLoading = false.obs);
    await device.disconnect();
  }
  ///앱 시작하면서 연결된 장비 전부 끊기
  initialProcess() async {
    debugPrint('app ignited');
    debugPrint('연결된 디바이스 scan.............');
    connectedDevice = await FlutterBluePlus.instance.connectedDevices;
    debugPrint('............scan finish');
    debugPrint(connectedDevice.toString());
    debugPrint('연결된 디바이스 disconnecting.............');
    if (connectedDevice.isNotEmpty) {
      for (var element in connectedDevice) {
        element.disconnect();
      }
    }
    debugPrint('.............disconnecting finish');
  }
  ///uuid 수정하기
  void editingUuid() {
    deviceUuid.value = device.text;
    Get.snackbar(
      'UUID가 변경되었습니다.',
      'UUID: ${device.text}',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
