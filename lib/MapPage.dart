import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MaterialApp(
    home: MapPage(),
  ));
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String selectedRegion = 'All';
  String selectedLocationType = 'All';

  final List<String> regions = [
    'All',
    'Western Province',
    'Central Province',
    'Southern Province',
    'Eastern Province',
    'Northern Province',
    'North Central Province',
    'North Western Province',
    'Uva Province',
    'Sabaragamuwa Province',
  ];

  final List<String> locationTypes = [
    'All',
    'Hotels',
    'Restaurants',
    'Hospitals',
    'Gem Locations',
  ];

  Set<Marker> markers = {};
  CameraPosition initialCameraPosition =
      const CameraPosition(target: LatLng(7.8731, 80.7718), zoom: 7);

  Map<String, Map<String, List<Marker>>> markersByRegionAndType = {};

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    // Initialize your markers here. For demonstration, only a few markers will be added.
    markersByRegionAndType = {
      'Western Province': {
        'Hotels': [
          Marker(
            markerId: MarkerId('WP-Hotel-Shangri-La'),
            position: LatLng(6.9344, 79.8428),
            infoWindow: InfoWindow(title: 'Shangri-La Hotel', snippet: 'Colombo, Western Province'),
          ),
        ],
        'Restaurants': [
          Marker(
            markerId: MarkerId('WP-Restaurant-MinistryOfCrab'),
            position: LatLng(6.9339, 79.8433),
            infoWindow: InfoWindow(title: 'Ministry of Crab', snippet: 'Colombo, Western Province'),
          ),
        ],
      },
      'Central Province': {
        'Hotels': [
          Marker(
            markerId: MarkerId('CP-Hotel-CinnamonCitadel'),
            position: LatLng(7.2936, 80.6350),
            infoWindow: InfoWindow(title: 'Cinnamon Citadel', snippet: 'Kandy, Central Province'),
          ),
        ],
        'Restaurants': [
          Marker(
            markerId: MarkerId('CP-Restaurant-TheEmpireCafe'),
            position: LatLng(7.2931, 80.6409),
            infoWindow: InfoWindow(title: 'The Empire Cafe', snippet: 'Kandy, Central Province'),
          ),
        ],
      },
      // Add markers for other provinces...
    };

    _createMarkers(); // Initially create markers for 'All'
  }

  void _createMarkers() {
    markers.clear(); // Clear existing markers

    if (selectedRegion == 'All' && selectedLocationType == 'All') {
      // Add all markers
      markersByRegionAndType.forEach((region, typeMarkers) {
        typeMarkers.forEach((type, markersList) {
          markers.addAll(markersList);
        });
      });
    } else if (selectedRegion != 'All' && selectedLocationType == 'All') {
      // Add all markers for a specific region
      markersByRegionAndType[selectedRegion]?.forEach((type, markersList) {
        markers.addAll(markersList);
      });
    } else if (selectedRegion == 'All' && selectedLocationType != 'All') {
      // Add all markers for a specific type across all regions
      markersByRegionAndType.forEach((region, typeMarkers) {
        typeMarkers[selectedLocationType]?.forEach((marker) {
          markers.add(marker);
        });
      });
    } else {
      // Add markers for a specific region and type
      markers.addAll(markersByRegionAndType[selectedRegion]?[selectedLocationType] ?? []);
    }

    setState(() {}); // Update the UI to reflect changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sri Lanka Map'),
        actions: [
          DropdownButton<String>(
            value: selectedRegion,
            items: regions.map((region) => DropdownMenuItem<String>(
                  value: region,
                  child: Text(region),
                )).toList(),
            onChanged: (value) {
              setState(() {
                selectedRegion = value!;
                _createMarkers();
              });
            },
          ),
          DropdownButton<String>(
            value: selectedLocationType,
            items: locationTypes.map((type) => DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                )).toList(),
            onChanged: (value) {
              setState(() {
                selectedLocationType = value!;
                _createMarkers();
              });
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
      ),
    );
  }
}
