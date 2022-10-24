import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuuz_bluetooth_tester/controller/main_controller.dart';
import 'ui/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
        init: MainController(),
        builder: (controller) {
          return GetMaterialApp(
            title: 'Nuuz_Bluetooth_tester',
            home: Stack(
              children: [
                const MainScreen(),
                ///컨트롤러의 변수를 통해 인디케이터를 원하는 상황에서 보여준다.
                Obx(
                  () => controller.isLoading.value
                      ? Scaffold(
                          backgroundColor: Colors.black.withOpacity(0.6),
                          body: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
          );
        });
  }
}
