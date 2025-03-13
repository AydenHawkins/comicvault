import 'package:flutter/material.dart';

//This class could be used in both the search page and the collection page.
//Similar to a custom card we made in class.
//Going to use default values for now. Later pass in values pulled from DB.
class ComicCard extends StatelessWidget {
  const ComicCard({super.key});

  @override
  //Prototype card has image, title, author
  //Add more later if needed
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width / 3;
    double imageHeight = MediaQuery.of(context).size.width / 3;

    return SizedBox(
      height: 500,
      //width: 150,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              "https://th.bing.com/th/id/OIP.9sOrE4Gvy0gLl8i7jjp-9gHaLY?w=200&h=307&c=7&r=0&o=5&pid=1.7",
              width: imageWidth,
              height: imageHeight,
            ),
            Text(
              "Generic Title",
              style: TextStyle(fontFamily: "ComicNeue", fontSize: 18),
            ),
            Text(
              "Generic Author",
              style: TextStyle(fontFamily: "ComicNeue", fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: 12,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          return ComicCard();
        },
      ),
    );
  }
}
