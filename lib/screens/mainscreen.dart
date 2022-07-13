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
    if (percent > 0.5) {
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
    checkStateDragged();
    return SafeArea(
      child: Scaffold(
        key: scaffoldkey,
        drawer: SizedBox(
          width: 350,
          child: Drawer(
            elevation: 16.0,
            backgroundColor: Colors.white,
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  margin:const EdgeInsets.only(left:20),
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
                      backgroundColor:const Color.fromRGBO(255, 255, 255, 1),
                      child: Image.asset('assets/images/icons/CircleProfile.png',
                          width: 40, height: 40)),
                ),
                Expanded(
                  child: Container(
                    margin:const EdgeInsets.only(left:20),
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
                ),
              ],
            ),
          ),
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
                bottomPaddingOfMap = Platform.isAndroid ? 325 : 330;
                locatePosition();
              });
            },
          ),
          Positioned(
            right: 10,
            bottom: Platform.isAndroid ? 325 : 330,
            // alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
               setState(() {
               locatePosition();
                print('hello');    
                });
               
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
                minChildSize: 0.4,
                initialChildSize:0.4,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Material(
                    elevation: 10.0,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                    color: Colors.white,
                    
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
                              // const SizedBox(height: 15.0),
                             
                              !isDragged
                                  ? Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            print("hey");
                                              setState(() {
                                                percent = 0.9;
                                              });
                                            },
                                          child: TextField(
                                            enabled: false,
                                              decoration: InputDecoration(
                                                hintText: "Where to?",
                                                hintStyle:const TextStyle(
                                                  color:Colors.black,
                                                  fontWeight: FontWeight.bold
                                                ),
                                                filled: true,
                                                fillColor: Colors.grey[100],
                                                border: const OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0),
                                                  ),
                                                  // gapPadding: 2.0,
                                                ),
                                                prefixIcon:const Icon(
                                                  Icons.search,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              
                                            ),
                                        ),
                                      ),
                                      const SizedBox(width:10),
                                    ClipRRect(
                                    borderRadius:const BorderRadius.all(Radius.circular(20)) ,
                                      child: Image.asset("assets/bolt_food.png",width: 80,),
                                    )  
                                    ],
                                  )
                                  : Container(),
                              Expanded(
                                child: ListView.separated(
                                   separatorBuilder: (context, index) =>
                                const Divider(),
                                  controller: scrollController,
                                  // padding: const EdgeInsets.only(bottom: 40.0),
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children:const [
                                        const ListTile(
                                          contentPadding: EdgeInsets.only(left: 25,right:25),
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
                                            "Lagos",
                                            style: TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
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
