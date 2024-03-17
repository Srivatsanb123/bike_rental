import 'package:bike_rental/Payment.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:field_validation/Source_Code/FlutterValidation.dart';
import 'package:flutter/material.dart';
import 'package:field_validation/Source_Code/FlutterValidation.dart';
import 'package:bike_rental/Payment.dart'; // Import the PaymentPage

class AadharNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String formattedValue = _formatAadharNumber(newValue.text);
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  String _formatAadharNumber(String value) {
    value = value.replaceAll('-', ''); // Remove existing dashes
    if (value.length <= 4) {
      return value;
    } else if (value.length <= 8) {
      return '${value.substring(0, 4)}-${value.substring(4)}';
    } else {
      return '${value.substring(0, 4)}-${value.substring(4, 8)}-${value.substring(8, 12)}';
    }
  }
}

class VerifyPage extends StatelessWidget {
  // Creating Object of the FieldValidator class.
  FlutterValidation validator = FlutterValidation();
  TextEditingController aadharController = TextEditingController();
  AadharNumberFormatter formatter = AadharNumberFormatter(); // Custom formatter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Aadhar'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: aadharController,
              decoration: const InputDecoration(
                labelText: 'Enter Aadhar Number',
                hintText: 'xxxx-xxxx-xxxx',
                prefixIcon: Icon(Icons.credit_card),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [formatter], // Use the custom formatter
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String aadharNumber = aadharController.text
                    .replaceAll('-', ''); // Remove dashes for validation
                bool result = validator.aadhaarValidate(content: aadharNumber);
                if (result && aadharNumber.length == 12) {
                  // Check for valid length as well
                  // Navigate to the PaymentPage if Aadhar is valid
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentPage()),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid Aadhar Number!')),
                  );
                }
              },
              child: const Text('Verify Aadhar'),
            ),
          ],
        ),
      ),
    );
  }
}
