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
      // height: 200,
      // width: 150,
      child: Card(
        color: const Color.fromARGB(255, 75, 75, 75),
        child: Column(
          children: [
            Spacer(flex: 6),
            SizedBox(
              width: imageWidth * 0.75,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  "https://th.bing.com/th/id/OIP.9sOrE4Gvy0gLl8i7jjp-9gHaLY?w=200&h=307&c=7&r=0&o=5&pid=1.7",
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Spacer(flex: 3),
            Text(
              "Generic Title",
              style: TextStyle(
                fontFamily: "ComicNeue",
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              "Generic Author",
              style: TextStyle(
                fontFamily: "ComicNeue",
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Spacer(flex: 6),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      color: const Color.fromARGB(255, 171, 171, 171),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.1 * 0.5,
            color: const Color.fromARGB(255, 110, 110, 110),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: TextEditingController(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 75, 75, 75),
                  ),
                ),
                labelText: "Search Comics",
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(125, 255, 255, 255),
                  fontFamily: "ComicNeue",
                ),
              ),
            ),
          ),
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
      backgroundColor: Color.fromARGB(255, 18, 18, 18),
      body: Column(
        children: [
          SearchBar(),
          Expanded(
            child: GridView.builder(
              itemCount: 12,
              padding: EdgeInsets.all(25),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                return ComicCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
