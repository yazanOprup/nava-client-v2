import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/helpers/customs/Visitor.dart';
import 'package:nava/helpers/providers/visitor_provider.dart';
import 'package:nava/layouts/Home/orders/FinishedOrders.dart';
import 'package:nava/layouts/Home/orders/ProcessingOredrs.dart';
import 'package:nava/layouts/settings/contact_us/ContactUs.dart';
import 'package:provider/provider.dart';

import '../../../res.dart';
import '../../settings/contact_us/mainContactUs.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this,initialIndex: 0);

    _controller.addListener(() {
      setState(() {
        currentIndex = _controller.index;
      });
      print("Selected Index: " + _controller.index.toString());
    });
  }

  int currentIndex = 0;
  TabController _controller;


  @override
  Widget build(BuildContext context) {
    VisitorProvider visitorProvider =
        Provider.of<VisitorProvider>(context, listen: false);

    return Scaffold(
      //backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          tr("orders"),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: TabBar(
            controller: _controller,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.white,
            labelPadding: EdgeInsets.symmetric(horizontal: 5),
            
            tabs: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: currentIndex == 0
                      ? MyColors.primary
                      : MyColors.containerColor,
                ),
                child: Text(
                  tr("processingOrders"),
                  style: TextStyle(
                    color: currentIndex == 0 ? Colors.white : Colors.grey,
                  ),
                ),
              ),
              
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: currentIndex == 1
                      ? MyColors.primary
                      : MyColors.containerColor,
                ),
                child: Text(
                  tr("finishedOrders"),
                  style: TextStyle(
                    color: currentIndex == 1 ? Colors.white : Colors.grey,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: currentIndex == 2
                      ? MyColors.primary
                      : MyColors.containerColor,
                ),
                child: Text(
                  tr("guarantee"),
                  style: TextStyle(
                    color: currentIndex == 2 ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        //leading: CustomBackButton(ctx: context),
      ),
      body: visitorProvider.visitor
          ? Visitor()
          : Container(
              //height: MediaQuery.of(context).size.height * .685,
              child: TabBarView(
                controller: _controller,
                children: <Widget>[
                  ProcessingOrders(),
                  FinishedOrders(),
                 Container()
                ],
              ),
            ),
    );
  }
}
