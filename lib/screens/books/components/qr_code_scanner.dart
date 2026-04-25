import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:students/screens/books/components/reservation_form.dart';
import 'package:students/services/routes.dart';

class QrCodeScanner extends StatefulWidget {
  final List books;
  QrCodeScanner({required this.books});
  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final Routes _routes = new Routes();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? result;
  bool isScanned = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final code = scanData.code;
      if (code != null) {
        isScanned = true;
        controller.pauseCamera();
        List _res = widget.books.where((s) => s["isbn"] == code).toList();
        _routes.navigator_push(context, ReservationForm(details: _res.first, isReserved: false,));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("QR Scanner"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          /// QR Scanner
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),

          /// Dark overlay with transparent center
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          /// Scanner Box + Corners
          Center(
            child: Stack(
              children: [
                /// Transparent scan area
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                /// Corners
                Positioned(top: 0, left: 0, child: _corner()),
                Positioned(top: 0, right: 0, child: _corner(isRight: true)),
                Positioned(bottom: 0, left: 0, child: _corner(isBottom: true)),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: _corner(isRight: true, isBottom: true),
                ),
              ],
            ),
          ),

          /// Result Text
          Positioned(
            bottom: 40,
            child: Text(
              result ?? "Scan a QR Code",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Corner Widget
  Widget _corner({bool isRight = false, bool isBottom = false}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: isBottom
              ? BorderSide.none
              : BorderSide(color: Colors.white, width: 4),
          left: isRight
              ? BorderSide.none
              : BorderSide(color: Colors.white, width: 4),
          right: isRight
              ? BorderSide(color: Colors.white, width: 4)
              : BorderSide.none,
          bottom: isBottom
              ? BorderSide(color: Colors.white, width: 4)
              : BorderSide.none,
        ),
      ),
    );
  }
}
