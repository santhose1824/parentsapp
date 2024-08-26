import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_share_me/flutter_share_me.dart';



class place extends StatelessWidget {
  const place({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Colors.deepPurple),
        // useMaterial3: true, // Material 3 is not yet stable
      ),
      debugShowCheckedModeBanner: false,
      home: const PlacementInformation(),
    );
  }
}

class PlacementInformation extends StatefulWidget {
  const PlacementInformation({Key? key}) : super(key: key);

  @override
  _PlacementInformationState createState() => _PlacementInformationState();
}

class _PlacementInformationState extends State<PlacementInformation> {
  TextEditingController companyNameController = TextEditingController();
  TextEditingController driveDateController = TextEditingController();
  TextEditingController eligibilityCriteriaController = TextEditingController();
  TextEditingController ctcPackageController = TextEditingController();
  TextEditingController venueController = TextEditingController();
  TextEditingController streameligibilityController =
  TextEditingController(); // New field

  @override
  void dispose() {
    companyNameController.dispose();
    driveDateController.dispose();
    eligibilityCriteriaController.dispose();
    ctcPackageController.dispose();
    venueController.dispose();
    streameligibilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Placement Information"),
        backgroundColor: const Color.fromARGB(255, 141, 183, 252),
      ),
      // backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const Padding(
            //   padding: EdgeInsets.all(8.0),
            // ),
            Padding(
              padding: const EdgeInsets.all(0),
              // padding: null,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildTextField("Company Name", companyNameController),
                      _buildTextField("Drive Date", driveDateController,
                          isDateField: true),
                      _buildTextField("Eligibility Criteria",
                          eligibilityCriteriaController),
                      _buildTextField("CTC/package", ctcPackageController),
                      _buildTextField("Venue", venueController),
                      _buildTextField("Stream", streameligibilityController),
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                _sendPlacementDetailsViaEmail();
                              },
                              icon: Icon(Icons.email), // Email icon
                              label: const Text(
                                "Send Through Email",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                              ),
                            ),
                            SizedBox(height: 10), // Add spacing between buttons
                            ElevatedButton.icon(
                              onPressed: () {
                                _sendThroughWhatsApp();
                              },
                              icon: Icon(Icons.whatshot), // Email icon
                              label: Text(
                                "Send Through Whatsapp",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreenAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller,
      {bool isDateField = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(labelText),
          isDateField
              ? GestureDetector(
            onTap: () {
              _selectDate(context, controller);
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller,
                cursorColor: Colors.redAccent,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent)
                  ),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ),
          )
              : TextFormField(
            controller: controller,
            cursorColor: Colors.redAccent,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime pickedDate = DateTime.now(); // Initialize with current date
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data:
          ThemeData.light(), // Customize the date picker's theme if needed
          child: child!,
        );
      },
    );

    if (selectedDate != null && selectedDate != pickedDate) {
      pickedDate = selectedDate;
      controller.text = pickedDate.toString().split(
          ' ')[0]; // Set the selected date to the text field (without time)
    }
  }

  Future<void> _sendPlacementDetailsViaEmail() async {


    String companyName = companyNameController.text;
    String driveDate = driveDateController.text;
    String eligibilityCriteria = eligibilityCriteriaController.text;
    String ctcPackage = ctcPackageController.text;
    String venue = venueController.text;
    String stream = streameligibilityController.text;
    await _storeDataInDatabase(companyName, driveDate,
        eligibilityCriteria, ctcPackage, venue, stream);
    showSuccessMessage(context);
    String? recipientEmail = await _getEmailFromUser();
    String emailBody = '''
    Company Name: $companyName
    Drive Date: $driveDate
    Eligibility Criteria: $eligibilityCriteria
    CTC/Package: $ctcPackage
    Venue: $venue
    Stream: $stream
    ''';
    if (recipientEmail!.isNotEmpty) {
      try {
        final jsonString = '''
      {
          "bearer": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJpdHBsYWNlbWVudEBuZWMuZWR1LmluIiwiZXhwIjoxNzA0OTc0NTY2fQ.p3qckOBX7Lyj1CA_2LZpywQH3q0-9wWvQ039ZLgmSEs"
      }
      ''';
        final jsonResponse = jsonDecode(jsonString);
        final token = jsonResponse['bearer'];
        final response = await http.post(
          Uri.parse('http://10.11.5.203:8000/placementemail'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'to': recipientEmail,
            'subject': 'Placement Details',
            'companyName': companyName,
            'driveDate': driveDate,
            'eligibilityCriteria': eligibilityCriteria,
            'ctcPackage': ctcPackage,
            'venue': venue,
            'stream': stream,
          }),
        );

        if (response.statusCode == 200) {
          // Email sent successfully from the backend
          // await _storeDataInDatabase(companyName, driveDate,
          //     eligibilityCriteria, ctcPackage, venue, stream);
          // showSuccessMessage(context);
          // Show a success message or perform necessary actions
        } else {
          // Failed to send email from the backend
          // Show an error message or handle accordingly
        }
      } catch (error) {
        // Handle network or other errors
        print('Error: $error');
      }
    }
  }

  Future<String?> _getEmailFromUser() async {
    TextEditingController emailController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Recipient Email'),
          content: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Recipient Email',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, emailController.text);
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _sendThroughWhatsApp() async {
    String message = _composeWhatsAppMessage();
    String companyName = companyNameController.text;
    String driveDate = driveDateController.text;
    String eligibilityCriteria = eligibilityCriteriaController.text;
    String ctcPackage = ctcPackageController.text;
    String venue = venueController.text;
    String stream = streameligibilityController.text;
    await _storeDataInDatabase(
        companyName, driveDate, eligibilityCriteria, ctcPackage, venue, stream);
    await FlutterShareMe().shareToWhatsApp(msg: message);
  }

  String _composeWhatsAppMessage() {
    String companyName = companyNameController.text;
    String driveDate = driveDateController.text;
    String eligibilityCriteria = eligibilityCriteriaController.text;
    String ctcPackage = ctcPackageController.text;
    String venue = venueController.text;
    String stream = streameligibilityController.text;
    return '''
    Company Name: $companyName
    Drive Date: $driveDate
    Eligibility Criteria: $eligibilityCriteria
    CTC/Package: $ctcPackage
    Venue: $venue
    Stream: $stream
    ''';
  }

  void showSuccessMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Email sent successfully!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _storeDataInDatabase(
      String companyName,
      String driveDate,
      String eligibilityCriteria,
      String ctcPackage,
      String venue,
      String stream) async {
    try {
      final jsonString = '''
 {
  "bearer": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMDE1MDUzQG5lYy5lZHUuaW4iLCJleHAiOjE3MDQ4ODQ3Mjd9.Hy5vcqFQtkAdd86iFHh0zXITf4o6ti1R7ImUXoWLa5g"
}
  ''';
      final jsonResponse = jsonDecode(jsonString);
      final token = jsonResponse['bearer'];
      final response = await http.post(
        Uri.parse('http://10.11.6.4:8000/placementinfo'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMDE1MDUzQG5lYy5lZHUuaW4iLCJleHAiOjE3MDQ4ODU4MTl9.B7wakGGqvnrgZWsp3_sZJnfhDgkvzc98JGtyP7Ydwhk",
        },
        body: jsonEncode({
          'companyName': companyName,
          'driveDate': driveDate,
          'eligibilityCriteria': eligibilityCriteria,
          'ctcPackage': ctcPackage,
          'venue': venue,
          'stream': stream,
        }),
      );

      if (response.statusCode == 200) {
        print('Data stored successfully');
        // Handle success as needed
      } else {
        print('Failed to store data');
        // Handle failure as needed
      }
    } catch (error) {
      print('Error storing data: $error');
      // Handle error as needed
    }
  }
}