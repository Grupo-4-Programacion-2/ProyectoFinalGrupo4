import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pm2_pf_grupo_4/src/models/remembers.dart';
import 'package:pm2_pf_grupo_4/src/pages/management/lists/list_controller.dart';
import '../../../widgets/no_data_widgets.dart';

class RemembersListPage extends StatelessWidget {
  RemembersListController con = Get.put(RemembersListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
          length: con.status.length,
          child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: AppBar(
                  bottom: TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.amber,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey[600],
                    tabs: List<Widget>.generate(con.status.length, (index) {
                      return Tab(
                        child: Text(con.status[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15
                        ),),
                      );
                    }),
                  ),
                ),
              ),
              body: TabBarView(
                children: con.status.map((String status) {
                  return FutureBuilder(
                      future: con.getRemembers(),
                      builder:
                          (context, AsyncSnapshot<List<Remembers>> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.length > 0) {
                            return ListView.builder(
                                itemCount: snapshot.data?.length ?? 0,
                                itemBuilder: (_, index) {
                                  return _cardOrder(snapshot.data![index]);
                                });
                          } else {
                            return Center(
                                child: NoDataWidget(text: 'No hay Recordatorios'));
                          }
                        } else {
                          return Center(
                              child: NoDataWidget(text: 'No hay Recordatorios'));
                        }
                      });
                }).toList(),
              )),
        ));
  }

  Widget _cardOrder(Remembers remembers) {
    return GestureDetector(
      onTap: () => con.goToOrderDetail(remembers),
      child: Container(
        height: 150,
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Card(
          elevation: 3.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Container(
                height: 30,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    'NOTA ${remembers.id}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.amber),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text('Fecha: ${remembers.fechaCita ?? ""}')),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          'Hora: ${remembers.horaCita ?? 'No existe hora'}'),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          'Nota: ${remembers.notaTexto ?? 'No Hay Ninguna Nota'}'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
