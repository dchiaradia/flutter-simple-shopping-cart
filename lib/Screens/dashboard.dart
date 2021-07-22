//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/dashboardController.dart';

class DashboardPage extends GetWidget {
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return controller.myHeader(innerBoxIsScrolled);
        },
        body: controller.myBody(),
      ),
      //floatingActionButton: cartButtonView(),
      bottomNavigationBar: controller.bottomBar(0),
    );
  }
}
