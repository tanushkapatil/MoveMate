import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dummy_data.dart';
import 'home_page_for_driver.dart';

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

  Future<bool> _onWillPop() async {
    return false; // Prevent back button from logging out
  }

  @override
  Widget build(BuildContext context) {
    final bus = busRoutes.firstWhere((bus) => bus['busCode'] == widget.busCode);
    List<String> route = List<String>.from(bus['route']);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xFF1E1E2E),
        appBar: AppBar(
          title: Text('${widget.busCode} - Driver Dashboard'),
          backgroundColor: Color(0xFF7F56D9),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
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
      case 0: return _buildRouteTab(route);
      case 1: return _buildLocationTab();
      case 2: return _buildSeatsTab();
      case 3: return _buildBreakdownTab();
      default: return _buildRouteTab(route);
    }
  }

  Widget _buildRouteTab(List<String> route) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRouteCard(route),
          SizedBox(height: 20),
          Text(
            'Bus Status: Operational',
            style: TextStyle(
              color: Colors.green,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Next Stop: ${nextStopToMark < route.length ? route[nextStopToMark] : 'Route Completed'}',
            style: TextStyle(
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
      color: Color(0xFF2A2A3D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Route Details',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 16),
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
                          color: isPassed ? Colors.grey : Colors.white
                        ),
                        if (index != route.length - 1)
                          Container(
                            height: 30,
                            width: 2,
                            color: isPassed ? Colors.grey : Colors.white54,
                          ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Text(
                                  route[index],
                                  style: TextStyle(
                                    color: isPassed ? Colors.grey : Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                if (isPassed)
                                  Positioned(
                                    top: 10,
                                    child: Container(
                                      height: 1,
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPassed 
                                ? Colors.grey 
                                : (isNext ? Color(0xFF7F56D9) : Colors.grey[700]!),
                              foregroundColor: Colors.white,
                              minimumSize: Size(80, 30),
                            ),
                            onPressed: isNext
                                ? () {
                                    setState(() {
                                      nextStopToMark++;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${route[index]} marked as passed'),
                                      ),
                                    );
                                  }
                                : null,
                            child: Text(
                              isPassed ? 'Passed' : 'Mark',
                              style: TextStyle(fontSize: 12),
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
        color: Color(0xFF2A2A3D),
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSharingLocation ? Icons.location_on : Icons.location_off,
                size: 50,
                color: isSharingLocation ? Colors.green : Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                isSharingLocation 
                  ? 'Sharing Live Location' 
                  : 'Location Sharing Off',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSharingLocation ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: () {
                  setState(() {
                    isSharingLocation = !isSharingLocation;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isSharingLocation 
                        ? 'Location sharing started' 
                        : 'Location sharing stopped'),
                    ),
                  );
                },
                child: Text(
                  isSharingLocation ? 'STOP SHARING' : 'START SHARING',
                  style: TextStyle(fontSize: 16),
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
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seat Availability ($availableSeats available)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 12),
          _buildSeatLayout(),
        ],
      ),
    );
  }

  Widget _buildBreakdownTab() {
    bool isBrokenDown = false;
    
    return Center(
      child: Card(
        color: Color(0xFF2A2A3D),
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(20),
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
                  SizedBox(height: 20),
                  Text(
                    isBrokenDown 
                      ? 'BUS BREAKDOWN REPORTED' 
                      : 'Bus is Operational',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBrokenDown ? Colors.green : Colors.orange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
                      style: TextStyle(fontSize: 16),
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
      backgroundColor: Color(0xFF1E1E2E),
      selectedItemColor: Color(0xFF7F56D9),
      unselectedItemColor: Colors.white70,
      items: [
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

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _performLogout();
              },
            ),
          ],
        );
      },
    );
  }

  void _performLogout() async {
    // Clear login status
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    
    // Navigate back to Enter Bus Code page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePageForDriver()),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged out successfully')),
    );
  }

  Widget _buildSeatLayout() {
    return Column(
      children: [
        Text(
          'Tap on seats to mark them as occupied',
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(height: 16),
        // Driver's seat at the top
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Driver',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(height: 20),
        // Seats layout
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left side seats (columns 1 and 2)
            Column(
              children: List.generate(10, (row) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      // Column 1 seat
                      _buildSeat(row),
                      SizedBox(width: 16),
                      // Column 2 seat
                      _buildSeat(row + 10),
                    ],
                  ),
                );
              }),
            ),
            // Gap between left and right sides (aisle)
            SizedBox(width: 40),
            // Right side seats (columns 3 and 4)
            Column(
              children: List.generate(10, (row) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      // Column 3 seat
                      _buildSeat(row + 20),
                      SizedBox(width: 16),
                      // Column 4 seat
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}