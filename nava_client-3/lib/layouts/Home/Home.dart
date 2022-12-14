import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:nava/helpers/constants/MyColors.dart';
import 'package:nava/layouts/Home/main/Main.dart';
import 'package:nava/layouts/Home/orders/Orders.dart';
// import 'package:nava/layouts/Home/settings/Settings.dart';
import 'package:nava/layouts/Home/wallet/Wallet.dart';
import 'package:nava/layouts/settings/Settings.dart';

class Home extends StatefulWidget {
  final int index;

  const Home({Key key, this.index}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      tabs = [
        Main(),
        Orders(),
        Wallet(),
        Settings(),
      ];
    });
    whichPage();
  }

  TabController tabController;
  int currentTabIndex = 0;
  List<Widget> tabs = [];
  whichPage() async {
    if (widget.index != null) {
      setState(() {
        currentTabIndex = widget.index;
      });
    } else {
      setState(() {
        currentTabIndex = 0;
      });
    }
  }

  void onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        //padding: EdgeInsets.only(top: 1),
        height: MediaQuery.of(context).size.height * 0.08,
        color: MyColors.primary,
        child: BottomNavigationBar(
          backgroundColor: MyColors.primary,
          showUnselectedLabels: true,
          selectedIconTheme: IconThemeData(size: 35, color: MyColors.secondary),
          unselectedIconTheme: IconThemeData(size: 30, color: MyColors.accent),
          selectedLabelStyle:
              TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 10),
          selectedItemColor: MyColors.secondary,
          unselectedItemColor: MyColors.secondary.withOpacity(0.5),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          showSelectedLabels: true,
          currentIndex: currentTabIndex,
          onTap: onTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Mdi.home,
                ),
                label: tr("main")),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment), label: tr("orders")),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet), label: tr("wallet")),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: tr("settings")),
          ],
        ),
      ),
      body: tabs.elementAt(currentTabIndex),
      resizeToAvoidBottomInset: true,
    );
  }
}
