import 'package:flutter/material.dart';

class EditTextField extends StatelessWidget {
  const EditTextField({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff9a9a9a)),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: TextField(
                      controller: controller,
                      decoration:
                      const InputDecoration(border: InputBorder.none),
                    ),
                  ))),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
