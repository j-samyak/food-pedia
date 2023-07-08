import 'dart:convert';
import 'dart:async';

import 'package:fastfood/Screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:fastfood/Screens/login/login.dart';
import 'package:fastfood/core/widget/divider/divider_widget.dart';
import 'package:fastfood/core/widget/error/error_widget.dart';
import 'package:fastfood/core/widget/listTile/drawer_listTile_widget.dart';
import 'package:fastfood/core/widget/loading/loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fastfood/Models/UsersModel.dart';

const SERVER_IP = "http://192.168.242.1:3000";

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('jwt');
  }

  late String a = "";
  late String b = "";

  void fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic token = prefs.getString("jwt");
    print(token);

    final response = await http.get(Uri.parse('$SERVER_IP/user/'),
        headers: {'Authorization': 'Bearer $token'});
    
    var res = json.decode(response.body);
    print(res);
    print("status code for user: ${response.statusCode}");

    // if (response.statusCode == 200) {
    //   List jsonResponse = json.decode(response.body);

    //   return (jsonResponse as List).map((myMap) => UserData.fromJson(myMap)).toList();
    // }else{
    //   print("error");
    //   List jsonResponse = json.decode(response.body);

    //   return (jsonResponse as List).map((myMap) => UserData.fromJson(myMap)).toList();
    // }
    // //return json.decode(response.body);
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Drawer(
  //     child: FutureBuilder(
  //         future: fetchUserData(),
  //         builder:
  //             (BuildContext context, AsyncSnapshot<List<UserData>> snapshot) =>
  //                 snapshot.hasData
  //                     ? _buildMainBody(snapshot, context)
  //                     : snapshot.hasError
  //                         ? ErrorDataView()
  //                         : LoadingView()
  //         // builder: (BuildContext context, AsyncSnapshot<List<UserData>> snapshot) {
  //         //   print("data in snapshot: ${snapshot.data}");
  //         //   if(snapshot.hasData){
  //         //     print("no error");
  //         //     return _buildMainBody(snapshot, context);
  //         //   }else if(snapshot.hasError){
  //         //     print("there is error in loading user");
  //         //     print(snapshot.error);
  //         //     return ErrorDataView();
  //         //   }else{
  //         //     return LoadingView();
  //         //   }
  //         // },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(a),
            accountEmail: Text(b),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image:  DecorationImage(
                  fit: BoxFit.contain,
                  image: ImagePath.profile.profileToAsset(),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                // ListTile(
                //   leading: Icon(Icons.home),
                //   title: Text(ListTileTexts.Homepage.name),
                //   trailing: IconButton(
                //     icon: Icon(Icons.chevron_right),
                //     onPressed: (){
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => ),
                //       );
                //     },
                //   ),
                // ),
                // DrawerMenuListTileView(
                //   icon: Icons.search,
                //   title: ListTileTexts.Search.name,
                // ),
                // DrawerMenuListTileView(
                //   icon: Icons.account_box,
                //   title: ListTileTexts.Profile.name,
                // ),
                // DividerView(),
                InkWell(
                  onTap: () {
                    setState(() {
                      logOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    });
                  },
                  splashColor: Colors.greenAccent,
                  child: DrawerMenuListTileView(
                    icon: Icons.logout,
                    title: ListTileTexts.Logout.name,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Column _buildMainBody(
      AsyncSnapshot<List<UserData>> snapshot, BuildContext context) {
    return Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("${snapshot.data?[0].username}"),
          accountEmail: Text("${snapshot.data?[0].email}"),
          currentAccountPicture: new Container(
            decoration: _buildDecoration(),
          ),
        ),
        Expanded(
          child: _buildListView(context),
        )
      ],
    );
  }

  BoxDecoration _buildDecoration() {
    return new BoxDecoration(
      shape: BoxShape.circle,
      image: new DecorationImage(
        fit: BoxFit.contain,
        image: ImagePath.profile.profileToAsset(),
      ),
    );
  }

  ListView _buildListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        DrawerMenuListTileView(
          icon: Icons.home,
          title: ListTileTexts.Homepage.name,
        ),
        DrawerMenuListTileView(
          icon: Icons.search,
          title: ListTileTexts.Search.name,
        ),
        DrawerMenuListTileView(
          icon: Icons.account_box,
          title: ListTileTexts.Profile.name,
        ),
        DividerView(),
        _buildLogoutListTile(context),
      ],
    );
  }

  InkWell _buildLogoutListTile(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          logOut();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        });
      },
      splashColor: Colors.greenAccent,
      child: DrawerMenuListTileView(
        icon: Icons.logout,
        title: ListTileTexts.Logout.name,
      ),
    );
  }
}

enum ListTileTexts { Homepage, Search, Profile, Logout }

enum ImagePath { profile }

extension ImageExtension on ImagePath {
  String profilePath() {
    return "assets/images/${ImagePath.profile.name}.png";
  }

  AssetImage profileToAsset() {
    return AssetImage(profilePath());
  }
}
