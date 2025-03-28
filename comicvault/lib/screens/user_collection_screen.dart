import 'package:flutter/material.dart';
import 'package:comicvault/services/api_service.dart';
import 'package:comicvault/models/comic_issue.dart';
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
          ],
        ),
      ),
    );
  }
}


// TODO: user collection should query the firestore and display the user collection in a grid similar to other display sections 
// in the app with a search at the top to query for a specific comic 