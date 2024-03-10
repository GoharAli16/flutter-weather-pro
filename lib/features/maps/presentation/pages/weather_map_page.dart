import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeatherMapPage extends ConsumerStatefulWidget {
  const WeatherMapPage({super.key});

  @override
  ConsumerState<WeatherMapPage> createState() => _WeatherMapPageState();
}

class _WeatherMapPageState extends ConsumerState<WeatherMapPage> {
  String _selectedLayer = 'temperature';
  bool _showRadar = false;
  bool _showSatellite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: _showLayerOptions,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map Container
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.blue[100],
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 100,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Interactive Weather Map',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Temperature, precipitation, and radar data',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Layer Controls
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                _buildLayerButton(
                  icon: Icons.thermostat,
                  label: 'Temperature',
                  isSelected: _selectedLayer == 'temperature',
                  onTap: () => _selectLayer('temperature'),
                ),
                const SizedBox(height: 8),
                _buildLayerButton(
                  icon: Icons.water_drop,
                  label: 'Precipitation',
                  isSelected: _selectedLayer == 'precipitation',
                  onTap: () => _selectLayer('precipitation'),
                ),
                const SizedBox(height: 8),
                _buildLayerButton(
                  icon: Icons.air,
                  label: 'Wind',
                  isSelected: _selectedLayer == 'wind',
                  onTap: () => _selectLayer('wind'),
                ),
                const SizedBox(height: 8),
                _buildLayerButton(
                  icon: Icons.radar,
                  label: 'Radar',
                  isSelected: _showRadar,
                  onTap: _toggleRadar,
                ),
                const SizedBox(height: 8),
                _buildLayerButton(
                  icon: Icons.satellite,
                  label: 'Satellite',
                  isSelected: _showSatellite,
                  onTap: _toggleSatellite,
                ),
              ],
            ),
          ),
          
          // Map Legend
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildMapLegend(),
          ),
        ],
      ),
    );
  }

  Widget _buildLayerButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.blue,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legend',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildLegendItem(
            color: Colors.red,
            label: 'Hot (90°F+)',
          ),
          _buildLegendItem(
            color: Colors.orange,
            label: 'Warm (70-89°F)',
          ),
          _buildLegendItem(
            color: Colors.yellow,
            label: 'Mild (50-69°F)',
          ),
          _buildLegendItem(
            color: Colors.blue,
            label: 'Cool (32-49°F)',
          ),
          _buildLegendItem(
            color: Colors.purple,
            label: 'Cold (<32°F)',
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _selectLayer(String layer) {
    setState(() {
      _selectedLayer = layer;
    });
  }

  void _toggleRadar() {
    setState(() {
      _showRadar = !_showRadar;
    });
  }

  void _toggleSatellite() {
    setState(() {
      _showSatellite = !_showSatellite;
    });
  }

  void _showLayerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Map Layers',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.thermostat),
              title: const Text('Temperature'),
              trailing: Radio(
                value: 'temperature',
                groupValue: _selectedLayer,
                onChanged: (value) {
                  setState(() {
                    _selectedLayer = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.water_drop),
              title: const Text('Precipitation'),
              trailing: Radio(
                value: 'precipitation',
                groupValue: _selectedLayer,
                onChanged: (value) {
                  setState(() {
                    _selectedLayer = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.air),
              title: const Text('Wind'),
              trailing: Radio(
                value: 'wind',
                groupValue: _selectedLayer,
                onChanged: (value) {
                  setState(() {
                    _selectedLayer = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Map Settings'),
        content: const Text('Map settings and preferences'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
