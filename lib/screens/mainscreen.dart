import 'dart:io';
import 'dart:async';
import 'package:bolt_clone/screens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Position? currentPosition;
  double bottomPaddingOfMap = 0;
  bool drawerCanOpen = true;
  double percent = 0.0;
  bool isDragged = false;
  double initialHeight = 0.0;
  StreamSubscription<Position>? _positionStream;
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );

  var geoLocator = Geolocator();
  LocationPermission? permission;
  GoogleMapController? _googleMapController;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

//  get user location
  void locatePosition() async {
    // Test if location services are enabled.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
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

  checkStateDragged() {
    if (percent > 0.4) {
      setState(() {
        isDragged = true;
      });
    } else {
      setState(() {
        isDragged = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
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
    return SafeArea(
      child: Scaffold(
        key: scaffoldkey,
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
                    title: Text('Payment'),
                  ),
                  const ListTile(
                    title: Text('Ride History'),
                  ),

                  const ListTile(
                    title: Text('Work trips'),
                  ),
                  const ListTile(
                    title: Text('Support'),
                  ),
                  const ListTile(
                    title: Text('About'),
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
        body: Stack(children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) {
              _googleMapController = controller;
              setState(() {
                bottomPaddingOfMap = Platform.isAndroid ? 405 : 420;
                locatePosition();
              });
            },
          ),
          Positioned(
            right: 10,
            bottom: Platform.isAndroid ? 405 : 420,
            // alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                print('hello');
                locatePosition();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          spreadRadius: 0.5,
                          offset: Offset(.7, 0.7))
                    ]),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 17,
                  child:
                      Icon(Icons.my_location, size: 25, color: Colors.black87),
                ),
              ),
            ),
          ),
          Positioned(
              top: 35,
              left: 18,
              child: GestureDetector(
                onTap: () {
                  if (drawerCanOpen) {
                    scaffoldkey.currentState!.openDrawer();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            spreadRadius: 0.5,
                            offset: Offset(.7, 0.7))
                      ]),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(Icons.menu, size: 28, color: Colors.black87),
                  ),
                ),
              )),
          /* draggable scrollable sheet*/
          Positioned.fill(
            child: NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                setState(() {
                  percent = 2 * notification.extent - 0.8;
                });
                return true;
              },
              child: DraggableScrollableSheet(
                maxChildSize: 0.9,
                minChildSize: 0.5,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Material(
                    elevation: 10.0,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                    color: Colors.white,
                    
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                        ),
                        child: Column(
                            // shrinkWrap: true,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15.0),
                              Container(
                                height: 7.0,
                                margin: const EdgeInsets.symmetric(horizontal: 150.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: const Text(
                                  "Akwaaba !",
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                  vertical: 5.0,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: const Text(
                                  "Where are you going?",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              !isDragged
                                  ? Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                            decoration: InputDecoration(
                                              enabled: false,
                                              hintText: "Search Destination",
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0),
                                                ),
                                                // gapPadding: 2.0,
                                              ),
                                              prefixIcon: Icon(
                                                Icons.search,
                                                color: Colors.purple[300],
                                              ),
                                            ),
                                            onTap: () {
                                            print("hey");
                                              setState(() {
                                                percent = 1.0;
                                              });
                                            },
                                          ),
                                      ),
                                      const SizedBox(width:10),
                                    Container(
                                    decoration: BoxDecoration(
                                    borderRadius:const BorderRadius.all(Radius.circular(20)) ,
                                     color:Colors.grey,
                                     border: Border.all(color: Colors.grey,width:2)
                                      ),
                                      child: Image.asset("assets/bolt_food.png",width: 80,),
                                    )  
                                    ],
                                  )
                                  : Container(),
                              Expanded(
                                child: ListView.builder(
                                  controller: scrollController,
                                  padding: const EdgeInsets.only(bottom: 40.0),
                                  itemCount: 20,
                                  itemBuilder: (context, index) {
                                    return const ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Icon(
                                        Icons.location_on,
                                        color: Colors.black,
                                      ),
                                      title: Text(
                                        "Street No 12345 NY Street",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "New York City",
                                        style: TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                    ),
                    
                  );
                },
              ),
            ),
          ),
          /* search destination */
          Positioned(
            left: 0.0,
            right: 0.0,
            top: -180 * (1 - percent),
            child: Opacity(
              opacity: percent,
              child: const SearchDestination(),
            ),
          ),

          /* select destination on map */
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: -50 * (1 - percent),
            child: Opacity(
              opacity: percent,
              // child: const PickOnMap(),
            ),
          ),
        ]),
      ),
    );
  }
}
