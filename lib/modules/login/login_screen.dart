import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:win_money_game/modules/selectScreens/select_path_screen.dart';
import 'package:win_money_game/providers/sign_in_provider.dart';

class LoginScreen extends StatelessWidget {

  Map? _userData;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if(snapshot.hasData){
          return SelectPathScreen();
        } else if(snapshot.hasError) {
          return Center(child: Text('Something Went Wrong!'));
        } else {
          return Scaffold(
            backgroundColor: Colors.deepPurple,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: Lottie.asset('assets/win-money.json',),
                    ),
                    const SizedBox(height: 50,),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                              250, 60
                          ),
                          textStyle: TextStyle(fontSize: 18),
                          side: const BorderSide(
                            color: Colors.white,
                          )
                      ),
                      label: const Text('Log in with Facebook'),
                      icon: const Icon(Icons.facebook),
                      onPressed: () {
                        final provider = Provider.of<SignInProvider>(
                            context, listen: false);
                        provider.facebookLogin(context);
                      },
                    ),
                    const SizedBox(height: 20,),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                              250, 60
                          ),
                          textStyle: const TextStyle(fontSize: 18),
                          side: const BorderSide(
                            color: Colors.white,
                          )
                      ),
                      label: const Text('Log in with Google'),
                      icon: FaIcon(FontAwesomeIcons.google),
                      // icon: const Icon(Icons.email),
                      onPressed: () {
                        final provider = Provider.of<SignInProvider>(
                            context, listen: false);
                        provider.googleLogin(context);
                      },
                    ),
                  ],
                ),
              ),
              scrollDirection: Axis.vertical,
            ),
          );
        }
      },
    );
  }
}
