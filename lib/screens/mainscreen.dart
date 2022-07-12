import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({ Key? key }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
Position? currentPosition;
 double bottomPaddingOfMap = 0;
StreamSubscription<Position>? _positionStream;
 GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );

  var geoLocator = Geolocator();

  GoogleMapController? _googleMapController;
 final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
//  get user location
  void locatePosition() async {
    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) async {
      if ((await Geolocator.isLocationServiceEnabled())) {
        Position? position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
                    //Get latitude and longtitude
        LatLng latLatPosition = LatLng(position.latitude, position.longitude);
        CameraPosition cameraPosition =
            CameraPosition(target: latLatPosition, zoom: 14);
        _googleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      }
    });
  }
   @override
  void dispose() {
    //
    super.dispose();
    _googleMapController!.dispose();
    _positionStream!.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          GoogleMap(
          padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
          myLocationEnabled: true,
          zoomGesturesEnabled: false,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: (controller) {
            _googleMapController = controller;
            setState(() {
              bottomPaddingOfMap = Platform.isAndroid ? 240 : 270;
              locatePosition();
            });
          },
        ),
        ]
      ),
    );
  }
}