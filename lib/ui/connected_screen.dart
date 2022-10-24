import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:nuuz_bluetooth_tester/controller/main_controller.dart';
import 'package:nuuz_bluetooth_tester/ui/widgets/main_appbar.dart';

class ConnectedScreen extends StatefulWidget {
  const ConnectedScreen({
    Key? key,
    required this.connectedDevice,
  }) : super(key: key);

  final BluetoothDevice connectedDevice;

  @override
  State<ConnectedScreen> createState() => _ConnectedScreenState();
}

class _ConnectedScreenState extends State<ConnectedScreen> {
  @override
  void initState() {
    widget.connectedDevice.discoverServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(builder: (controller) {
      return Scaffold(
        appBar: MainAppbar(
          back: true,
          setting: false,
          title: widget.connectedDevice.name.isEmpty
              ? widget.connectedDevice.id.toString()
              : widget.connectedDevice.name.toString(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('연결된 기기 이름 : ${widget.connectedDevice.name}'),
                          Text('연결된 기기 ID : ${widget.connectedDevice.id}'),
                        ],
                      ),
                      StreamBuilder(
                          stream: widget.connectedDevice.state,
                          builder: (s, snapshot) {
                            return snapshot.data ==
                                    BluetoothDeviceState.connected
                                ? const Icon(Icons.thumb_up_alt)
                                : const Icon(Icons.thumb_down);

                            // Text(snapshot.data.toString());
                          }),
                    ],
                  ),
                  const SizedBox(height: 15),
                  StreamBuilder(
                      stream: widget.connectedDevice.services,
                      builder: (a, snapshot) {
                        controller.uuidList.value = snapshot.data!
                            .map((e) => e.uuid.toString())
                            .toList();
                        debugPrint(controller.uuidList.toString());

                        return SizedBox(
                            height: 400,
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 5,
                                  childAspectRatio: 2 / 1,
                                ),
                                itemCount: snapshot.data?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return OutlinedButton(
                                      onPressed: () {
                                        // d.read();

                                        Get.bottomSheet(BottomSheet(
                                          data: snapshot.data![index],
                                          device: widget.connectedDevice,
                                        ));
                                      },
                                      child: Text(
                                          '0x${snapshot.data![index].uuid.toString().toUpperCase().substring(4, 8)}'));
                                }));
                      }),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({Key? key, required this.data, required this.device})
      : super(key: key);

  final BluetoothService data;
  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return GetBuilder<MainController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            color: Colors.white,
          ),
          height: Get.height / 3,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                height: 200,
                child: data.characteristics.isEmpty
                    ? const Center(
                        child: Text('확인할 수 있는 데이터가 없습니다.'),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 5,
                          childAspectRatio: 2 / 1,
                        ),
                        itemCount: data.characteristics.length,
                        itemBuilder: (BuildContext context, int index) {
                          return OutlinedButton(
                              onPressed: () async {
                                if (data
                                    .characteristics[index].properties.notify) {
                                  controller.isStreamingData.value = '';
                                  await data.characteristics[index]
                                      .setNotifyValue(true);
                                  data.characteristics[index].value
                                      .listen((value) {
                                    debugPrint(value.toString());
                                    if (value.toString() == [].toString()) {
                                      controller.isValueNull.value = false;
                                    } else {
                                      controller.isValueNull.value = true;
                                      controller.isStreamingData.value +=
                                          '${value.toString()}  ${DateTime.now()} \n';
                                    }

                                    Future.delayed(const Duration(seconds: 1));
                                  });

                                  Get.dialog(
                                      barrierDismissible: false,
                                      AlertDialog(
                                        title: Text(
                                            '0x${data.characteristics[index].uuid.toString().toUpperCase().substring(4, 8)} - Variable'),
                                        actions: [
                                          Obx(() => SizedBox(
                                                height: 100,
                                                child: controller
                                                        .isValueNull.value
                                                    ? SingleChildScrollView(
                                                        reverse: true,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                                child: Text(
                                                              controller
                                                                  .isStreamingData
                                                                  .value,
                                                            )),
                                                          ],
                                                        ),
                                                      )
                                                    : const Center(
                                                        child: Text(
                                                            '이 데이터는 현재 수신할 수 없습니다.')),
                                              )),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              OutlinedButton(
                                                  onPressed: () async {
                                                    await data
                                                        .characteristics[index]
                                                        .setNotifyValue(false);
                                                    Get.back();
                                                  },
                                                  child: const Text('닫기')),
                                            ],
                                          )
                                        ],
                                      ));
                                } else if (data
                                    .characteristics[index].properties.read) {
                                  data.characteristics[index].read();
                                  await Future.delayed(
                                      const Duration(milliseconds: 500));
                                  Get.dialog(
                                    barrierDismissible: false,
                                    WillPopScope(
                                      onWillPop: () async => false,
                                      child: AlertDialog(
                                        title: Text(
                                            '0x${data.characteristics[index].uuid.toString().toUpperCase().substring(4, 8)} - Fixed'),
                                        titlePadding: const EdgeInsets.fromLTRB(
                                            10, 10, 0, 0),
                                        actions: [
                                          //   TextButton(onPressed: (){}, child: const Text('닫기')),

                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 100,
                                                child: StreamBuilder(
                                                    stream: data
                                                        .characteristics[index]
                                                        .value,
                                                    // data.characteristics[index].value,
                                                    builder:
                                                        (context, snapshot) {
                                                      return Center(
                                                          child: Text(snapshot
                                                              .data
                                                              .toString()));
                                                      //  Center(child: Text(snapshot.data.toString()),
                                                      // );
                                                    }),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  OutlinedButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: const Text('닫기')),
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 20)
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  Get.snackbar(
                                    '현재 수신할 수 없는 데이터입니다..',
                                    '다른 데이터를 선택해주세요.',
                                    snackPosition: SnackPosition.TOP,
                                    duration: const Duration(seconds: 2),
                                  );
                                }
                              },
                              child: Text(
                                  '0x${data.characteristics[index].uuid.toString().toUpperCase().substring(4, 8)}'));
                        }),
              )
            ],
          ),
        ),
      );
    });
  }
}
