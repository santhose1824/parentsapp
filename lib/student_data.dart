// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart' as excel_lib;
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:pdf/widgets.dart' as pdf_lib;
import 'package:permission_handler/permission_handler.dart';

import 'CustomDropdownMenu.dart';



// Student Class

class Student {
  static int _serialNumberCounter = 1;
  int serialNo;
  int regNo;
  String name;
  String department;
  String email;
  // String phoneNumber;
  // String panNo;
  // String aadharNo;
  // String gender;
  // DateTime dob;
  // String personalEmail;
  // String caste;
  // String religion;
  // String maritalStatus;
  // String fatherName;
  // String motherName;
  // String fatherOccupation;
  // String fatherPhoneNo;
  // String motherPhoneNo;
  // String address;
  // double sslcMark;
  // double sslcPercentage;
  // double hscMark;
  // double hscPercentage;
  // double diplomaMark;
  // double diplomaPercentage;
  // String board;
  // double cgpa;
  // String schoolName;
  // bool historyOfArrears;
  // int noOfHistoryArrears;
  // bool standingArrears;
  // int noOfStandingArrears;
  // String typesOfCompanies;

  Student(
      this.serialNo,
      this.regNo,
      this.name,
      this.department,
      this.email,
      // this.phoneNumber,
      // this.panNo,
      // this.aadharNo,
      // this.gender,
      // this.dob,
      // this.personalEmail,
      // this.caste,
      // this.religion,
      // this.maritalStatus,
      // this.fatherName,
      // this.motherName,
      // this.fatherOccupation,
      // this.fatherPhoneNo,
      // this.motherPhoneNo,
      // this.address,
      // this.sslcMark,
      // this.sslcPercentage,
      // this.hscMark,
      // this.hscPercentage,
      // this.diplomaMark,
      // this.diplomaPercentage,
      // this.board,
      // this.cgpa,
      // this.schoolName,
      // this.historyOfArrears,
      // this.noOfHistoryArrears,
      // this.standingArrears,
      // this.noOfStandingArrears,
      // this.typesOfCompanies,
      );

// Map function for maping the values

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      _serialNumberCounter++,
      json['id'] as int? ?? 0,
      json['name'] as String? ?? 'Unknown',
      json['department'] as String? ?? 'Unknown',
      json['email'] as String? ?? 'UnKnown',
      // json['phoneNumber'] as String? ?? '',
      // json['panNo'] as String? ?? '',
      // json['aadharNo'] as String? ?? '',
      // json['gender'] as String? ?? '',
      // DateTime.parse(json['dob'] as String? ?? '1970-01-01'),
      // json['personalEmail'] as String? ?? '',
      // json['caste'] as String? ?? '',
      // json['religion'] as String? ?? '',
      // json['maritalStatus'] as String? ?? '',
      // json['fatherName'] as String? ?? '',
      // json['motherName'] as String? ?? '',
      // json['fatherOccupation'] as String? ?? '',
      // json['fatherPhoneNo'] as String? ?? '',
      // json['motherPhoneNo'] as String? ?? '',
      // json['address'] as String? ?? '',
      // (json['sslcMark'] as num?)?.toDouble() ?? 0.0,
      // (json['sslcPercentage'] as num?)?.toDouble() ?? 0.0,
      // (json['hscMark'] as num?)?.toDouble() ?? 0.0,
      // (json['hscPercentage'] as num?)?.toDouble() ?? 0.0,
      // (json['diplomaMark'] as num?)?.toDouble() ?? 0.0,
      // (json['diplomaPercentage'] as num?)?.toDouble() ?? 0.0,
      // json['board'] as String? ?? '',
      // (json['cgpa'] as num?)?.toDouble() ?? 0.0,
      // json['schoolName'] as String? ?? '',
      // json['historyOfArrears'] as bool? ?? false,
      // json['noOfHistoryArrears'] as int? ?? 0,
      // json['standingArrears'] as bool? ?? false,
      // json['noOfStandingArrears'] as int? ?? 0,
      // json['typesOfCompanies'] as String? ?? '',
    );
  }
}

class MyData extends DataTableSource {
  final List<Student> data;
  final Map<String, String> selectedFilters;

