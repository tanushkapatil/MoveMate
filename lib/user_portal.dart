import 'package:flutter/material.dart';
import 'dummy_data.dart';
import 'bus_result_page.dart'; // Importing the results page

class UserPortal extends StatefulWidget {
  @override
  _UserPortalState createState() => _UserPortalState();
}

class _UserPortalState extends State<UserPortal> {
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  bool _sourceEmptyError = false;
  bool _destinationEmptyError = false;

  List<String> _filteredSourceStops = [];
  List<String> _filteredDestinationStops = [];
  bool _showSourceSuggestions = false;
  bool _showDestinationSuggestions = false;

  List<String> get _allStops {
    Set<String> stops = {};
    for (var bus in busRoutes) {
      stops.addAll(bus['route']);
    }
    return stops.toList();
  }

  void _filterSourceStops(String query) {
    setState(() {
      _filteredSourceStops = _allStops
          .where((stop) => stop.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _showSourceSuggestions = true;
    });
  }

  void _filterDestinationStops(String query) {
    setState(() {
      _filteredDestinationStops = _allStops
          .where((stop) => stop.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _showDestinationSuggestions = true;
    });
  }

  void _showAllSourceStops() {
    setState(() {
      _filteredSourceStops = _allStops;
      _showSourceSuggestions = true;
      _showDestinationSuggestions = false;
    });
  }

  void _showAllDestinationStops() {
    setState(() {
      _filteredDestinationStops = _allStops;
      _showDestinationSuggestions = true;
      _showSourceSuggestions = false;
    });
  }

  void _validateAndSearch() {
    setState(() {
      _sourceEmptyError = _sourceController.text.trim().isEmpty;
      _destinationEmptyError = _destinationController.text.trim().isEmpty;
    });

    if (!_sourceEmptyError && !_destinationEmptyError) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BusResultsPage(
            source: _sourceController.text.trim(),
            destination: _destinationController.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2E),
      appBar: AppBar(
        title: Text('User Portal'),
        backgroundColor: Color(0xFF7F56D9),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 360),
            child: Card(
              color: Color(0xFF2A2A3D),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Search Bus',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _sourceController,
                      onChanged: _filterSourceStops,
                      onTap: _showAllSourceStops,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Source',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon:
                            Icon(Icons.my_location, color: Color(0xFF7F56D9)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF7F56D9)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF7F56D9), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorText:
                            _sourceEmptyError ? 'Please enter a source' : null,
                      ),
                    ),
                    if (_showSourceSuggestions &&
                        _filteredSourceStops.isNotEmpty)
                      _buildSuggestionBox(_filteredSourceStops,
                          _sourceController, isSource: true),
                    SizedBox(height: 20),
                    TextField(
                      controller: _destinationController,
                      onChanged: _filterDestinationStops,
                      onTap: _showAllDestinationStops,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Destination',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon:
                            Icon(Icons.location_on, color: Color(0xFF7F56D9)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF7F56D9)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF7F56D9), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorText: _destinationEmptyError
                            ? 'Please enter a destination'
                            : null,
                      ),
                    ),
                    if (_showDestinationSuggestions &&
                        _filteredDestinationStops.isNotEmpty)
                      _buildSuggestionBox(_filteredDestinationStops,
                          _destinationController,
                          isSource: false),
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _validateAndSearch,
                      icon: Icon(Icons.search),
                      label: Text("Check Buses"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7F56D9),
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionBox(List<String> stops, TextEditingController controller,
      {required bool isSource}) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFF7F56D9)),
      ),
      child: ListView.builder(
        itemCount: stops.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              stops[index],
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              setState(() {
                controller.text = stops[index];
                if (isSource) {
                  _showSourceSuggestions = false;
                } else {
                  _showDestinationSuggestions = false;
                }
              });
            },
          );
        },
      ),
    );
  }
}
