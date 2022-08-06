/*import 'dart:html';*/


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:win_money_game/modules/NavigatorDrawer/drawer_item.dart';
import 'package:win_money_game/modules/NavigatorDrawer/help.dart';
import 'package:win_money_game/modules/NavigatorDrawer/Profile/profile.dart';
import 'package:win_money_game/modules/NavigatorDrawer/settings.dart';
import 'package:win_money_game/modules/NavigatorDrawer/Statistics/statistics.dart';
import 'package:win_money_game/modules/login/provider/google_sign_in.dart';
import 'package:win_money_game/shared/component/component.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Material(
        color: Colors.amberAccent,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 80, 24, 0),
          child: Column(
            children:
            [
              headerWidget(context),
              const SizedBox(
                height: 30,),
              const Divider(
                thickness: 1,
                height: 10,
                color: Colors.white,
              ),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                icon: Icons.stacked_bar_chart_outlined,
                title: 'Statistics',
                onTap: () => onItemPressed(context, index: 0),
              ),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                icon: Icons.settings,
                title: 'Settings',
                onTap: () => onItemPressed(context, index: 1),
              ),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                icon: Icons.help_outline,
                title: 'Help',
                onTap: () => onItemPressed(context, index: 2),
              ),
              const SizedBox(
                height: 30,),
              const Divider(
                thickness: 1,
                height: 10,
                color: Colors.white,
              ),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                icon: Icons.logout_outlined,
                title: 'SignOut',
                titleColor: Colors.deepPurple,
                iconColor: Colors.deepPurple,
                onTap: () => onItemPressed(context, index: 3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onItemPressed(BuildContext context, {required int index}) async
  {
    Navigator.pop(context);

    switch(index)
    {
      case 0:
        navigateTo(context, const StatisticsScreen());
        break;
      case 1:
        navigateTo(context, const SettingsScreen());
        break;
      case 2:
        navigateTo(context, const HelpScreen());
        break;
      case 3:
        // await FacebookAuth.i.logOut();
        final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.googleLogout();
        break;
    }
  }

  Widget headerWidget(context)
  {
    final user = FirebaseAuth.instance.currentUser!;
    return MaterialButton(

      onPressed: (){navigateTo(context, ProfileScreen());},
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          children:
          [
             CircleAvatar(
              radius: 30,
               backgroundColor: Theme.of(context).scaffoldBackgroundColor,
               backgroundImage: const AssetImage('assets/images/avatar_7.png',
               ),
             ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  Text(
                    getFirstWord(user.displayName!).capitalize(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  LinearPercentIndicator(
                    alignment: MainAxisAlignment.start,
                    width: 140.0,
                    lineHeight: 14.0,
                    percent: 0.5,
                    center: const Text(
                      "50.0%",
                      style:  TextStyle(fontSize: 12.0),
                    ),
                    //trailing: Icon(Icons.mood),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    backgroundColor: Colors.white,
                    progressColor: Colors.deepPurple,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Level: 100',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
