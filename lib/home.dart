import 'dart:async';
import 'dart:convert';
import 'package:parentsapp/placement_info.dart';
import 'package:parentsapp/student_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'userprofile.dart';
import 'Screens/Login/components/login_form.dart';

class ImageModel {
  String id;
  String imageUrl;
  String companyUrl;
  ImageModel({required this.id, required this.imageUrl,required this.companyUrl});
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'companyUrl': companyUrl,
    };
  }

  // Create an ImageModel from a JSON object
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      imageUrl: json['imageUrl'],
      companyUrl: json['companyUrl'],
    );
  }

}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final PageController pageController;
  final ScrollController _scrollController = ScrollController();
  int pageNo = 0;

  Timer? carasouelTmer;

  get left => null;

  get builder => null;

  Timer getTimer() {
    return Timer.periodic(const Duration(seconds: 3), (timer) {
      if (pageNo == 4) {
        pageNo = 0;
      }
      pageController.animateToPage(
        pageNo,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOutCirc,
      );
      pageNo++;
    });
  }


  List<ImageModel> images = [
    ImageModel(id: '1', imageUrl: 'data:image/jpeg;base64,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',companyUrl :'https://finsurge.tech/finsurge_site/home'),
    ImageModel(id: '2', imageUrl: 'https://www.ibm.com/brand/experience-guides/developer/b1db1ae501d522a1a4b49613fe07c9f1/01_8-bar-positive.svg',companyUrl :''),
    ImageModel(id: '3', imageUrl: 'https://www.ibm.com/brand/experience-guides/developer/b1db1ae501d522a1a4b49613fe07c9f1/01_8-bar-positive.svg',companyUrl :''),
    ImageModel(id: '4', imageUrl: 'https://www.ibm.com/brand/experience-guides/developer/b1db1ae501d522a1a4b49613fe07c9f1/01_8-bar-positive.svg',companyUrl :''),
    ImageModel(id: '5', imageUrl: 'https://www.ibm.com/brand/experience-guides/developer/b1db1ae501d522a1a4b49613fe07c9f1/01_8-bar-positive.svg',companyUrl :''),


    // Add more images as needed
  ];
  List<ImageModel> pre = [];


  TextEditingController _imageUrlController = TextEditingController();
  TextEditingController _companyUrlController = TextEditingController();
  int? selectedIndex;

  @override
  void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: 0.85);
    carasouelTmer = getTimer();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        showBtmAppBr = false;
        setState(() {});
      } else {
        showBtmAppBr = true;
        setState(() {});
      }
    });
    loadDataFromJson();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  bool showBtmAppBr = true;

  Future<void> loadDataFromJson() async {
    try {
      // Load data from the JSON file (replace 'data.json' with your file path)
      String jsonData = await rootBundle.loadString('assets/data.json');
      List<dynamic> jsonList = json.decode(jsonData);

      // Convert JSON objects to ImageModel instances
      List<ImageModel> loadedImages = jsonList.map((json) => ImageModel.fromJson(json)).toList();

      setState(() {
        images = loadedImages;
      });
    } catch (e) {
      print('Error loading data from JSON: $e');
    }
  }

  // void saveDataToJson() {
  //   try {
  //     // Convert ImageModel instances to JSON objects
  //     List<Map<String, dynamic>> jsonList = images.map((image) => image.toJson()).toList();
  //
  //     // Convert the list of JSON objects to a JSON string
  //     String jsonString = json.encode(jsonList);
  //
  //     // Save the JSON string to a file (replace 'data.json' with your desired file path)
  //     File('assets/data.json' as List<Object>).writeAsStringSync(jsonString);
  //   } catch (e) {
  //     print('Error saving data to JSON: $e');
  //   }
  // }


  // void _addImage() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       _imageUrlController.clear();
  //       _companyUrlController.clear();
  //       return AlertDialog(
  //         title: Text('Add Image'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: _imageUrlController,
  //               decoration: InputDecoration(labelText: 'Image URL'),
  //             ),
  //             TextField(
  //               controller: _companyUrlController,
  //               decoration: InputDecoration(labelText: 'Company Url'),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               fetchData();
  //               _saveImage();
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Add'),
  //           ),
  //         ],
  //       );
  //     },
  //
  //   );
    // ImageModel newImage = ImageModel(
    //   id: DateTime.now().toString(),
    //   imageUrl: _imageUrlController.text,
    //   companyUrl: _companyUrlController.text,
    // );
    //
    // setState(() {
    //   images.add(newImage);
    //   _imageUrlController.clear();
    //   _companyUrlController.clear();
    // });
    //
    // // Save the updated data to the JSON file
    // saveDataToJson();
  // }

