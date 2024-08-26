import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';

class SignUpForm extends StatefulWidget {

  SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController phoneNumberController = TextEditingController();
  late String generatedOtp ;
  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
  }

  Future<void> requestNotificationPermissions() async {
    bool result = await AwesomeNotifications().isNotificationAllowed();
    if (!result) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> _showNotification(String otp) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'basic_channel',
        title: 'OTP Verification',
        body: 'Your OTP is: $otp',
      ),
    );
  }

  String _generateOTP() {
    Random random = Random();
    generatedOtp = ''; // Initialize the class-level variable here
    for (int i = 0; i < 4; i++) {
      generatedOtp += random.nextInt(10).toString();
    }
    return generatedOtp;
  }


  bool isValidPhoneNumber(String phoneNumber) {
    return phoneNumber.isNotEmpty;
  }

  Future<void> _signup(BuildContext context) async {
    final String phone_Number = phoneNumberController.text;

    if (!isValidPhoneNumber(phone_Number)) {
      print('Invalid phone number. Please enter a valid phone number.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.11.5.203:8000/getotp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode({
          'phoneNumber': phone_Number,
        }),
      );

      if (response.statusCode == 200) {
        print('Signup successful: ${response.body}');
         _generateOTP();
        _showNotification(generatedOtp);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Otp(phoneNumber: phone_Number, otp:generatedOtp),
          ),
        );
      } else {
        print('Signup failed: ${response.body}');
      }
    } catch (e) {
      print('Error during signup: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: phoneNumberController,
            decoration: const InputDecoration(
              hintText: "Your phone number",
              prefixIcon: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.phone),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _signup(context),
            child: Text("Send OTP".toUpperCase()),
          ),
        ],
      ),
    );
  }
}

class Otp extends StatelessWidget {
  final String phoneNumber;
  final String otp;

  const Otp({Key? key, required this.phoneNumber, required this.otp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OTP Verification')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Enter OTP sent to $phoneNumber: $otp'),
          // Add your OTP verification UI here
        ],
      ),
    );
  }
}

void main() {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: "basic_channel",
        channelName: "Basic Notifications",
        channelDescription: "Notification channel for basic tests",
        importance: NotificationImportance.High,
      ),
    ],
    debug: true,
  );

  runApp(MaterialApp(
    home: SignUpForm(),
  ));
}
