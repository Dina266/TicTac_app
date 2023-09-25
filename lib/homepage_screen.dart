import 'package:flutter/material.dart';

import 'game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  bool gameOver = false;

  int turn = 0;

  String result = '';
  Game game = Game();
  bool isSwatched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: MediaQuery.of(context).orientation == Orientation.portrait
              ? Column(
                  children: [
                    ...firstBlock(),
                    _expanded(context),
                    ...lastBlock(),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...firstBlock(),
                          ...lastBlock(),
                        ],
                      ),
                    ),
                    _expanded(context),
                  ],
                )),
    );
  }

  _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateGame();

      if (!isSwatched && !gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        updateGame();
      }
    }
  }

  updateGame() {
    setState(() {
      turn++;
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      String winnerPlayer = game.checkWinner();

      if (winnerPlayer != '') {
        gameOver = true;
        result = "$winnerPlayer is the Winner";
      } else if (!gameOver && turn == 9) {
        result = "It's Draw!";
      }
    });
  }

  List<Widget> firstBlock() {
    return [
      SwitchListTile.adaptive(
        title: const Text(
          'Turn on/off Two Player ',
          style: TextStyle(color: Colors.white, fontSize: 30),
          textAlign: TextAlign.center,
        ),
        value: isSwatched,
        onChanged: (newVal) {
          setState(() {
            isSwatched = newVal;
          });
        },
      ),
      const SizedBox(
        height: 20,
      ),
      Text(
        "It's ${activePlayer == 'O' ? 'O' : 'X'} Turn",
        style: const TextStyle(color: Colors.white, fontSize: 52),
        textAlign: TextAlign.center,
      )
    ];
  }

  Expanded _expanded(BuildContext context) {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.0,
        crossAxisCount: 3,
        children: List.generate(
          9,
          (index) => InkWell(
            onTap: gameOver ? null : () => _onTap(index),
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Theme.of(context).shadowColor,
              ),
              child: Center(
                child: Text(
                  Player.playerO.contains(index)
                      ? 'O'
                      : Player.playerX.contains(index)
                          ? 'X'
                          : '',
                  style: TextStyle(
                      color: Player.playerX.contains(index)
                          ? Colors.blue
                          : Colors.pink,
                      fontSize: 50),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List lastBlock() {
    return [
      Text(
        result,
        style: const TextStyle(color: Colors.white, fontSize: 40),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20,),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            activePlayer = 'X';
            gameOver = false;
            turn = 0;
            result = '';
            Player.playerX = [];
            Player.playerO = [];
          });
        },
        icon: const Icon(Icons.replay),
        label:  const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Repeat the game', style: TextStyle(fontSize: 25),),
        ),
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).splashColor)),
      ),
      const SizedBox(height: 20,)
    ];
  }
}
