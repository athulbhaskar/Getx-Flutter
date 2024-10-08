import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:initialsetup/screens/welcome/welcome_controller.dart';

import '../Api/connectivity_service.dart';
import '../base_page/base-page_ui.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePage(
      body: Obx(
        () => RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: ListView.builder(
              itemCount: controller.flagList1.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child:
                        Image.network(
                          controller.flagList1.value[index]!.flagPng.toString(),
                          height: 100,
                          width: 100,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/images.jpeg');
                          },
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(controller.flagList1.value[index]!.name
                              .toString()),
                          Text(controller.flagList1.value[index]!.subregion
                              .toString()),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }

  Future<Widget> getImage(String image) async {
    if (await ConnectivityService.isConnected()) {
      return Image.network(image);
    } else {
      return Image.asset('URL FROM ASSET FOLDER');
    }
  }
}
