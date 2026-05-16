import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  static const LatLng _hqLocation = LatLng(-0.6052, 30.6525);
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (auth.isAdmin) {
      return const Scaffold(
        body: Center(child: Text('Location tracking is not available for admin accounts.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('HQ Office Location'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Electronic Hub Headquarters',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text('📍 Mbarara City, Uganda'),
                        const Text('📌 Near Mbarara Regional Referral Hospital'),
                        const Text('🕒 Open: Mon-Fri 8:00 AM - 6:00 PM'),
                        const Text('📞 +256 77 123 4567'),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _hqLocation,
                    initialZoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.electronichub.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _hqLocation,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1);
                  },
                  child: const Icon(Icons.zoom_in),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1);
                  },
                  child: const Icon(Icons.zoom_out),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}