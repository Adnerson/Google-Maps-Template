import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  // Gets user location permission granted
  final Location _locationController = Location();
  LatLng? _currentPosition;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Here we go again'),
      ),
      body: _currentPosition == null
          ? const Center(child: Text('loading'))
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 15,
              ),
              //this controller can be used for many useful things,
              //for this it updates the camera position to user location.
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              markers: {
                currentPosMarker(),
              },
            ),
    );
  }

  Marker currentPosMarker() {
    return Marker(
      markerId: const MarkerId('_currentLocation'),
      icon: BitmapDescriptor.defaultMarker,
      position: _currentPosition!,
    );
  }

  Future<void> cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 15,
    );
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<void> getLocationUpdates() async {
    PermissionStatus permissionGranted;

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
    }

    _locationController.onLocationChanged.listen(
      (LocationData currentLocation) {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          setState(
            () {
              _currentPosition =
                  LatLng(currentLocation.latitude!, currentLocation.longitude!);
              cameraToPosition(_currentPosition!);
            },
          );
        }
      },
    );
  }
}
