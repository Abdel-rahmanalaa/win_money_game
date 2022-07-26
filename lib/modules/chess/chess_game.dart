// @dart=2.9
import 'dart:math';
import 'package:win_money_game/modules/chess/chess_board/flutter_chess_board.dart';
import 'package:win_money_game/modules/chess/chess_board/src/chess_sub.dart'
as chess_sub;
import 'package:win_money_game/modules/chess/generated/i18n.dart';
import 'package:win_money_game/modules/chess/util/online_game_utils.dart';
import 'package:win_money_game/modules/chess/util/utils.dart';
import 'package:win_money_game/modules/chess/util/widget_utils.dart';
import 'package:win_money_game/modules/chess/widgets/divider.dart';
import 'package:win_money_game/modules/chess/widgets/fancy_button.dart';
import 'package:win_money_game/modules/chess/widgets/fancy_options.dart';
import 'package:win_money_game/modules/chess/widgets/modal_progress_hud.dart';
import 'package:flutter/foundation.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:win_money_game/modules/chess/chess_board/src/chess_board.dart';
import 'package:win_money_game/modules/chess/chess_control/chess_controller.dart';
import 'package:flutter/material.dart';

S strings;
ChessController _chessController;
OnlineGameController _onlineGameController;
SharedPreferences prefs;
String uuid;

class chessGame extends StatefulWidget {
  chessGame({Key key}) : super(key: key);

  @override
  _chessGameState createState() => _chessGameState();
}

class _chessGameState extends State<chessGame> {
  Future<void> _loadEverythingUp() async {
    //load the old game
    await _chessController.loadOldGame();
    //set the king in chess board
    _chessController.setKingInCheckSquare();
    //await prefs
    prefs = await SharedPreferences.getInstance();
    //load values from prefs
    //the chess controller has already been set here!
    _chessController.botColor =
        chess_sub.Color.fromInt(prefs.getInt('bot_color') ?? 1);
    _chessController.whiteSideTowardsUser =
        prefs.getBool('whiteSideTowardsUser') ?? true;
    _chessController.botBattle = prefs.getBool('botbattle') ?? false;
    //load user id and if not available create and save one
    uuid = prefs.getString('uuid');
    print(uuid);
    if (uuid == null) {
      uuid = Uuid().v4();
      prefs.setString('uuid', uuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    //set strings object
    strings ??= S.of(context);
    //init the context singleton object
    ContextSingleton(context);
    //build the chess controller,
    //if needed set context newly
    if (_chessController == null)
      _chessController = ChessController(context);
    else
      _chessController.context = context;
    //create the online game controller if is null
    _onlineGameController = OnlineGameController(_chessController);
    return (_chessController.game == null)
        ? FutureBuilder(
      future: _loadEverythingUp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            var error = snapshot.error;
            print('$error');
            return Center(child: Text(strings.error));
          }
          return MyHomePageAfterLoading();
        } else {
          return Center(
            child: ModalProgressHUD(
              child: Container(),
              inAsyncCall: true,
            ),
          );
        }
      },
    )
        : MyHomePageAfterLoading();
  }
}

class MyHomePageAfterLoading extends StatefulWidget {
  MyHomePageAfterLoading({Key key}) : super(key: key);

  @override
  _MyHomePageAfterLoadingState createState() => _MyHomePageAfterLoadingState();
}

