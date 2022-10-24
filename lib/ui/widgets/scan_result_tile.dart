import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({Key? key, required this.result, this.onTap})
      : super(key: key);
  final ScanResult result;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {

    ///scanned data
    return ListTile(
      title: (result.device.name.isNotEmpty)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ///device name
                Text(result.device.name, overflow: TextOverflow.ellipsis),
                Text(result.device.id.toString(),
                    style: Theme.of(context).textTheme.caption)
              ],
            )
          : Text(result.device.id.toString()),
      trailing: OutlinedButton(
        onPressed: (result.advertisementData.connectable) ? onTap : null,
        child: Text('CONNECT', style: TextStyle(color: result.advertisementData.connectable?Colors.blue:Colors.grey),),
      ),
    );
  }
}
