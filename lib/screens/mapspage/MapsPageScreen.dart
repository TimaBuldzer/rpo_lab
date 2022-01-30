import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rpo/constants.dart';
import 'package:rpo/screens/models/EntityModel.dart';
import 'package:weather/weather.dart';

class MapsPageScreen extends StatefulWidget {
  const MapsPageScreen({Key? key}) : super(key: key);

  @override
  State<MapsPageScreen> createState() => _MapsPageScreenState();
}

class _MapsPageScreenState extends State<MapsPageScreen> {
  Completer<GoogleMapController> _controller = Completer();
  int lastMarkerId = 0;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Future<String> getWeather(double latitude, double longitude) async {
    WeatherFactory wf = WeatherFactory("b5ded265ab5970848756b7eb7be72271",
        language: Language.RUSSIAN);
    Weather w = await wf.currentWeatherByLocation(latitude, longitude);
    return w.temperature!.celsius!.ceil().toString();
  }

  Future<List> _addMarkers() async {
    QuerySnapshot _coords =
        await FirebaseFirestore.instance.collection('coords').get();

    List result = [];
    for (var doc in _coords.docs) {
      Entity entity = Entity(
        doc['name'],
        doc['img'],
        doc['coordinates'].latitude,
        doc['coordinates'].longitude,
        '',
      );
      entity.value = await getWeather(entity.latitude, entity.longitude);
      _add(entity);
    }
    return result;
  }

  @override
  initState() {
    super.initState();
    _addMarkers();
  }

  String getMarkerId() {
    int markerIdVal = lastMarkerId;
    lastMarkerId += 1;
    return markerIdVal.toString();
  }

  void _add(Entity entity) {
    var markerIdVal = getMarkerId();
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        entity.latitude,
        entity.longitude,
      ),
      infoWindow: InfoWindow(
          title: entity.name,
          snippet: 'Погода на данный момент: ${entity.value} °C'),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(kDefaultCameraPosition['latitude'] ?? 0.0,
        kDefaultCameraPosition['longitude'] ?? 0.0),
    zoom: kDefaultCameraPosition['zoom'] ?? 18.0,
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: Set<Marker>.of(markers.values),
      mapType: MapType.hybrid,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
