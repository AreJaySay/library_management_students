// import 'dart:convert';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class BluetoothChecker extends StatefulWidget {
//   @override
//   _BluetoothCheckerState createState() => _BluetoothCheckerState();
// }
//
// class _BluetoothCheckerState extends State<BluetoothChecker> {
//   BluetoothConnection? _connection;
//   String _receivedData = "";
//   bool _isConnecting = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _connectToHC05();
//   }
//
//   Future<void> _connectToHC05() async {
//     setState(() => _isConnecting = true);
//     await [
//       Permission.bluetoothConnect,
//       Permission.bluetoothScan,
//       Permission.location,
//     ].request();
//     String hc05Address = "00:23:00:00:51:6C";
//     await FlutterBluetoothSerial.instance.cancelDiscovery();
//     try {
//       _connection = await BluetoothConnection.toAddress(hc05Address);
//       print('Connected to HC-05');
//       String buffer = "";
//       _connection!.input!.listen((data) {
//         print("Received: $data"); // optional debug
//         buffer += ascii.decode(data);
//         int index;
//         while ((index = buffer.indexOf('\n')) != -1) {
//           String message = buffer.substring(0, index).trim(); // extract one message
//           buffer = buffer.substring(index + 1); // remove processed message
//           setState(() {
//             _receivedData = message; // update UI
//           });
//         }
//       }).onDone(() {
//         print('Disconnected by remote');
//       });
//     } catch (e) {
//       print('Cannot connect: $e');
//     }
//
//     setState(() => _isConnecting = false);
//   }
//
//   @override
//   void dispose() {
//     _connection?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('HC-05 Test Receiver')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Text(_isConnecting ? 'Connecting...' : 'Connected'),
//             SizedBox(height: 10),
//             Expanded(
//               child: Container(
//                 color: Colors.black12,
//                 padding: EdgeInsets.all(8),
//                 child: SingleChildScrollView(
//                   child: Text(
//                     "${_receivedData.length} || asdsdsdsdsd",
//                     style: TextStyle(fontSize: 16, color: Colors.red),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void sendData(String data) async {
//     if (_connection != null && _connection!.isConnected) {
//       _connection!.output.add(Uint8List.fromList(data.codeUnits));
//       await _connection!.output.allSent;
//       print('Data sent: $data');
//     }
//   }
// }
