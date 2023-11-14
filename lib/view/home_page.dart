import 'package:ai_chat/controller/controller.dart';
import 'package:ai_chat/view/add_char_page.dart';
import 'package:ai_chat/view/char_list_page.dart';
import 'package:ai_chat/widget/home_page_widget/home_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  Controller controller = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Fallasana Admin Panel"),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                HomeTile(
                  title: "Add New Character",
                  onTap: () => changePage(1),
                ),
                HomeTile(
                  title: "Character List",
                  onTap: () => changePage(2),
                ),
              ],
            ),
          ),
          Expanded(flex: 10, child: Obx(() => displayPage()))
        ],
      ),
    );
  }

  changePage(int index) {
    controller.pageIndex.value = index;
  }

  displayPage() {
    switch (controller.pageIndex.value) {
      case 0:
        return const SizedBox();

      case 1:
        return const AddCharPage();
      case 2:
        return const CharListPage();
    }
  }
}
