
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(19.06022493146043, 72.89629290971014),
        initialZoom: 15,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
          subdomains: const ['a', 'b', 'c', 'd'],
          userAgentPackageName: 'com.example.foodoid',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(19.06022493146043, 72.89629290971014),
              width: 40,
              height: 40,
              child: Icon(Icons.my_location, color: Colors.blue),
            ),
          ],
        ),
      ],
    );
  }
}
