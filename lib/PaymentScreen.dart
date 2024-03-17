// ignore_for_file: must_be_immutable, library_private_types_in_public_api, file_names

import 'package:bike_rental/Payment.dart';
import 'package:bike_rental/RentScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class PaymentScreen extends StatefulWidget {
  BicycleData cycleData = BicycleData(name: "", location: "", type: "");
  String cycleName = "";

  PaymentScreen(BicycleData cycleDta, {Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: 'Payment successful');
    // Add your logic after successful payment
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: 'Payment failed: ${response.message}');
    // Add your logic for handling payment failure
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: 'External wallet selected: ${response.walletName}');
    // Add your logic for handling external wallet selection
  }

  void _startPayment() {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY', // Replace with your actual Razorpay key
      'amount':
          10000, // Replace with the amount in paisa (e.g., Rs. 100 = 10000)
      'name': 'Acme Corp.',
      'description': 'Payment for ${widget.cycleName}',
      'prefill': {'contact': '8888888888', 'email': 'test@example.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Payment for ${widget.cycleName}'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentPage(),
                  ),
                );
              },
              child: const Text('Pay Now'),
            ),
            const SizedBox(height: 20),
            const Text('Scan QR Code to Make Payment:'),
            const SizedBox(height: 10),
            Expanded(
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      // Handle scanned QR code data here
      // This could be the payment information received from the QR code
    });
  }
}
