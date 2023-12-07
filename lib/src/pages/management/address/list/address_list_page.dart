import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/address/list/address_list_controller.dart';
import '../../../../models/address.dart';
import '../../../../widgets/no_data_widgets.dart';

class ClientAddressListPage extends StatelessWidget {

  ClientAddressListController controller = Get.put(ClientAddressListController());

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: _buttonNext(context),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(
          'Mis Direcciones',
          style: TextStyle(
              color: Colors.white
          ),
        ),
        actions: [
          _iconAddressCreate()
        ],
      ),
      body: GetBuilder<ClientAddressListController> ( builder: (value) => Stack(
        children: [
          _textSelectAddress(),
          _listAddress(context)
        ],
      )),
    );
  }

  Widget _buttonNext(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: ElevatedButton(
          onPressed: () => {},//controller.createOrder(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'CONTINUAR',
            style: TextStyle(
                color: Colors.white
            ),
          )
      ),
    );
  }

  Widget _listAddress(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: FutureBuilder(
          future: controller.getAddress(),
          builder: (context, AsyncSnapshot<List<Address>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    itemBuilder: (_, index) {
                      return _radioSelectorAddress(snapshot.data![index], index);
                    }
                );
              }
              else {
                return Center(
                  child: NoDataWidget(text: 'No hay direcciones'),
                );
              }
            }
            else {
              return Center(
                child: NoDataWidget(text: 'No hay direcciones'),
              );
            }
          }
      ),
    );
  }

  Widget _radioSelectorAddress(Address address, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                value: index,
                groupValue: controller.radioValue.value,
                onChanged: controller.handleRadioValueChange,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.address ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    address.neighborhood ?? '',
                    style: TextStyle(
                        fontSize: 12
                    ),
                  )
                ],
              )
            ],
          ),
          Divider(color: Colors.grey[400])
        ],
      ),
    );
  }

  Widget _textSelectAddress() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30),
      child: Text(
        'Elije una direccion',
        style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _iconAddressCreate() {
    return IconButton(
        onPressed: () => controller.goToAddressCreate(),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        )
    );
  }
}