class _MyHomePageAfterLoadingState extends State<MyHomePageAfterLoading>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      // _chessController.saveOldGame();
        break;
      default:
        break;
    }
  }

  void update() {
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    _chessController.saveOldGame();
    return true;
  }

  void _onJoinCode() {
    //dialog to enter a code
    showAnimatedDialog(
        title: "Enter game id",
        onDoneText: "Join",
        icon: Icons.transit_enterexit,
        withInputField: true,
        inputFieldHint: "Ex.: KDFGHQ",
        onDone: (value) {
          _onlineGameController.joinGame(value);
        });
  }

  void _onCreateCode() {
    //if is currently in a game, this will disconnect from all local games, reset the board and create a firestore document
    showAnimatedDialog(
      title: "Warning",
      text: "Game will reset",
      onDoneText: "Proceed",
      icon: Icons.warning,
      onDone: (value) {
        if (value == 'Ok') _onlineGameController.finallyCreateGameCode();
      },
    );
  }

  void _onLeaveOnlineGame() {
    //show dialog to leave the online game
    showAnimatedDialog(
      title: "Leave online game",
      text: "Since you are hosting the game, leaving it means deleting it.",
      icon: Icons.warning,
      onDoneText: "Ok",
      onDone: (value) {
        if (value == 'Ok') _onlineGameController.leaveGame();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //get the available height for the chess board
    double availableHeight = MediaQuery.of(context).size.height - 184.3;
    //set the update method
    _chessController.update = update;
    //set the update method in the online game controller
    _onlineGameController.update = update;
    //the default scaffold
    return WillPopScope(
      onWillPop: _onWillPop,
      child: ModalProgressHUD(
        inAsyncCall: ChessController.loadingBotMoves,
        progressIndicator: kIsWeb
            ? Text(
          strings.loading_moves_web,
          style: Theme.of(context).textTheme.subtitle2,
        )
            : Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // children: [
          //   CircularProgressIndicator(),
          //   Text(
          //     "${_chessController.progress} boards processed",
          //     style: Theme.of(context).textTheme.bodyText1,
          //   ),
          // ],
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.deepPurple,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.amberAccent,
              iconTheme: const IconThemeData(
                color: Colors.deepPurple,
              ),
              title: const Text(
                'Chess',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Visibility(
                              visible: true,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FlatButton(
                                    shape: roundButtonShape,
                                    onPressed: () {
                                      //inverse the bot color and save it
                                      _chessController.botColor =
                                          chess_sub.Color.flip(
                                              _chessController.botColor);
                                      //save value int to prefs
                                      prefs.setInt('bot_color',
                                          _chessController.botColor.value);
                                      //set state, update the views
                                      setState(() {});
                                      //make move if needed
                                      _chessController.makeBotMoveIfRequired();
                                    },
                                    // child: Text(
                                    //     (_chessController.botColor ==
                                    //             chess_sub.Color.WHITE)
                                    //         ? "white"
                                    //         : "black",
                                    //     style:
                                    //         Theme.of(context).textTheme.button),
                                  ),
                                  // SizedBox(
                                  //   width: 8,
                                  // ),
                                  AbsorbPointer(
                                    child: LiteRollingSwitch(
                                      value: (prefs?.getBool("bot") ?? true),
                                      onChanged: (pos) {
                                        prefs.setBool("bot", true);
                                        //make move if needed
                                        _chessController
                                            ?.makeBotMoveIfRequired();
                                      },
                                      iconOn: Icons.done,
                                      iconOff: Icons.close,
                                      textOff: "bot off",
                                      textOn: "bot on",
                                      colorOff: Colors.red[800],
                                      colorOn: Colors.green[800],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // SelectableText(
                                //   currentGameCode,
                                //   style: Theme.of(context).textTheme.subtitle2,
                                // ),
                                Text(
                                  // strings.turn_of_x(
                                  //     ,
                                    (_chessController?.game?.game?.turn ==
                                        chess_sub.Color.BLACK
                                        ? "black's turn"
                                        : "white's turn"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                      inherit: true,
                                      color: (_chessController?.game
                                          ?.in_check() ??
                                          false)
                                          ? ((_chessController.game
                                          .inCheckmate(
                                          _chessController.game
                                              .moveCountIsZero()))
                                          ? Colors.purple
                                          : Colors.red)
                                          : Colors.white,
                                    )),
                              ],
                            ),
                          ),
                          Center(
                            // Center is a layout widget. It takes a single child and positions it
                            // in the middle of the parent.
                            child: SafeArea(
                              child: ChessBoard(
                                boardType: boardTypeFromString('o'),
                                size: min(MediaQuery.of(context).size.width,
                                    availableHeight),
                                onCheckMate: _chessController.onCheckMate,
                                onDraw: _chessController.onDraw,
                                onMove: _chessController.onMove,
                                onCheck: _chessController.onCheck,
                                chessBoardController:
                                _chessController.controller,
                                chess: _chessController.game,
                                whiteSideTowardsUser:
                                _chessController.whiteSideTowardsUser,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    collapseFancyOptions = true;
                    setState(() {});
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  FancyOptions(
                                    up: true,
                                    rootIcon: Icons.online_prediction,
                                    rootText: "online game",
                                    children: [
                                      FancyButton(
                                        onPressed: _onJoinCode,
                                        text: "Join Room",
                                        icon: Icons.transit_enterexit,
                                        animation: FancyButtonAnimation.pulse,
                                      ),
                                      FancyButton(
                                        onPressed: _onCreateCode,
                                        text: "Create Room",
                                        icon: Icons.add,
                                        animation: FancyButtonAnimation.pulse,
                                      ),
                                      FancyButton(
                                        text: "Leave Online Game",
                                        animation: FancyButtonAnimation.pulse,
                                        icon: Icons.exit_to_app,
                                        visible: inOnlineGame,
                                        onPressed: _onLeaveOnlineGame,
                                      ),
                                    ],
                                  ),
                                  Divider8(),
                                  DividerIfOffline(),
                                  FancyButton(
                                    visible: true,
                                    onPressed: _chessController.undo,
                                    animation: FancyButtonAnimation.pulse,
                                    icon: Icons.undo,
                                    text: "Undo",
                                  ),
                                  DividerIfOffline(),
                                  FancyButton(
                                    visible: true,
                                    onPressed: _chessController.resetBoard,
                                    icon: Icons.autorenew,
                                    text: "Replay",
                                  ),
                                  DividerIfOffline(),
                                  // Divider8(),
                                  // FancyButton(
                                  //   visible: true,
                                  //   onPressed: _chessController.switchColors,
                                  //   icon: Icons.switch_left,
                                  //   text: "switch_colors",
                                  // ),
                                  // DividerIfOffline(),
                                  // FancyButton(
                                  //   visible: !inOnlineGame,
                                  //   onPressed: _chessController.onSetDepth,
                                  //   icon: Icons.upload_rounded,
                                  //   animation: FancyButtonAnimation.pulse,
                                  //   text: strings.difficulty,
                                  // ),
                                  // DividerIfOffline(),
                                  // FancyButton(
                                  //   onPressed:
                                  //       _chessController.changeBoardStyle,
                                  //   icon: Icons.style,
                                  //   animation: FancyButtonAnimation.pulse,
                                  //   text: strings.choose_style,
                                  // ),
                                  // Divider8(),
                                  // FancyButton(
                                  //   visible: !inOnlineGame,
                                  //   onPressed: _chessController.onFen,
                                  //   text: 'fen',
                                  // ),
                                  // DividerIfOffline(),
                                  // Visibility(
                                  //   visible: !inOnlineGame,
                                  //   child: Container(
                                  //     width: 150,
                                  //     child: CheckboxListTile(
                                  //       shape: roundButtonShape,
                                  //       title: Text(strings.bot_vs_bot),
                                  //       value: _chessController.botBattle,
                                  //       onChanged: (value) {
                                  //         prefs.setBool('botbattle', value);
                                  //         _chessController.botBattle = value;
                                  //         setState(() {});
                                  //         //check if has to make bot move
                                  //         if (!_chessController
                                  //             .makeBotMoveIfRequired()) {
                                  //           //since move has not been made, inverse the bot color and retry
                                  //           _chessController.botColor =
                                  //               Chess.swap_color(
                                  //                   _chessController.botColor);
                                  //           _chessController
                                  //               .makeBotMoveIfRequired();
                                  //         }
                                  //       },
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
