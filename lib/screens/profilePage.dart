// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/models/user.dart' as model;
import 'package:instagram_flutter/ressources/storage_methods.dart';
import 'package:instagram_flutter/utils/utlis.dart';
import 'package:instagram_flutter/widgets/BottomNav.dart';
import 'package:instagram_flutter/DataBaseQueries/UserInformation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  String profilePic =
      "https://www.shutterstock.com/image-vector/vector-flat-illustration-grayscale-avatar-600nw-2281862025.jpg";

  String username = "Not Overridden";
  String bio = "No Bio Available";

  final myImages = [
    Image.network(
        'https://media.cntraveler.com/photos/5fbbdc25bead4eb22be793ae/master/w_2560%2Cc_limit/WinterCamping-2020-GettyImages-628134586.jpg'),
    Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Tent_camping_along_the_Sulayr_trail_in_La_Taha%2C_Sierra_Nevada_National_Park_%28DSCF5147%29.jpg/1200px-Tent_camping_along_the_Sulayr_trail_in_La_Taha%2C_Sierra_Nevada_National_Park_%28DSCF5147%29.jpg'),
    Image.network(
        'https://i.shgcdn.com/dc558f8a-8182-42a8-a957-8ec5e4600138/-/format/auto/-/preview/3000x3000/-/quality/lighter/')
  ];

  int currentIndex = 0;
  Uint8List? profilePicChange;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    model.User user = await Query.getUserInfo();
    setState(() {
      profilePic = user.photoUrl;
      username = user.username;
      bio = user.bio;
    });
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      profilePicChange = img;
    });

    Query.updateProfilePic(profilePicChange.toString());
  }

  void postImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      profilePicChange = img;
    });

    String photoUrl =
        await StorageMethods().uploadImageToStorage('allImages', img, false);

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image Posted'),
          content: const Text('Your image has been posted successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(profilePic),
                            ),
                            Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: () => {},
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '$username',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0, left: 35),
                    child: Container(
                      width: 350,
                      child: Text(
                        bio,
                        softWrap: true,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 250,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(244, 89, 28, 1),
                        Color.fromRGBO(229, 147, 54, 1),
                      ],
                    ),
                  ),
                  child: InkWell(
                    child: const Center(
                      child: Text("Post", style: TextStyle(fontSize: 25)),
                    ),
                    onTap: postImage,
                  ),
                ),
              ],
            ),
            CarouselSlider(
              items: myImages,
              options: CarouselOptions(
                autoPlay: true,
                height: 350,
                reverse: false,
                viewportFraction: 0.9,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
            AnimatedSmoothIndicator(
              activeIndex: currentIndex,
              count: myImages.length,
              effect: const WormEffect(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      appBar: AppBar(
        title: Text("Profile"),
        automaticallyImplyLeading: false,
      ),
    );
  }
}
