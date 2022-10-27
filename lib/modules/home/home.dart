import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/data/local/shared_preferences.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/constants.dart';
import '../../generated/l10n.dart';
import '../login/login.dart';
import '../register/register.dart';
import 'components/pageview/orders_pageview.dart';
import 'components/pageview/profile_pageview.dart';
import 'components/pageview/restaurants_pageview.dart';

class HomeScreen extends StatefulWidget {
  final int moveTo;

  const HomeScreen({Key key, this.moveTo}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var hasLogin = false;
  TabController _tabController;
  var _tabScreenList = <Widget>[];
  var _tabs = <Tab>[];
  var currentIndex = 0;

  var _restaurantPageView = RestaurantsPageView();
  var _ordersPageView = OrdersPageView();
  var _profilePageView = ProfilePageView();

  @override
  void initState() {
    super.initState();
    _checkLoginState();

    _restaurantPageView.openEnterDialog = () {
      _startLoginFlow();
    };

    _tabController = _provideTabController();
    _tabController.addListener(() {
      switch (_tabController.index) {
        case 0:
          _restaurantPageView.refreshList();
          _ordersPageView.disposeCounter();
          break;
        case 1:
          _ordersPageView.refreshLists();
          break;
        case 2:
          _ordersPageView.disposeCounter();
          break;
      }
    });

    Timer(Duration(milliseconds: 600), () {
      _tabController.animateTo(widget.moveTo);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //provide tab controller
  TabController _provideTabController() {
    return TabController(length: 3, vsync: this, initialIndex: 0);
  }

  //provide tab list
  List<Tab> _provideTabList(BuildContext context) {
    var tabTitleList = [
      S.of(context).home_panel_start,
      S.of(context).home_panel_order,
      S.of(context).home_panel_profile,
    ];

    _tabs.clear();
    for (int i = 0; i < tabTitleList.length; i++) {
      _tabs.add(_buildNavBarItem(i, tabTitleList[i]));
    }
    return _tabs;
  }

  @override
  Widget build(BuildContext context) {
    _tabs = _provideTabList(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(context),
      backgroundColor: colorBackground,
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    var title = "";
    switch (currentIndex) {
      case 0:
        title = S.of(context).home_appBarTitle;
        break;
      case 1:
        title = S.of(context).home_appBarTitle_order;
        break;
      case 2:
        title = S.of(context).home_appBarTitle_profile;
        break;
    }
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: appBarTextStyle,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    _tabController.addListener(() {
      setState(() {
        currentIndex = _tabController.index;
      });
    });

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          _buildPageView(),
          _buildBottomPanel(context),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return TabBarView(
      physics: hasLogin ? null : NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: _provideTabScreenList(),
    );
  }

  Align _buildBottomPanel(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 56,
        margin: EdgeInsets.all(8),
        width: double.infinity,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorPrimary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: hasLogin ? _buildLoggedUserBottomBar() : _buildNotConnectedUserBottomBar(),
      ),
    );
  }

  Widget _buildNotConnectedUserBottomBar() {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        highlightColor: Colors.white12,
        onTap: () {
          _startLoginFlow();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              S.of(context).home_firstVersionMessage,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoggedUserBottomBar() {
    return TabBar(
      labelColor: Colors.white,
      labelPadding: EdgeInsets.only(left: 8, right: 8),
      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      unselectedLabelColor: Colors.white70,
      unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 0,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white),
      ),
      controller: _tabController,
      tabs: _tabs,
    );
  }

  List<Widget> _provideTabScreenList() {
    _tabScreenList.clear();
    _tabScreenList.add(_restaurantPageView);
    _tabScreenList.add(_ordersPageView);
    _tabScreenList.add(_profilePageView);

    return _tabScreenList;
  }

  Widget _buildNavBarItem(int position, String label) {
    return Tab(
      child: Padding(
        padding: EdgeInsets.only(right: 16, left: 16),
        child: Text(label),
      ),
    );
  }

  _startLoginFlow() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: LoginScreen(
          scaffoldKey: _scaffoldKey,
          loginCompleted: () {
            Navigator.pop(context);
            _checkLoginState();
          },
          registerNewAccount: () async {
            Navigator.pop(context);
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterScreen(),
              ),
            );
            _checkLoginState();
          },
        ),
      ),
    );
  }

  _checkLoginState() async {
    log("login checked");
    var hasUserLogged = await SharedPreferencesUtils.hasUserLogged();
    setState(() {
      hasLogin = hasUserLogged;
    });
  }
}
