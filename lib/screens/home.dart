import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:universityvalidator/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../styles/app_colors.dart';
import '../styles/text_styles.dart';

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: QRViewExample());
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  
bool isPaused=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          

          Column(
            children: <Widget>[
              Expanded(flex: 4, child: _buildQrView(context)),
              


             ],
          ),
         Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 56),
              child: ElevatedButton(
                style:ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: Size(70, 70)
                

                ),
                onPressed: () {
                  setState(() {
                    isPaused=!isPaused;
                  });
                  if (isPaused) {
                    controller!.pauseCamera();
                  } else {
                    controller!.resumeCamera();
                  }
                },
                child: Icon(!isPaused?Icons.pause:Icons.play_arrow_sharp,color:Colors.black),
              ),
            ),
          )
         ,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async{
                    await controller?.toggleFlash();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 45, left: 23),
                  child: Icon(
                        Icons.flash_on,
                        color: AppColors.whiteshade,
                        size: 29,
                      ),
                     
                    
                  
                  
                ),
              ),
              InkWell(
                onTap: ()async {
                 await controller?.flipCamera();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 45, right: 23),
                  child: Icon(
                        Icons.refresh,
                        color: AppColors.whiteshade,
                        size: 29,
                      ),
                     
                    
                  
                  
                ),
              ),
            ],
          ),
        ],
            
            )
        
        
        
      
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) async {
      var data = scanData.code;
      String first =
          data.toString().replaceAll("72Gs1nbSV95E7CIN1e3rNFBFBG41bj", "");
      String id = first.replaceAll("2wzUBS44f53vEUzsjhNjlLJPb1lJ2r", "");
      print(id);

      
  controller.pauseCamera();
 
 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Confirmé avec succès")),);

setState(() {
  isPaused=true;
});
      final token = await GetStorage().read('token');
      var response =
          await http.post(Uri.parse(link + "updateConfirm"), headers: {
        "accept": "application/json",
        "Authorization": "Bearer $token"
      }, body: {
        "id": id,
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
