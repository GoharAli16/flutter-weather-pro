import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({super.key});

  @override
  ConsumerState<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  final Map<String, dynamic> _currentWeather = {
    'location': 'New York, NY',
    'temperature': 72,
    'condition': 'Partly Cloudy',
    'humidity': 65,
    'windSpeed': 12,
    'pressure': 1013,
    'uvIndex': 6,
    'visibility': 10,
    'feelsLike': 75,
  };

  final List<Map<String, dynamic>> _hourlyForecast = [
    {'time': 'Now', 'temperature': 72, 'condition': 'partly_cloudy', 'precipitation': 0},
    {'time': '1PM', 'temperature': 74, 'condition': 'sunny', 'precipitation': 0},
    {'time': '2PM', 'temperature': 76, 'condition': 'sunny', 'precipitation': 0},
    {'time': '3PM', 'temperature': 78, 'condition': 'partly_cloudy', 'precipitation': 0},
    {'time': '4PM', 'temperature': 77, 'condition': 'cloudy', 'precipitation': 20},
    {'time': '5PM', 'temperature': 75, 'condition': 'rainy', 'precipitation': 80},
    {'time': '6PM', 'temperature': 73, 'condition': 'rainy', 'precipitation': 90},
    {'time': '7PM', 'temperature': 71, 'condition': 'cloudy', 'precipitation': 30},
  ];

  final List<Map<String, dynamic>> _dailyForecast = [
    {'day': 'Today', 'high': 78, 'low': 65, 'condition': 'partly_cloudy', 'precipitation': 20},
    {'day': 'Tomorrow', 'high': 82, 'low': 68, 'condition': 'sunny', 'precipitation': 0},
    {'day': 'Wednesday', 'high': 85, 'low': 70, 'condition': 'sunny', 'precipitation': 0},
    {'day': 'Thursday', 'high': 80, 'low': 67, 'condition': 'cloudy', 'precipitation': 40},
    {'day': 'Friday', 'high': 77, 'low': 64, 'condition': 'rainy', 'precipitation': 70},
    {'day': 'Saturday', 'high': 75, 'low': 62, 'condition': 'partly_cloudy', 'precipitation': 30},
    {'day': 'Sunday', 'high': 79, 'low': 66, 'condition': 'sunny', 'precipitation': 0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB),
              Color(0xFF98D8E8),
              Color(0xFFB0E0E6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Current Weather
              _buildCurrentWeather(),
              
              // Hourly Forecast
              _buildHourlyForecast(),
              
              // Daily Forecast
              Expanded(
                child: _buildDailyForecast(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: _openMenu,
          ),
          Text(
            _currentWeather['location'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: _openSearch,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Weather Icon
          Icon(
            _getWeatherIcon(_currentWeather['condition']),
            size: 120,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          
          // Temperature
          Text(
            '${_currentWeather['temperature']}°',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 72,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8),
          
          // Condition
          Text(
            _currentWeather['condition'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          
          // Feels Like
          Text(
            'Feels like ${_currentWeather['feelsLike']}°',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          
          // Weather Details
          _buildWeatherDetails(),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildDetailItem(
          icon: Icons.water_drop,
          label: 'Humidity',
          value: '${_currentWeather['humidity']}%',
        ),
        _buildDetailItem(
          icon: Icons.air,
          label: 'Wind',
          value: '${_currentWeather['windSpeed']} mph',
        ),
        _buildDetailItem(
          icon: Icons.compress,
          label: 'Pressure',
          value: '${_currentWeather['pressure']} hPa',
        ),
        _buildDetailItem(
          icon: Icons.wb_sunny,
          label: 'UV Index',
          value: '${_currentWeather['uvIndex']}',
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyForecast() {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _hourlyForecast.length,
        itemBuilder: (context, index) {
          final hour = _hourlyForecast[index];
          return _buildHourlyItem(hour);
        },
      ),
    );
  }

  Widget _buildHourlyItem(Map<String, dynamic> hour) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            hour['time'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(
            _getWeatherIcon(hour['condition']),
            color: Colors.white,
            size: 24,
          ),
          Text(
            '${hour['temperature']}°',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (hour['precipitation'] > 0)
            Text(
              '${hour['precipitation']}%',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDailyForecast() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '7-Day Forecast',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _dailyForecast.length,
              itemBuilder: (context, index) {
                final day = _dailyForecast[index];
                return _buildDailyItem(day);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyItem(Map<String, dynamic> day) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Day
          SizedBox(
            width: 80,
            child: Text(
              day['day'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Weather Icon
          Icon(
            _getWeatherIcon(day['condition']),
            color: Colors.grey[600],
            size: 24,
          ),
          
          const SizedBox(width: 16),
          
          // Precipitation
          if (day['precipitation'] > 0)
            Container(
              width: 40,
              child: Text(
                '${day['precipitation']}%',
                style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 12,
                ),
              ),
            ),
          
          const Spacer(),
          
          // Temperature Range
          Text(
            '${day['low']}°',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${day['high']}°',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'partly_cloudy':
        return Icons.wb_cloudy;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.grain;
      case 'stormy':
        return Icons.thunderstorm;
      case 'snowy':
        return Icons.ac_unit;
      default:
        return Icons.wb_sunny;
    }
  }

  void _openMenu() {
    // Implement menu functionality
  }

  void _openSearch() {
    // Implement search functionality
  }
}
