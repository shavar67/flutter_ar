import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'pin_model.dart';

const double CAMERA_ZOOM = 14;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 0;
const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const double DEFAULT_DISTANCE = 28.08;
const List<String> MODELS = ["toucan", "andy", "foxy"];
const int MAXIMUM_MARKERS = 15;

const LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = <Marker>{};
  String googleAPIKey = '<API_KEY>';
// for my custom marker pins
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  late bool enableAR = false;
  LocationData? currentLocation;
  Location? location;
  int markerID = 0;
  double pinPillPosition = -100;
  double distance_accuracy = DEFAULT_DISTANCE;
  final TextEditingController _distanceAccuractyController =
      TextEditingController(text: DEFAULT_DISTANCE.toString());
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();

  @override
  void initState() {
    // create an instance of Location
    location = Location();
    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location?.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      verifyDistance();
      super.initState();
    });
    // set the initial location
    setInitialLocation();
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.0),
            'assets/destination_map_marker.png')
        .then((onValue) {
      destinationIcon = onValue;
    });
  }

  bool verifyDistance() {
    setState(() {
      if (_markers.isNotEmpty) {
        for (int i = 0; i < _markers.length; i++) {
          double distance = calculateDistance(
              _markers.elementAt(i).position.latitude,
              _markers.elementAt(i).position.longitude,
              currentLocation?.latitude ?? 0,
              currentLocation?.longitude ?? 0);
          print("DISTANCE IS " + distance.toString());
          if (distance < distance_accuracy) {
            // highlightMarker(mMarkers.get(i));
            enableAR = true;
          } else {
            // normalizeMarker(mMarkers.get(i));
            enableAR = false;
          }
        }
      }
    });
    return enableAR;
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location?.getLocation();

    addMarker(
        currentLocation?.latitude ?? 0, currentLocation?.longitude ?? 0, 0);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742000 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = const CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: SOURCE_LOCATION,
    );
    initialCameraPosition = CameraPosition(
        target: LatLng(
            currentLocation?.latitude ?? 0, currentLocation?.longitude ?? 0),
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING);
    return Container();
  }

  void addMarker(double lat, double long, int id) {
    late PinInformation currentlySelectedPin;
    if (long == null) {
      return;
    }
    showNewMarker(lat, long);
    setState(() {
      // updated position
      var pinPosition = LatLng(lat, long);

      PinInformation destinationPinInfo;

      destinationPinInfo = PinInformation(
          locationName: "End Location",
          location: pinPosition,
          pinPath: "assets/destination_map_marker.png",
          avatarPath: "assets/friend2.jpg",
          labelColor: Colors.purple);

      _markers
          .removeWhere((m) => m.markerId.value == 'destPin' + id.toString());
      _markers.add(Marker(
        draggable: true,
        markerId: MarkerId('destPin' + markerID.toString()),
        onTap: () {
          setState(() {
            currentlySelectedPin = destinationPinInfo;
            pinPillPosition = 0;
          });
        },
        onDragEnd: ((newPosition) {
          addMarker(newPosition.latitude, newPosition.longitude, id);
          verifyDistance();
        }),
        position: pinPosition, // updated position
        icon: destinationIcon,
      ));
    });
  }

  void showNewMarker(double lat, double long) async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(lat, long),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(cPosition),
    );
  }
}
