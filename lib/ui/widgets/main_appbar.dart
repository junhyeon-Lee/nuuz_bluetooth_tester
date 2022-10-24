import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:nuuz_bluetooth_tester/controller/main_controller.dart';
import 'package:nuuz_bluetooth_tester/ui/setting_screen.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbar({
    Key? key,
    required this.back,
    required this.setting,
    this.callback,
    required this.title,
  }) : super(key: key);

  final String title;
  final bool back;
  final bool setting;
  final Future<dynamic>? callback;

  @override
  Widget build(BuildContext context) {
    late List<BluetoothDevice> connectedDevice;
    return GetBuilder<MainController>(builder: (controller) {
      return AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        leading: back
            ? IconButton(
                onPressed: () async {
                  controller.initialProcess();

                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              )
            : Container(),
        actions: [
          setting
              ? IconButton(
                  onPressed: () {
                    Get.to(const SettingScreen(),
                        transition: Transition.noTransition);
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                )
              : Container(),
        ],
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(58);
}
