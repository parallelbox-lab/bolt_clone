import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

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
      drawer: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              accountName: Text('Owoeye Precious',
                  style: TextStyle(
                      fontFamily: 'Core Pro',
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
              accountEmail: Text('Edit Profile',
                  style: TextStyle(
                      fontFamily: 'Core Pro',
                      fontSize: 11.0.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black)),
              currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset('assets/images/icons/CircleProfile.png',
                      width: 40, height: 40)),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  const ListTile(
                    title:  Text('Payment'),
                  ),
                  const  ListTile(
                    title:  Text('Ride History'),
                  ),
                  
                const ListTile(
                    title:  Text('Work trips'),
                  ),
                  const  ListTile(
                    title:  Text('Support'),
                  ),
                  const  ListTile(
                    title:  Text('About'),
                  ),
                  
                  // ListTile(
                  //     title: const Text('My Sponsorships', style: NavBar._textStyle),
                  //     horizontalTitleGap: 2.0,
                  //     leading: Image.asset(
                  //         'assets/images/icons/bx_bxs-donate-heart.png',
                  //         color: Colors.grey,
                  //         width: 25,
                  //         height: 25),
                  //     onTap: () {
                  //       Navigator.pushNamed(context, MySponsorShip.routeName);
                  //     }),
                 
                  // ListTile(
                  //     title: const Text('Notifications', style: _textStyle),
                  //     horizontalTitleGap: 2.0,
                  //     leading: Image.asset(
                  //         'assets/images/icons/notification.png',
                  //         width: 25,
                  //         height: 25),
                  //     onTap: () {
                  //       Navigator.pushNamed(context, Notifications.routeName);
                  //     }),
                 
                 
                  const Divider(height: 50),
                  
                 
                ],
              ),
            ),
          ],
        ),
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