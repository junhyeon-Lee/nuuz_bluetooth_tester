import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nuuz_bluetooth_tester/controller/main_controller.dart';
import 'package:nuuz_bluetooth_tester/ui/widgets/main_appbar.dart';
import 'widgets/setting_input_field.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(builder: (controller) {
      return Scaffold(
        appBar: const MainAppbar(
          back: true,
          setting: false,
          title: 'Setting',
        ),
        body: (Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(children: const [Text('현재 설정되어 있는 UUID')]),
                  EditTextField(controller: controller.device)
                ],
              ),
            ),
            InkWell(
              onTap: () => controller.editingUuid(),
              child: Container(
                  color: Colors.lightBlue,
                  width: Get.width,
                  height: 50,
                  child: const Center(
                      child: Text(
                    '변경하기',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700),
                  ))),
            )
          ],
        )),
      );
    });
  }
}
