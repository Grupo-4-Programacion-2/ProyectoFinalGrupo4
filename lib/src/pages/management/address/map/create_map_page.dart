import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/address/map/create_map_controller.dart';

class ClientAddressMapPage extends StatelessWidget {

  ClientAddressMapController controller = Get.put(ClientAddressMapController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text(
          'Location',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: Stack(
        children: [
          _googleMaps(),
          _iconMyLocation(),
          _cardAddress(),
          _buttonAccept(context)
        ],
      ),
    ));
  }

  Widget _buttonAccept(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 30),
      child: ElevatedButton(
        onPressed: () => controller.selectRefPoint(context),
        child: Text(
          'SELECCIONAR UBICACION',
          style: TextStyle(
              color: Colors.white
          ),
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            padding: EdgeInsets.all(15)
        ),

      ),
    );
  }

  Widget _cardAddress() {
    return Container(
      width: double.infinity,
      alignment: Alignment.topCenter,
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            controller.addressName.value,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconMyLocation() {
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: Center(
        child: Image.asset(
          'assets/img/my_location_yellow.png',
          width: 65,
          height: 65,
        ),
      ),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      initialCameraPosition: controller.initialPosition,
      mapType: MapType.hybrid,
      onMapCreated: controller.onMapCreate,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      onCameraMove: (position) {
        controller.initialPosition = position;
      },
      onCameraIdle: () async {
        await controller.setLocationDraggableInfo(); // EMPEZAR A OBTNER LA LAT Y LNG DE LA POSICION CENTRAL DEL MAPA
      },
    );
  }
}
