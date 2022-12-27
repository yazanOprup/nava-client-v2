import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/CustomButton.dart';
import 'package:nava/helpers/customs/Loading.dart';

import '../../../helpers/customs/CustomBackButton.dart';
import 'package:permission_handler/permission_handler.dart' as p;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  BitmapDescriptor myIcon;
  GoogleMapController myController;
  double currentLat;
  double currentLng;
  String userLocation;
  Set<Marker> mark = Set();
  bool onChoose = false;

  getInitialAddress() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLat = position.latitude;
      currentLng = position.longitude;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      myController = controller;
    });
  }

  void initState() {
    getInitialAddress();
    super.initState();
    p.Permission.location.request()
        .then((p.PermissionStatus status) {
      if (status == p.PermissionStatus.granted) {
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^location granted");
        Geolocator.getCurrentPosition().then((Position myLocation) {
          setState(() async {
            await placemarkFromCoordinates(
                    myLocation.latitude, myLocation.longitude)
                .then((address) {
              setState(() {
                userLocation = address[0].administrativeArea +
                    " - " +
                    address[0].subAdministrativeArea +
                    " - " +
                    address[0].name;
                print("============= $userLocation");
              });
            });
            currentLat = myLocation.latitude;
            currentLng = myLocation.longitude;
            // InfoWindow infoWindow = InfoWindow(title: "Location");
            // marker = Marker(
            //   draggable: true,
            //   markerId: MarkerId('markers.length.toString()'),
            //   infoWindow: infoWindow,
            //   position: LatLng(myLocation.latitude, myLocation.longitude),
            //   icon: myIcon,
            // );
            // setState(() {
            //   mark.add(marker);
            // });
          });
        });
      } else if (status == p.PermissionStatus.denied) {
        p.Permission.location.request();
        Navigator.pop(context);
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^ location denied");
        Fluttertoast.showToast(msg: "Must Allow Location To Add Address");
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Must Allow Location To Add Address");
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^location else");
      }
    });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        size: Size(20, 20),
        devicePixelRatio: 0,
      ),
      'assets/images/marker.png',
    ).then((onValue) {
      myIcon = onValue;
    });
  }

  Position updatedPosition;

  // Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(tr("selectLocation"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
        leading: CustomBackButton(ctx: context),
      ),
      
      body: currentLat == null && currentLng == null
          ? Center(
              child: MyLoading(),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(currentLat, currentLng), zoom: 12.0),
                    onTap: (newLang) {
                      // currentLat = newLang.latitude;
                      // currentLng = newLang.longitude;
                      _updatePosition(CameraPosition(
                          target: LatLng(newLang.latitude, newLang.longitude)));
                    },
                    onMapCreated: _onMapCreated,
                    markers: {
                      Marker(
                          markerId: MarkerId('m1'),
                          position: LatLng(currentLat, currentLng)),
                    },
                    // onCameraMove: ((_position) =>
                    //     _updatePosition(_position)),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.142,
                    padding: EdgeInsets.all(12),
                    color: Colors.blue.withOpacity(0.3),
                    child: Column(
                      children: [
                        Text(
                          "pleasepressonplacetodeliverylocation".tr(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 35,
                          width: MediaQuery.of(context).size.width * 0.95,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: MyColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(width: 1, color: MyColors.primary),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(
                                  Icons.my_location,
                                  size: 15,
                                  color: MyColors.primary,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  userLocation ?? tr("address"),
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: MediaQuery.of(context).size.height * 0.1,
                      padding: const EdgeInsets.all(12.0),
                      child: _confirmButton(context),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _updatePosition(CameraPosition _position) {
    Position newMarkerPosition = Position(
        latitude: _position.target.latitude,
        longitude: _position.target.longitude);
    setState(() async {
      updatedPosition = newMarkerPosition;
      currentLat = newMarkerPosition.latitude;
      currentLng = newMarkerPosition.longitude;
      // marker = marker.copyWith(
      //     positionParam:
      //         LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude));
      await placemarkFromCoordinates(
              updatedPosition.latitude, updatedPosition.longitude)
          .then((address) {
        setState(() {
          userLocation = address[0].administrativeArea +
              " - " +
              address[0].subAdministrativeArea +
              " - " +
              address[0].name;
          print(userLocation);
        });
      });
    });
  }

  Widget _confirmButton(BuildContext context) {
    return CustomButton(
      //color: MyColors.white,
      
      title: tr("chooseCurrentLocation"),
      //borderColor: MyColors.primary,
      //textColor: MyColors.primary,
      width: MediaQuery.of(context).size.width,
      onTap: () {
        Navigator.pop(context, [userLocation, currentLat, currentLng]);
      },
    );
  }
}
