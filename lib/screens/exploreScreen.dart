import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/custome_explore_app_bar.dart';
import 'package:instagram_flutter/widgets/BottomNav.dart';
import 'package:instagram_flutter/widgets/category_bar.dart';
import 'package:instagram_flutter/widgets/persistent_header.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ExplorePage extends StatefulWidget {
  ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<String> urls = [];

  @override
  void initState() {
    super.initState();
    _loadExplorePageImages();
  }

  Future<void> _loadExplorePageImages() async {
    try {
      List<String> fetchedUrls = await getExplorePageImages();
      setState(() {
        urls = fetchedUrls;
      });
    } catch (e) {
      print('Error loading explore page images: $e');
      // Handle the error accordingly in your application
    }
  }

  Future<List<String>> getExplorePageImages() async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child("profilePics");
      ListResult list = await storageReference.listAll();
      List<String> images = [];

      for (Reference ref in list.items) {
        String downloadURL = await ref.getDownloadURL();
        images.add(downloadURL);
      }

      return images;
    } catch (e) {
      print('Error retrieving images from storage: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: Container(
        child: CustomScrollView(
          slivers: [
            CustomExploreAppBar(),
            SliverPersistentHeader(
              pinned: true,
              delegate: PersistentHeader(
                child: CategoryBar(
                  categories: const [
                    "North America",
                    "Europe",
                    "Asia",
                    "Australia"
                  ],
                ),
              ),
            ),
            SliverStaggeredGrid.countBuilder(
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              crossAxisCount: 3,
              staggeredTileBuilder: (int index) {
                int modedIndex = index % 20;
                int cXCellCount = modedIndex == 11 ? 2 : 1;

                double mXCellCount = 1;

                if (modedIndex == 2 || modedIndex == 11) {
                  mXCellCount = 2;
                }

                return StaggeredTile.count(cXCellCount, mXCellCount);
              },
              itemBuilder: (BuildContext context, int index) {
                if (index < urls.length) {
                  return Container(
                    color: Colors.amber,
                    child: Image.network(
                      urls[index],
                      fit: BoxFit.cover,
                    ),
                  );
                } else {
                  return Container();
                }
              },
              itemCount: urls.length,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ExplorePage(),
  ));
}
