import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dummy_data.dart';
import 'home_page_for_driver.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DriverDashboard extends StatefulWidget {
  final String busCode;

  const DriverDashboard({Key? key, required this.busCode}) : super(key: key);

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  List<bool> seatStatus = List.generate(40, (index) => false);
  bool isSharingLocation = false;
  int availableSeats = 40;
  int _currentIndex = 0;
  int nextStopToMark = 0;
  Position? _currentPosition;
  late Timer _locationUpdateTimer;
  StreamSubscription<Position>? _positionSubscription;

  Future<bool> _onWillPop() async {
    return false; // Prevent back button from logging out
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _locationUpdateTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bus = busRoutes.firstWhere((bus) => bus['busCode'] == widget.busCode);
    List<String> route = List<String>.from(bus['route']);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E2E),
        appBar: AppBar(
          title: Text('${widget.busCode} - Driver Dashboard'),
          backgroundColor: const Color(0xFF7F56D9),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _confirmLogout,
            ),
          ],
        ),
        body: _getCurrentTabContent(route),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _getCurrentTabContent(List<String> route) {
    switch (_currentIndex) {
      case 0:
        return _buildRouteTab(route);
      case 1:
        return _buildLocationTab();
      case 2:
        return _buildSeatsTab();
      case 3:
        return _buildBreakdownTab();
      default:
        return _buildRouteTab(route);
    }
  }

  Widget _buildRouteTab(List<String> route) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRouteCard(route),
          const SizedBox(height: 20),
          Text(
            'Bus Status: Operational',
            style: TextStyle(
              color: Colors.green,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Next Stop: ${nextStopToMark < route.length ? route[nextStopToMark] : 'Route Completed'}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(List<String> route) {
    return Card(
      color: const Color(0xFF2A2A3D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Route Details',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: List.generate(route.length, (index) {
                bool isPassed = index < nextStopToMark;
                bool isNext = index == nextStopToMark;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 12,
                          color: isPassed ? Colors.grey : Colors.white,
                        ),
                        if (index != route.length - 1)
                          Container(
                            height: 30,
                            width: 2,
                            color: isPassed ? Colors.grey : Colors.white54,
                          ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Text(
                                  route[index],
                                  style: TextStyle(
                                    color:
                                        isPassed ? Colors.grey : Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                if (isPassed)
                                  Positioned(
                                    top: 10,
                                    child: Container(
                                      height: 1,
                                      width:
                                          MediaQuery.of(context).size.width * 0.6,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPassed
                                  ? Colors.grey
                                  : (isNext
                                      ? const Color(0xFF7F56D9)
                                      : Colors.grey[700]!),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(80, 30),
                            ),
                            onPressed: isNext
                                ? () {
                                    setState(() {
                                      nextStopToMark++;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('${route[index]} marked as passed'),
                                      ),
                                    );
                                  }
                                : null,
                            child: Text(
                              isPassed ? 'Passed' : 'Mark',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationTab() {
    return Center(
      child: Card(
        color: const Color(0xFF2A2A3D),
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSharingLocation ? Icons.location_on : Icons.location_off,
                size: 50,
                color: isSharingLocation ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                isSharingLocation
                    ? 'Sharing Live Location'
                    : 'Location Sharing Off',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isSharingLocation ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: () async {
                  setState(() {
                    isSharingLocation = !isSharingLocation;
                  });

                  if (isSharingLocation) {
                    // Start location sharing
                    _startLocationUpdates();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Location sharing started')),
                    );
                  } else {
                    // Stop location sharing
                    _stopLocationUpdates();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Location sharing stopped')),
                    );
                  }
                },
                child: Text(
                  isSharingLocation ? 'STOP SHARING' : 'START SHARING',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seat Availability ($availableSeats available)',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildSeatLayout(),
        ],
      ),
    );
  }

  Widget _buildBreakdownTab() {
    bool isBrokenDown = false;

    return Center(
      child: Card(
        color: const Color(0xFF2A2A3D),
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isBrokenDown ? Icons.warning : Icons.check_circle,
                    size: 50,
                    color: isBrokenDown ? Colors.orange : Colors.green,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isBrokenDown
                        ? 'BUS BREAKDOWN REPORTED'
                        : 'Bus is Operational',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isBrokenDown ? Colors.green : Colors.orange,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    onPressed: () {
                      setState(() {
                        isBrokenDown = !isBrokenDown;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isBrokenDown
                              ? 'Breakdown reported to admin'
                              : 'Bus status set to operational'),
                        ),
                      );
                    },
                    child: Text(
                      isBrokenDown ? 'MARK AS FIXED' : 'REPORT BREAKDOWN',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF1E1E2E),
      selectedItemColor: const Color(0xFF7F56D9),
      unselectedItemColor: Colors.white70,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.route),
          label: 'Route',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Location',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_seat),
          label: 'Seats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.warning),
          label: 'Breakdown',
        ),
      ],
    );
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _updateLocationToServer(double latitude, double longitude) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse('https://movemate-server-pearl.vercel.app/location/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'latitude': latitude,
        'longitude': longitude,
        'bus_number': widget.busCode,
      }),
    );

    if (response.statusCode == 200) {
      print('Location updated successfully');
    } else {
      print('Failed to update location');
    }
  }

  void _startLocationUpdates() {
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      _currentPosition = await _getCurrentLocation();
      if (_currentPosition != null) {
        await _updateLocationToServer(
            _currentPosition!.latitude, _currentPosition!.longitude);
      }
    });
  }

  void _stopLocationUpdates() {
    if (_locationUpdateTimer.isActive) {
      _locationUpdateTimer.cancel();
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
            ),
          ],
        );
      },
    );
  }

  void _performLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePageForDriver()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );
  }

  Widget _buildSeatLayout() {
    return Column(
      children: [
        const Text(
          'Tap on seats to mark them as occupied',
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Driver',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: List.generate(10, (row) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      _buildSeat(row),
                      const SizedBox(width: 16),
                      _buildSeat(row + 10),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(width: 40),
            Column(
              children: List.generate(10, (row) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      _buildSeat(row + 20),
                      const SizedBox(width: 16),
                      _buildSeat(row + 30),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSeat(int seatNumber) {
    return GestureDetector(
      onTap: () {
        setState(() {
          seatStatus[seatNumber] = !seatStatus[seatNumber];
          availableSeats = seatStatus.where((status) => !status).length;
        });
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: seatStatus[seatNumber] ? Colors.red : Colors.green,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white54, width: 1),
        ),
        child: Center(
          child: Text(
            '${seatNumber + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}