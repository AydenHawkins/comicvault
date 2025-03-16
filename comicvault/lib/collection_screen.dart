import 'package:flutter/material.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "My Collection",
            style: TextStyle(
              fontFamily: "ComicNeue",
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 110, 110, 110),
      ),
      backgroundColor: Color.fromARGB(255, 18, 18, 18),
      body: Column(
        children: [
          CollectionHeader(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return CollectionCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CollectionCard extends StatelessWidget {
  const CollectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        title: Text(
          "Generic Title",
          style: TextStyle(
            fontFamily: "ComicNeue",
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "Generic Author",
          style: TextStyle(
            fontFamily: "ComicNeue",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      child: Image.network(
        "https://th.bing.com/th/id/OIP.9sOrE4Gvy0gLl8i7jjp-9gHaLY?w=200&h=307&c=7&r=0&o=5&pid=1.7",
        fit: BoxFit.cover,
      ),
    );
  }
}

class CollectionHeader extends StatelessWidget {
  const CollectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        children: [
          TextFormField(
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "ComicNeue",
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: "Search Collection",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: TextStyle(fontFamily: "ComicNeue"),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 110, 110, 110),
                ),
                onPressed: () {
                  print(
                    "Write a function to scan in comics. Probably screen transition.",
                  );
                },
                child: Text(
                  "Add Comic",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "ComicNeue",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton.icon(
                icon: Icon(Icons.sort, color: Colors.white),
                label: Text(
                  "Sort",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "ComicNeue",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 110, 110, 110),
                ),
                onPressed: () {
                  print(
                    "Probably open some dropdown menu with different sort options. Alphabetical for example.",
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