// Modify the onTap method to edit the image
//   void _editImage(int index) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Edit Image'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: _imageUrlController,
//                 decoration: InputDecoration(labelText: 'Image URL'),
//               ),
//               TextField(
//                 controller: _companyUrlController,
//                 decoration: InputDecoration(labelText: 'Company Url'),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 _saveImage();
//                 Navigator.of(context).pop();
//               },
//               child: Text('Update'),
//             ),
//             TextButton(
//               onPressed: () {
//                 _previous();
//                 Navigator.of(context).pop();
//               },
//               child: Text('Previous'),
//             ),
//             if (selectedIndex != null)
//               TextButton(
//                 onPressed: () {
//                   _deleteImage();
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Delete'),
//               ),
//           ],
//
//         );
//
//       },
//     );
    // if (selectedIndex != null && selectedIndex! < images.length) {
    //   setState(() {
    //     images[selectedIndex!].imageUrl = _imageUrlController.text;
    //     images[selectedIndex!].companyUrl = _companyUrlController.text;
    //     selectedIndex = null;
    //     _imageUrlController.clear();
    //     _companyUrlController.clear();
    //   });
    //
    //   // Save the updated data to the JSON file
    //   saveDataToJson();
    // }


  // }

  // Future<void> fetchData() async {
  //   print("hi");
  //
  //   final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMDE1MDUzQG5lYy5lZHUuaW4iLCJleHAiOjE3MDQ4NzcwMDd9.ZLdX5UwchtJZDTrYNsYpwSVWYEBM5WAaSiMaVA1e8A0";
  //
  //   final String imageUrl = _imageUrlController.text;
  //   //print(imageUrl);
  //
  //   final String companyUrl = _companyUrlController.text;
  //   //print(companyUrl);
  //   final Map<String, dynamic> requestData ={
  //     "data": {
  //       "image_url": imageUrl,
  //       "company_url": companyUrl,
  //     }
  //   };
  //
  //   try {
  //
  //     final http.Response response = await http.post(
  //       Uri.parse('http:/10.11.5.203:8000/addcompany'),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": token,
  //       },
  //       body: jsonEncode(requestData),
  //     );
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       // Successful response, parse the data
  //       print('Response data: ${response.body}');
  //     } else {
  //       // Handle error response
  //       print('Error - Status code: ${response.statusCode}');
  //       print('Error - Body: ${response.body}');
  //     }
  //   } catch (e, stackTrace) {
  //     // Handle network and other errors
  //     print('Error: $e');
  //     print('Stack trace: $stackTrace');
  //   }
  // }
  // void _saveImage() {
  //
  //   if (_imageUrlController.text.isNotEmpty && _companyUrlController.text.isNotEmpty) {
  //     if (selectedIndex == null) {
  //       // Add new image
  //       images.add(
  //         ImageModel(
  //           id: DateTime.now().toString(),
  //           imageUrl: _imageUrlController.text,
  //           companyUrl: _companyUrlController.text,
  //         ),
  //       );
  //       // Update the page count when a new image is added
  //       pageNo = images.length - 1;
  //     } else {
  //       // Update existing image
  //       images[selectedIndex!].imageUrl = _imageUrlController.text;
  //       images[selectedIndex!].companyUrl = _companyUrlController.text;
  //       selectedIndex = null;
  //     }
  //     setState(() {
  //       _imageUrlController.text = '';
  //       _companyUrlController.text = '';
  //     });
  //   }
  //
  // }
  //
  // void _deleteImage() {
  //
  //   if (selectedIndex != null && selectedIndex! < images.length) {
  //     setState(() {
  //       images.removeAt(selectedIndex!);
  //       selectedIndex = null;
  //       _imageUrlController.clear();
  //       _companyUrlController.clear();
  //     });
  //
  //     // Save the updated data to the JSON file
  //     //saveDataToJson();
  //   }
  // }

  // void _previous(){
  //   if (pre.length >= 6) {
  //     pre.removeAt(0);
  //   }
  //   pre.add(images[selectedIndex!]);
  //   _deleteImage();
  // }

  // void _navigateToDetailPage(ImageModel selectedImage) {
  //   // Navigate to another page (DetailPage) with the selected image details
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => DetailPage(image: selectedImage)),
  //   );
  // }
  //
  void logout(){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LoginForm()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(

        child: SingleChildScrollView(



          controller: _scrollController,
          child: Column(

            children: [
              const SizedBox(
                height: 36.0,

              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ListTile(
                  onTap: () {},
                  selected: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                  ),
                  selectedTileColor: Colors.indigoAccent.shade100,
                  title: Text(
                    "NEC Placement",
                    style: Theme.of(context).textTheme.subtitle1!.merge(
                      const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    "A Greet welcome to you.",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          child: ListTile(
                            leading: Icon(
                              CupertinoIcons.person,
                            ),
                            title: Text("My Profile"),
                            onTap: () {
                              // Navigate to the UserProfile page
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => StudentProfileScreen()), // Assuming UserProfile is the name of your profile page
                              );
                            },
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            leading: Icon(Icons.calendar_today),
                            title: Text("Contest"),
                          ),
                          //onTap: hi, // Replace with the actual function reference
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            leading: Icon(
                              Icons.logout,
                            ),
                            title: Text("Log Out"),
                            onTap: logout,
                          ),

                        ),
                      ];
                    },
                    icon: CircleAvatar(
                      backgroundImage: const AssetImage('assets/apple.png'),
                      child: Container(),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 100.0), // Adjust the left padding as needed
                child: Text(
                  "Upcoming Companies",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    color: Colors.black87,
                  ),
                ),
              ),

              Container(
                // Replace with the color you desire
                height: 200,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) {
                    pageNo = index;
                    setState(() {});
                  },
                  itemBuilder: (_, index) {
                    return AnimatedBuilder(
                      animation: pageController,
                      builder: (ctx, child) {
                        return child!;
                      },
                      child: GestureDetector(
                        onTap: () {
                          // _editImage(index);
                          setState(() {
                            selectedIndex = index;
                            _imageUrlController.text = images[index].imageUrl;
                            _companyUrlController.text = images[index].companyUrl;
                          });
                        },
                        onPanDown: (d) {
                          carasouelTmer?.cancel();
                          carasouelTmer = null;
                        },
                        onPanCancel: () {
                          carasouelTmer = getTimer();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              right: 8, left: 8, top: 24, bottom: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                            color: Colors.amberAccent,
                            image: DecorationImage(
                              image: NetworkImage(images[index].imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: images.length,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: List.generate(
                  images.length,
                      (index) => GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.circle,
                        size: 12.0,
                        color: pageNo == index
                            ? Colors.indigoAccent
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              // SizedBox(
              //   height: 50, // height of the button
              //   width: 250, // width of the button
              //   child: ElevatedButton(
              //     style: ButtonStyle(
              //       backgroundColor: MaterialStateProperty.all<Color>(Colors.indigoAccent.shade100),
              //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //         RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10.0),
              //           side: const BorderSide(color: Colors.white),
              //         ),
              //       ),
              //     ),
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => place()),
              //       );
              //     },
              //     child: const Text(
              //       'Placement Information',
              //       style: TextStyle(
              //         fontWeight: FontWeight.w500,
              //         fontSize: 16.0,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),

              const SizedBox(
                height: 24.0,
              ),
              // SizedBox(
              //   height:50, //height of button
              //   width:250, //width of button
              //   child: ElevatedButton(
              //     style: ButtonStyle(
              //         backgroundColor: MaterialStateProperty.all<Color>(Colors.indigoAccent.shade100),
              //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //             RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(10.0),
              //                 side: const BorderSide(color: Colors.white)
              //             )
              //         )
              //     ),
              //     onPressed: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(builder: (context) => student_data()),
              //         );
              //     },
              //     child: const Text('Student Details',style: TextStyle(
              //       fontWeight: FontWeight.w500,
              //       fontSize: 16.0,
              //       color: Colors.white,
              //     )),
              //   ),
              // ),
              const SizedBox(
                height: 24.0,
              ),
              // SizedBox(
              //   height:50, //height of button
              //   width:250, //width of button
              //   child: ElevatedButton(
              //     style: ButtonStyle(
              //         backgroundColor: MaterialStateProperty.all<Color>(Colors.indigoAccent.shade100),
              //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //             RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(10.0),
              //                 side: const BorderSide(color: Colors.white)
              //             )
              //         )
              //     ),
              //
              //     onPressed: () {},
              //     child: const Text('Placed Details'
              //         ,style: TextStyle(
              //           fontWeight: FontWeight.w500,
              //
              //           fontSize: 16.0,
              //
              //           color: Colors.white,
              //         )),
              //
              //   ),
              // ),
              const SizedBox(
                height: 24.0,
              ),
              const Padding(
                padding: EdgeInsets.only(right : 100.0), // Adjust the left padding as needed
                child: Text(
                  " Previously Visited Companies",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    color: Colors.black87,
                  ),
                ),
              ),

              Padding(
                  padding: EdgeInsets.all(24.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      mainAxisExtent: 200,
                    ),
                    itemCount: pre.length, // Use updated list length
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () {
                          //_navigateToDetailPage(pre[index]);
                          setState(() {
                            selectedIndex = index;
                            _imageUrlController.text = images[index].imageUrl;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.amberAccent,
                            border: Border.all(color: Colors.indigoAccent),
                          ),
                          // Customize grid item content based on images[index]
                          // For example, you can show an image or any other widget
                          child: Image.network(pre[index].imageUrl, fit: BoxFit.cover),
                        ),
                      );
                    },
                  )

              ),

            ],
          ),
        ),

      ),

      floatingActionButtonLocation: showBtmAppBr
          ? FloatingActionButtonLocation.centerDocked
          : FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _addImage();
        },
        child: const Icon(
          Icons.add,
        ),
      ),


      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(
          milliseconds: 800,
        ),
        curve: Curves.easeInOutSine,
        height: showBtmAppBr ? 70 : 0,
        child: BottomAppBar(
          notchMargin: 8.0,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.home_outlined,
                ),
              ),

              const SizedBox(
                width: 50,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.heart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}

class PopUpMen extends StatelessWidget {
  final List<PopupMenuEntry> menuList;
  final Widget? icon;
  const PopUpMen({Key? key, required this.menuList, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      itemBuilder: ((context) => menuList),
      icon: icon,
    );
  }
}

