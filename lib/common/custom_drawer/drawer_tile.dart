import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/preferences.dart';

class DrawerTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final int page;
  DrawerTile({@required this.iconData, @required this.title, @required this.page});
  @override
  Widget build(BuildContext context) {
    final int currentPage =  Get.find<PageManager>().page;
    
    return InkWell(
      onTap: (){
        PageManager pageManager = Get.find();
        pageManager.setPage(value: page);

      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Icon(
                iconData,
                size: 32,
                color: currentPage == page ? primaryColor : Colors.grey[700],
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: currentPage == page ? primaryColor : Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