  MyData(this.data, this.selectedFilters);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }

    final student = data[index];

    if (selectedFilters.isNotEmpty &&
        !selectedFilters.entries.every((entry) {
          if (entry.key == 'Department') {
            return student.department == entry.value;
          } else if (entry.key == 'SSLC' ||
              entry.key == 'HSC' ||
              entry.key == 'DIPLOMA' ||
              entry.key == 'CGPA' ||
              entry.key == 'History of Arrears') {
            return student.name == entry.value;
          } else if (entry.key == 'No of standing Arrears') {
            return student.name == entry.value;
          } else if (entry.key == 'Year of Passing') {
            return student.name == entry.value;
          }
          return true;
        })) {
      return null;
    }
    return DataRow(cells: [
      DataCell(Text('${student.serialNo}')),
      DataCell(Text('${student.regNo}')),
      DataCell(Text(student.name)),
      DataCell(Text(student.department)),
      DataCell(DropdownMenuExample()),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class student_data extends StatelessWidget {
  const student_data({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(),
    );
  }
}

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  List<String> list = <String>['Active', 'Inactive'];
  String dropdownValue = 'Active';

  @override
  Widget build(BuildContext context) {
    return CustomDropdownMenu<String>(
      initialSelection: list.first,
      onSelected: (String? value) {
        // Handle the selected value
      },
      dropdownMenuEntries: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      dropdownHeight: 150.0,
      dropdownWidth: 100.0,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, String> selectedFilters = {};
  List<Student> data = [];
  List<Student> filteredData = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void downloadExcelData(Map<String, bool> options) {
    List<List<dynamic>> excelData = [];
    List<String> headers = ['S.No', 'Regno', 'Name', 'Department'];

    for (var option in options.keys) {
      if (options[option]!) {
        headers.add(option);
      }
    }
    excelData.add(headers);
    for (var student in filteredData) {
      List<dynamic> rowData = [];
      for (var option in headers) {
        switch (option) {
          case 'S.No':
            rowData.add(student.serialNo);
            break;
          case 'Regno':
            rowData.add(student.regNo);
            break;
          case 'Name':
            rowData.add(student.name);
            break;
          case 'Department':
            rowData.add(student.department);
            break;
        // case 'Email':
        //   rowData.add(student.email);
        //   break;
        // case 'Phone Number':
        //   rowData.add(student.phoneNumber);
        //   break;
        // case 'Pan No':
        //   rowData.add(student.panNo);
        //   break;
        // case 'Aadhar No':
        //   rowData.add(student.aadharNo);
        //   break;
        // case 'Gender':
        //   rowData.add(student.gender);
        //   break;
        // case 'DOB':
        //   rowData.add(student.dob.toLocal().toString());
        //   break;
        // case 'Personal Email':
        //   rowData.add(student.personalEmail);
        //   break;
        // case 'Caste':
        //   rowData.add(student.caste);
        //   break;
        // case 'Religion':
        //   rowData.add(student.religion);
        //   break;
        // case 'Marital Status':
        //   rowData.add(student.maritalStatus);
        //   break;
        // case 'Father Name':
        //   rowData.add(student.fatherName);
        //   break;
        // case 'Mother Name':
        //   rowData.add(student.motherName);
        //   break;
        // case 'Father Occupation':
        //   rowData.add(student.fatherOccupation);
        //   break;
        // case 'Father Phone No':
        //   rowData.add(student.fatherPhoneNo);
        //   break;
        // case 'Mother Phone No':
        //   rowData.add(student.motherPhoneNo);
        //   break;
        // case 'Address':
        //   rowData.add(student.address);
        //   break;
        // case 'SSLC Mark':
        //   rowData.add(student.sslcMark);
        //   break;
        // case 'SSLC Percentage':
        //   rowData.add(student.sslcPercentage);
        //   break;
        // case 'HSC Mark':
        //   rowData.add(student.hscMark);
        //   break;
        // case 'HSC Percentage':
        //   rowData.add(student.hscPercentage);
        //   break;
        // case 'Diploma Mark':
        //   rowData.add(student.diplomaMark);
        //   break;
        // case 'Diploma Percentage':
        //   rowData.add(student.diplomaPercentage);
        //   break;
        // case 'Board':
        //   rowData.add(student.board);
        //   break;
        // case 'CGPA':
        //   rowData.add(student.cgpa);
        //   break;
        // case 'School Name':
        //   rowData.add(student.schoolName);
        //   break;
        // case 'History of Arrears':
        //   rowData.add(student.historyOfArrears);
        //   break;
        // case 'No of History Arrears':
        //   rowData.add(student.noOfHistoryArrears);
        //   break;
        // case 'Standing Arrears':
        //   rowData.add(student.standingArrears);
        //   break;
        // case 'No of Standing Arrears':
        //   rowData.add(student.noOfStandingArrears);
        //   break;
        // case 'Types of Companies':
        //   rowData.add(student.typesOfCompanies);
        //   break;
        }
      }
      excelData.add(rowData);
    }

    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    for (var row in excelData) {
      sheet.appendRow(row);
    }

    showFileNameDialog((String? filename) {
      if (filename != null && filename.isNotEmpty) {
        saveExcel(excel, '$filename.xlsx');
      } else {
        // Handle empty or null filename
        print('Error: Please enter a valid filename.');
      }
    });
  }

  void showFileNameDialog(void Function(String? filename) callback) {
    TextEditingController filenameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Filename'),
          content: TextField(
            controller: filenameController,
            decoration: InputDecoration(labelText: 'Enter filename'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                callback(null);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                String filename = filenameController.text.trim();
                callback(filename);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveExcel(Excel excel, String fileName) async {
    try {
      PermissionStatus manageExternal =
      await Permission.manageExternalStorage.request();
      if (manageExternal == PermissionStatus.granted) {
        final folderPath = await path_provider.getExternalStorageDirectory();
        if (folderPath != null) {
          final excelFile = File('${folderPath.path}/$fileName');
          await excelFile.writeAsBytes(excel.encode()!);
          print('Excel data downloaded successfully to: ${excelFile.path}');
        } else {
          print('Error getting external storage directory');
        }
      } else {
        print('Permission denied to manage external storage');
      }
    } catch (e) {
      print('Error saving Excel data: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        // print(jsonData);
        print(jsonData);
        setState(() {
          data = jsonData.map((json) => Student.fromJson(json)).toList();
          applyFilters();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Data'),
        backgroundColor: const Color.fromARGB(255, 141, 183, 252),
        actions: [
          IconButton(
            onPressed: () {
              showFilterOptions(context);
            },
            icon: const Icon(Icons.filter_alt_sharp),
            color: const Color.fromARGB(115, 0, 0, 0),
            iconSize: 30,
          )
        ],
      ),
      body: MyDataTable(data: filteredData, selectedFilters: selectedFilters),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
              label: 'Excel Download', icon: Icon(Icons.explicit_outlined)),
          BottomNavigationBarItem(
              label: 'PDF Download', icon: Icon(Icons.download_rounded)),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
          if (index == 0) {
            showExcelDownloadOptions(context);
          } else if (index == 1) {
            showPdfDownloadOptions(context);
          }
        },
      ),
    );
  }

  void showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: ConstrainedBox(
                constraints: const BoxConstraints(
                    maxHeight: 5400.0), // Set your desired fixed height
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Column(
                        children: buildFilterDropdowns(setState),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          applyFilters();
                        },
                        child: const Text('Apply Filters'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showExcelDownloadOptions(BuildContext context) {
    Map<String, bool> checkboxStates = {
      'Email': false,
      'Phone Number': false,
      'Pan No': false,
      'Aadhar No': false,
      'Gender': false,
      'DOB': false,
      'Personal Email': false,
      'Caste': false,
      'Religion': false,
      'Marital Status': false,
      'Father Name': false,
      'Mother Name': false,
      'Father Occupation': false,
      'Father Phone No': false,
      'Mother Phone No': false,
      'Address': false,
      'SSLC Mark': false,
      'SSLC Percentage': false,
      'HSC Mark': false,
      'HSC Percentage': false,
      'Diploma Mark': false,
      'Diploma Percentage': false,
      'Board': false,
      'CGPA': false,
      'School Name': false,
      'History of Arrears': false,
      'No of History Arrears': false,
      'Standing Arrears': false,
      'No of Standing Arrears': false,
      'Types of Companies': false,
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Excel Download Options'),
              content: SingleChildScrollView(
                child: Column(
                  children: checkboxStates.keys.map((String field) {
                    return CheckboxListTile(
                      title: Text(field),
                      value: checkboxStates[field],
                      onChanged: (bool? value) {
                        setState(() {
                          checkboxStates[field] = value ?? false;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    downloadExcelData(checkboxStates);
                  },
                  child: const Text('Download'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showPdfDownloadOptions(BuildContext context) {
    Map<String, bool> checkboxStates = {
      'Email': false,
      'Phone Number': false,
      'Pan No': false,
      'Aadhar No': false,
      'Gender': false,
      'DOB': false,
      'Personal Email': false,
      'Caste': false,
      'Religion': false,
      'Marital Status': false,
      'Father Name': false,
      'Mother Name': false,
      'Father Occupation': false,
      'Father Phone No': false,
      'Mother Phone No': false,
      'Address': false,
      'SSLC Mark': false,
      'SSLC Percentage': false,
      'HSC Mark': false,
      'HSC Percentage': false,
      'Diploma Mark': false,
      'Diploma Percentage': false,
      'Board': false,
      'CGPA': false,
      'School Name': false,
      'History of Arrears': false,
      'No of History Arrears': false,
      'Standing Arrears': false,
      'No of Standing Arrears': false,
      'Types of Companies': false,
    };
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('PDF Download Options'),
              content: SingleChildScrollView(
                child: Column(
                  children: checkboxStates.keys.map((String field) {
                    return CheckboxListTile(
                      title: Text(field),
                      value: checkboxStates[field],
                      onChanged: (bool? value) {
                        setState(() {
                          checkboxStates[field] = value ?? false;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    downloadPdfExcelData(checkboxStates);
                  },
                  child: const Text('Download'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void downloadPdfExcelData(Map<String, bool> options) {
    List<List<dynamic>> excelData = [];
    List<String> headers = ['S.No', 'Regno', 'Name', 'Department'];

    for (var option in options.keys) {
      if (options[option]!) {
        headers.add(option);
      }
    }
    excelData.add(headers);
    for (var student in filteredData) {
      List<dynamic> rowData = [];
      for (var option in headers) {
        switch (option) {
          case 'S.No':
            rowData.add(student.serialNo);
            break;
          case 'Regno':
            rowData.add(student.regNo);
            break;
          case 'Name':
            rowData.add(student.name);
            break;
          case 'Department':
            rowData.add(student.department);
            break;
          case 'Email':
            rowData.add(student.email);
            break;
          case 'Phone Number':
          //   rowData.add(student.phoneNumber);
          //   break;
          // case 'Pan No':
          //   rowData.add(student.panNo);
          //   break;
          // case 'Aadhar No':
          //   rowData.add(student.aadharNo);
          //   break;
          // case 'Gender':
          //   rowData.add(student.gender);
          //   break;
          // case 'DOB':
          //   rowData.add(student.dob.toLocal().toString());
          //   break;
          // case 'Personal Email':
          //   rowData.add(student.personalEmail);
          //   break;
          // case 'Caste':
          //   rowData.add(student.caste);
          //   break;
          // case 'Religion':
          //   rowData.add(student.religion);
          //   break;
          // case 'Marital Status':
          //   rowData.add(student.maritalStatus);
          //   break;
          // case 'Father Name':
          //   rowData.add(student.fatherName);
          //   break;
          // case 'Mother Name':
          //   rowData.add(student.motherName);
          //   break;
          // case 'Father Occupation':
          //   rowData.add(student.fatherOccupation);
          //   break;
          // case 'Father Phone No':
          //   rowData.add(student.fatherPhoneNo);
          //   break;
          // case 'Mother Phone No':
          //   rowData.add(student.motherPhoneNo);
          //   break;
          // case 'Address':
          //   rowData.add(student.address);
          //   break;
          // case 'SSLC Mark':
          //   rowData.add(student.sslcMark);
          //   break;
          // case 'SSLC Percentage':
          //   rowData.add(student.sslcPercentage);
          //   break;
          // case 'HSC Mark':
          //   rowData.add(student.hscMark);
          //   break;
          // case 'HSC Percentage':
          //   rowData.add(student.hscPercentage);
          //   break;
          // case 'Diploma Mark':
          //   rowData.add(student.diplomaMark);
          //   break;
          // case 'Diploma Percentage':
          //   rowData.add(student.diplomaPercentage);
          //   break;
          // case 'Board':
          //   rowData.add(student.board);
          //   break;
          // case 'CGPA':
          //   rowData.add(student.cgpa);
          //   break;
          // case 'School Name':
          //   rowData.add(student.schoolName);
          //   break;
          // case 'History of Arrears':
          //   rowData.add(student.historyOfArrears);
          //   break;
          // case 'No of History Arrears':
          //   rowData.add(student.noOfHistoryArrears);
          //   break;
          // case 'Standing Arrears':
          //   rowData.add(student.standingArrears);
          //   break;
          // case 'No of Standing Arrears':
          //   rowData.add(student.noOfStandingArrears);
          //   break;
          // case 'Types of Companies':
          //   rowData.add(student.typesOfCompanies);
          //   break;
        }
      }
      excelData.add(rowData);
    }

    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    for (var row in excelData) {
      sheet.appendRow(row);
    }
    showFileNameDialog((String? filename) async {
      if (filename != null && filename.isNotEmpty) {
        await savePdfExcel(excel, '$filename.xlsx');
        await exportExcelToPDF(
            '$filename.xlsx', '$filename.pdf', excelData.length);
      } else {
        // Handle empty or null filename
        print('Error: Please enter a valid filename.');
      }
    });
  }

  Future<void> exportExcelToPDF(
      String excelFileName, String pdfFileName, int maxRowsPerExport) async {
    try {
      print(maxRowsPerExport);
      PermissionStatus manageExternal =
      await Permission.manageExternalStorage.request();

      if (manageExternal == PermissionStatus.granted) {
        final folderPath = await path_provider.getExternalStorageDirectory();

        if (folderPath != null) {
          final excelFile = File('${folderPath.path}/$excelFileName');

          if (!excelFile.existsSync()) {
            print('Error: Excel file does not exist.');
            return;
          }

          final excel = await excel_lib.Excel.decodeBytes(
            excelFile.readAsBytesSync(),
          );
          final pdf = pdf_lib.Document();

          for (var table in excel.tables.keys) {
            final List<List<String>> tableData = [];

            // Add headers to tableData
            tableData.add(
              List.generate(
                excel.tables[table]!.maxCols,
                    (col) => excel.tables[table]!
                    .cell(CellIndex.indexByColumnRow(
                  columnIndex: col,
                  rowIndex: 0,
                ))!
                    .value
                    .toString(),
              ),
            );

            // Add data rows to tableData
            for (var rowIdx = 1;
            rowIdx <= excel.tables[table]!.maxRows;
            rowIdx += maxRowsPerExport) {
              final endRow =
              (rowIdx + maxRowsPerExport <= excel.tables[table]!.maxRows)
                  ? rowIdx + maxRowsPerExport
                  : excel.tables[table]!.maxRows;

              // Iterate over the rows within the specified chunk
              for (var row = rowIdx; row <= endRow; row++) {
                final rowData = List.generate(
                  excel.tables[table]!.maxCols,
                      (col) => excel.tables[table]!
                      .cell(CellIndex.indexByColumnRow(
                      columnIndex: col, rowIndex: row))!
                      .value
                      .toString(),
                );

                // Only add the row if it contains non-null values
                if (rowData.any((cellValue) =>
                cellValue != 'null' && cellValue.isNotEmpty)) {
                  tableData.add(rowData);
                }
              }
            }

            // Add a page to the PDF
            pdf.addPage(
              pdf_lib.Page(
                build: (context) {
                  return pdf_lib.Table.fromTextArray(
                    context: context,
                    cellAlignment: pdf_lib.Alignment.centerLeft,
                    headerDecoration: const pdf_lib.BoxDecoration(),
                    cellHeight: 30,
                    cellAlignments: {
                      for (int colIdx = 1;
                      colIdx <= excel.tables[table]!.maxCols;
                      colIdx++)
                        colIdx: pdf_lib.Alignment.centerRight,
                    },
                    headerHeight: 40,
                    headerAlignments: {
                      for (int colIdx = 1;
                      colIdx <= excel.tables[table]!.maxCols;
                      colIdx++)
                        colIdx: pdf_lib.Alignment.center,
                    },
                    data: tableData,
                  );
                },
              ),
            );
          }

          final pdfFile = File('${folderPath.path}/$pdfFileName');
          await pdfFile.writeAsBytes(await pdf.save());
          await excelFile.delete();
          print('PDF exported successfully to: ${pdfFile.path}');
        } else {
          print('Error getting external storage directory');
        }
      } else {
        print('Permission denied to manage external storage');
      }
    } catch (e) {
      print('Error exporting Excel to PDF: $e');
    }
  }

  Future<void> savePdfExcel(Excel excel, String fileName) async {
    try {
      PermissionStatus manageExternal =
      await Permission.manageExternalStorage.request();
      if (manageExternal == PermissionStatus.granted) {
        final folderPath = await path_provider.getExternalStorageDirectory();
        if (folderPath != null) {
          final excelFile = File('${folderPath.path}/$fileName');
          await excelFile.writeAsBytes(excel.encode()!);
          print('Excel data downloaded successfully to: ${excelFile.path}');
        } else {
          print('Error getting external storage directory');
        }
      } else {
        print('Permission denied to manage external storage');
      }
    } catch (e) {
      print('Error saving Excel data: $e');
    }
  }

  List<Widget> buildFilterDropdowns(StateSetter setState) {
    int currentYear = DateTime.now().year;
    return [
      buildFilterDropdown(
          "Department", ["", "IT", "CSE", "ECE", "EEE", "CIVIL", "MECH"]),
      buildInputField("SSLC"),
      buildInputField("HSC"),
      buildInputField("DIPLOMA"),
      buildInputField("CGPA"),
      buildFilterDropdown("History of Arrears", ["Yes", "No"]),
      buildFilterDropdown("No of standing Arrears", [""]),
      buildFilterDropdown("Year of Passing", [
        currentYear.toString(),
        (currentYear + 1).toString(),
        (currentYear + 2).toString(),
        (currentYear + 3).toString()
      ]),
    ];
  }

  Widget buildInputField(String filter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(filter),
          const SizedBox(width: 8.0),
          Expanded(
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                // border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                onChanged: (String value) {
                  handleInputFieldChange(filter, value);
                },
                decoration: const InputDecoration.collapsed(hintText: ''),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleInputFieldChange(String filter, String value) {
    if (value.isNotEmpty) {
      selectedFilters[filter] = value;
    } else {
      selectedFilters.remove(filter);
    }
  }

  Widget buildFilterDropdown(String filter, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(filter),
          const SizedBox(width: 8.0),
          Expanded(
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                // border: Border.all(color: Colors.grey),
              ),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration.collapsed(hintText: ''),
                value: selectedFilters[filter],
                onChanged: (String? value) {
                  handleDropdownChange(filter, value);
                },
                items: options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                dropdownColor: Colors.white,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleDropdownChange(String filter, String? value) {
    if (value != null && value.isNotEmpty) {
      selectedFilters[filter] = value;
    } else {
      selectedFilters.remove(filter);
    }
  }

  void applyFilters() {
    filteredData = data.where((student) {
      return selectedFilters.entries.every((entry) {
        if (entry.key == 'Department') {
          return student.department == entry.value;
        } else if (entry.key == 'SSLC' ||
            entry.key == 'HSC' ||
            entry.key == 'DIPLOMA' ||
            entry.key == 'CGPA' ||
            entry.key == 'History of Arrears') {
          return student.name == entry.value;
        } else if (entry.key == 'No of standing Arrears') {
          return student.name == entry.value;
        } else if (entry.key == 'Year of Passing') {
          return student.name == entry.value;
        }
        return true;
      });
    }).toList();

    setState(() {
      filteredData = List.from(filteredData);
    });

    print('Applied Filters: $selectedFilters');
  }
}

class MyDataTable extends StatefulWidget {
  final List<Student> data;
  final Map<String, String> selectedFilters;

  MyDataTable({
    Key? key,
    required this.data,
    required this.selectedFilters,
  }) : super(key: key);

  @override
  State<MyDataTable> createState() => _MyDataTableState();
}

class _MyDataTableState extends State<MyDataTable> {
  String dropdownValue = 'Active';
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PaginatedDataTable(
        columns: const [
          DataColumn(label: Text('S.No')),
          DataColumn(label: Text('Regno')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Department')),
          DataColumn(label: Text("Status"))
        ],
        source: MyData(widget.data, widget.selectedFilters),
      ),
    );
  }
}
