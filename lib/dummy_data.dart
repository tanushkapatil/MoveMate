// Dummy bus route data
final List<Map<String, dynamic>> busRoutes = [
  {
    'busCode': 'PMPML001',
    'route': ['Stop 1', 'Stop 2', 'Stop 3', 'Stop 4'],
    'seatsAvailable': 15,
    'breakdownStatus': false,
    'eta': '12 mins'
  },
  {
    'busCode': 'PMPML002',
    'route': ['Stop A', 'Stop B', 'Stop C', 'Stop D'],
    'seatsAvailable': 0,
    'breakdownStatus': true,
    'eta': 'Delayed'
  },
  {
    'busCode': 'BUS123',
    'route': ['Main Square', 'Park Lane', 'Mall Road', 'Tech Street'],
    'seatsAvailable': 5,
    'breakdownStatus': false,
    'eta': '5 mins'
  },
  {
    'busCode': 'PMP456',
    'route': ['Metro Station', 'Library', 'City Hall', 'Stadium'],
    'seatsAvailable': 20,
    'breakdownStatus': false,
    'eta': 'On Time'
  },
];

// Dummy driver login details
final Map<String, String> driverLogins = {
  'driver1': 'password1',
  'driver2': 'password2',
  'driver3': 'password3',
};
