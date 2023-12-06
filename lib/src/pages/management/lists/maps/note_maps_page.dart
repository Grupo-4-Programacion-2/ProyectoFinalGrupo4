import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../models/remembers.dart';
import '../details/detail_remember_controller.dart';
import 'note_maps_controller.dart';

class noteMapPage extends StatelessWidget {

  noteMapController con = Get.put(noteMapController());

  late Remembers remembers = Remembers.fromJson(Get.arguments['remembers']);

  final RememberDetailController rememberDetailController = Get.put(RememberDetailController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UBICACION EN MAPA',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Scaffold(
        body: _googleMaps(),
        floatingActionButton: Container(
          margin: EdgeInsets.only(right: 110, bottom: 670),
          child: FloatingActionButton.extended(
            onPressed: con.goToTheLake,
            label: Text('Posicion'),
            icon: Icon(Icons.directions_boat),
          ),
        ),
      ),
    );
  }


  Widget _googleMaps() {
    return GoogleMap(
      initialCameraPosition: con.initialPosition,
      markers: {Marker(markerId: MarkerId(con.remembers.userId.toString()), position: LatLng(con.remembers.latitud??14.6611132, con.remembers.longitud??-86.18527),infoWindow: InfoWindow(title: 'Ubicacion'))},
      mapType: MapType.satellite,
      onMapCreated: con.onMapCreate,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
    );
  }

  //MarkerId(con.remembers.userId.toString()), position: LatLng(con.remembers.latitud??15.0554, con.remembers.longitud??-86.555),infoWindow: InfoWindow(title: con.remembers.id))},

}

