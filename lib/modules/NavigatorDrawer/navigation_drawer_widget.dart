/*import 'dart:html';*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:win_money_game/models/user_model.dart';
import 'package:win_money_game/modules/NavigatorDrawer/drawer_item.dart';
import 'package:win_money_game/modules/NavigatorDrawer/Profile/profile.dart';
import 'package:win_money_game/modules/NavigatorDrawer/Settings/settings.dart';
import 'package:win_money_game/modules/NavigatorDrawer/Statistics/statistics.dart';
import 'package:win_money_game/modules/selectScreens/select_path_screen.dart';
import 'package:win_money_game/providers/sign_in_provider.dart';
import 'package:win_money_game/shared/components/components.dart';

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
              // DrawerItem(
              //   icon: Icons.help_outline,
              //   title: 'Help',
              //   onTap: () => onItemPressed(context, index: 2),
              // ),
              // const SizedBox(
              //   height: 30,),
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
                onTap: () => onItemPressed(context, index: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onItemPressed(BuildContext context, {required int index}) async
  {
    final user = FirebaseAuth.instance.currentUser!;
    Navigator.pop(context);

    switch(index) {
      case 0:
      {
        navigateTo(context, const StatisticsScreen());
        if(!StatisticsShown) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) =>
                AlertDialog(
                  title: const Text(
                    'Hint',
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  content: const Text(
                    'Complete Tasaly Statistics to Earn 25k Coins from each target.\n\nAnd Rebh Statistics to Earn 250 Cash and 50k Coins from each target.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.deepPurple,
                    ),
                  ),
                  backgroundColor: Colors.amberAccent,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
          StatisticsShown = true;
        }
      }
        break;
      case 1:
        navigateTo(context, const SettingsScreen());
        break;
      // case 2:
      //   navigateTo(context, const HelpScreen());
      //   break;
      case 2:
        final provider = Provider.of<SignInProvider>(context, listen: false);
        user.providerData.single.providerId == 'facebook.com' ? provider.facebookLogout() : provider.googleLogout();
        navigateBack(context, SelectPathScreen());
        break;

    }
  }

  Widget headerWidget(context)
  {
    return FutureBuilder<UserModel?>(
      future: readUser(),
      builder: (context, snapshot){
        if(snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if(snapshot.hasData){
          final user = snapshot.data;
          return user == null ? const Center(child:Text('No User')) : MaterialButton(
            onPressed: (){navigateTo(context, const ProfileScreen());},
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                children:
                [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundImage: AssetImage('assets/images/avatar_${user.avatar}.png',
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
                          getFirstWord(user.name).capitalize(),
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
                          percent: user.exp,
                          center: Text(
                            '${user.exp * 100}%',
                            style:  const TextStyle(fontSize: 12.0),
                          ),
                          //trailing: Icon(Icons.mood),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          backgroundColor: Colors.white,
                          progressColor: Colors.deepPurple,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Level: ${user.level}',
                          style: const TextStyle(
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
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      }
    );
  }
}
