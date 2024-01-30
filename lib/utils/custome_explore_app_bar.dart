// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomExploreAppBar extends StatelessWidget {
  const CustomExploreAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      centerTitle: false,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Container(
        height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(60, 60, 59, 0.808), //27, 27, 31,
        ),
        child: TextField(
          cursorColor: Colors.white,
          decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                size: 24,
                color: Colors.grey.shade500,
              )),
          style: TextStyle(color: Colors.white, fontSize: 16.5),
        ),
      ),
    );
  }
}
