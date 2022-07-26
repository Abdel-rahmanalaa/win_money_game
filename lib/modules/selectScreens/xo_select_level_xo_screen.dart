import 'package:flutter/material.dart';
import 'package:win_money_game/modules/selectScreens/xo_select_bet_screen.dart';
import 'package:win_money_game/modules/xo-online/responsive/responsive.dart';
import 'package:win_money_game/modules/xo/first_xo_screen.dart';
import 'package:win_money_game/modules/xo/second_xo_screen.dart';
import 'package:win_money_game/modules/xo/third_xo_screen.dart';
import 'package:win_money_game/shared/components/components.dart';

class SelectLevelXoScreen extends StatelessWidget {
  const SelectLevelXoScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Responsive(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            defaultButton(
              function: () {
                select3x3 = true;
                select4x4 = false;
                select5x5 = false;
                if(playOnline)
                  navigateTo(context, XoSelectBetScreen());
                if(playOffline)
                  navigateTo(context, FirstXOScreen());
              },
              backgroundColorBox: Colors.amberAccent,
              textColor: Colors.deepPurple,
              text: 'Play Game 3x3',
              width: 300,
              isUpperCase: false,
            ),
            const SizedBox(height: 20),
            defaultButton(
              function: () {
                select3x3 = false;
                select4x4 = true;
                select5x5 = false;
                if(playOnline)
                navigateTo(context, XoSelectBetScreen());
                if(playOffline)
                  navigateTo(context, SecondXOScreen());
              },
              backgroundColorBox: Colors.amberAccent,
              textColor: Colors.deepPurple,
              text: 'Play Game 4x4',
              width: 300,
              isUpperCase: false,
            ),
            const SizedBox(height: 20),
            defaultButton(
              function: () {
                select3x3 = false;
                select4x4 = false;
                select5x5 = true;
                if(playOnline)
                navigateTo(context, XoSelectBetScreen());
                if(playOffline)
                  navigateTo(context, ThirdXOScreen());
              },
              backgroundColorBox: Colors.amberAccent,
              textColor: Colors.deepPurple,
              text: 'Play Game 5x5',
              width: 300,
              isUpperCase: false,
            ),
          ],
        ),
      ),
    );
  }
}
