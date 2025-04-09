import 'package:flutter/material.dart';

class LocationSelectionPage extends StatefulWidget {
  @override
  _LocationSelectionPageState createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  final List<String> dummyLocations = [
    'Swargate', 'Shivajinagar', 'Pimpri', 'Hinjewadi', 'Wakad', 'Baner', 'Kothrud'
  ];

  String? selectedSource;
  String? selectedDestination;

  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  List<String> filteredSources = [];
  List<String> filteredDestinations = [];

  void updateSuggestions(String input, bool isSource) {
    setState(() {
      final suggestions = dummyLocations
          .where((location) => location.toLowerCase().startsWith(input.toLowerCase()))
          .toList();

      if (isSource) {
        filteredSources = suggestions;
      } else {
        filteredDestinations = suggestions;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF090909),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(height: 60),
            TextField(
              controller: sourceController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter Source',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Color(0xFF1E1E2E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => updateSuggestions(value, true),
              onTap: () => updateSuggestions(sourceController.text, true),
            ),
            ...filteredSources.map((loc) => ListTile(
                  title: Text(loc, style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      selectedSource = loc;
                      sourceController.text = loc;
                      filteredSources.clear();
                    });
                  },
                )),
            SizedBox(height: 20),
            TextField(
              controller: destinationController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter Destination',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Color(0xFF1E1E2E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => updateSuggestions(value, false),
              onTap: () => updateSuggestions(destinationController.text, false),
            ),
            ...filteredDestinations.map((loc) => ListTile(
                  title: Text(loc, style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      selectedDestination = loc;
                      destinationController.text = loc;
                      filteredDestinations.clear();
                    });
                  },
                )),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (selectedSource != null && selectedDestination != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Fetching buses from $selectedSource to $selectedDestination'),
                  ));
                  // Navigate to results page or show dummy result.
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7F56D9),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text('Check Buses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
