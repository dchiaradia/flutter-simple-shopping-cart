//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/dashboardController.dart';

class DashboardPage extends GetWidget {
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: controller.myHeader(true),
          body: controller.myBody(),
          bottomNavigationBar: controller.myBottomBar(0),
        ));
  }
}
