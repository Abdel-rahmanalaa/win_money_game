import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:win_money_game/layout/home_layout_screen.dart';
import 'package:win_money_game/providers/missions_provider.dart';
import 'package:win_money_game/shared/components/components.dart';

class SelectPathScreen extends StatelessWidget {
  const SelectPathScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: InkWell(
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text(
                      'Tasaly',
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
                    ),
                    content: const Text(
                      'Play for fun',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.deepPurple,
                      ),
                    ),
                    backgroundColor: Colors.amberAccent,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          selectTasaly = true;
                          Navigator.pop(context);
                          return navigateTo(context, const HomeLayoutScreen());
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );

              },
              splashColor: Colors.deepPurple,
              child: Image.asset(
                "assets/images/Tasaly.png",
                width: double.infinity,
                height: 300,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: InkWell(
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text(
                      'Rebh',
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
                    ),
                    content: const Text(
                      'Play to win money',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.deepPurple,
                      ),
                    ),
                    backgroundColor: Colors.amberAccent,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          selectRebh = true;
                          Navigator.pop(context);
                          return navigateTo(context, const HomeLayoutScreen());
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              splashColor: Colors.deepPurple,
              child: Image.asset(
                "assets/images/rebh.png",
                width: double.infinity,
                height: 300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
