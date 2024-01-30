import 'package:flutter/material.dart';

import 'package:instagram_flutter/widgets/BottomNav.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Search Page"),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
