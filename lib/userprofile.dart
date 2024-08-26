import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(StudentProfileScreen());
}

class StudentProfileScreen extends StatelessWidget {
  Future<Map<String, dynamic>> fetchData() async {
    // final apiUrl = Uri.parse('http://10.11.3.211:8000/userdata');
    final apiUrl = Uri.parse('http://10.11.8.108:8000/getprofile');
    final response = await http.get(
      apiUrl,
      headers: {
        'Authorization': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMDE1MDIxQG5lYy5lZHUuaW4iLCJleHAiOjE3MTEzNDQ1MjN9.D7z9Z3ZuHAP0k2mkGykeUmMi_SMoVXjUxYMVQ80n0Rk',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('User Profile'),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.lightBlue[200],
            padding: EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage('assets/profile_image.jpg'),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Bio: Information Technology Student',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCountContainer('Visited Companies', 10),
                      _buildCountContainer('Eligible Companies', 5),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'Companies Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('Company Name')),
                              DataColumn(label: Text('Location')),
                              DataColumn(label: Center(child: Text('Date Visited'))),
                              DataColumn(label: Center(child: Text('Rounds Completed'))),
                              DataColumn(label: Text('Stream')),
                              DataColumn(label: Text('Package')),
                            ],
                            rows: [
                              _buildDataRow('Company A', 'Location A', DateTime(2023, 1, 15), 3, 'IT,CSE', '5,00,000'),
                              _buildDataRow('Company B', 'Location B', DateTime(2023, 2, 10), 2, 'ECE', '2,00,000'),
                              _buildDataRow('Company C', 'Location C', DateTime(2023, 3, 5), 1, 'EEE,Mech', '3,50,000'),
                              _buildDataRow('Company D', 'Location D', DateTime(2023, 4, 20), 2, 'AIDS,IT,CSE', '8,00,000'),
                              _buildDataRow('Company E', 'Location E', DateTime(2023, 5, 8), 3, 'ECE,EEE,Mech', '4,50,000'),
                              _buildDataRow('Company F', 'Location F', DateTime(2023, 6, 12), 2, 'IT', '4,60,000'),
                              _buildDataRow('Company G', 'Location G', DateTime(2023, 7, 18), 3, 'AIDS', '6,00,000'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCountContainer('Skillrack', 20),
                      _buildCountContainer('LeetCode', 15),
                      _buildCountContainer('CodeChef', 25),
                      _buildCountContainer('HackerRank', 30),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountContainer(String title, int count) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(String companyName, String location, DateTime dateVisited, int roundsCompleted, String stream, String package) {
    return DataRow(cells: [
      DataCell(Text(companyName)),
      DataCell(Text(location)),
      DataCell(Center(child: Text('${dateVisited.day}/${dateVisited.month}/${dateVisited.year}'))),
      DataCell(Center(child: Text(roundsCompleted.toString()))),
      DataCell(Text(stream)),
      DataCell(Text(package)),
    ]);
  }
}
