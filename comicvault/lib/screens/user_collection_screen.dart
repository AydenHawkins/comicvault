import 'package:flutter/material.dart';
import 'package:comicvault/custom_widgets/comic_card.dart';

class UserCollectionScreen extends StatefulWidget {
  const UserCollectionScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<UserCollectionScreen> {
  String _selectedCategory = 'issue';
  final TextEditingController _seriesController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();

  // These will be used once the screen is able to query the user's collection from the firestore
  final bool _isLoading = false;
  final String _errorMessage = '';
  final List<dynamic> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Collection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items:
                  <String>[
                    'issue',
                    'character',
                    'series',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),

            SizedBox(height: 16),

            TextField(
              controller: _seriesController,
              decoration: InputDecoration(
                labelText: 'Series Name',
                border: OutlineInputBorder(),
              ),
              // onSubmitted: (_) => _performSearch(),
            ),

            SizedBox(height: 16),

            TextField(
              controller: _issueController,
              decoration: InputDecoration(
                labelText: 'Issue Number',
                border: OutlineInputBorder(),
              ),
              // onSubmitted: (_) => _performSearch(),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 16),
            Expanded(
              child:
                  _searchResults.isEmpty && !_isLoading
                      ? Center(child: Text('No comics in collection yet'))
                      : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.6,
                        ),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final comic = _searchResults[index];
                          return ComicCardV2(comic: comic);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}


// TODO: user collection should query the firestore and display the user collection in a grid similar to other display sections 
// in the app with a search at the top to query for a specific comic 