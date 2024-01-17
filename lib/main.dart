import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'p1pieces.dart';
import 'p2pieces.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'movePiece.dart';
import 'endGame.dart';

late Box<p2> P2box;
late Box<p1> P1box;
// separates the info in P1box and P2box by rows on the board
Map<int, String> row1 = {1:'',2:'',3:'',4:'',5:'',6:'',7:'', 8:''};
Map<int, String> row2 = {1:'',2:'',3:'',4:'',5:'',6:'',7:'', 8:''};
Map<int, String> row3 = {1:'',2:'',3:'',4:'',5:'',6:'',7:'', 8:''};
Map<int, String> row4 = {1:'',2:'',3:'',4:'',5:'',6:'',7:'', 8:''};
Map<int, String> row5 = {1:'',2:'',3:'',4:'',5:'',6:'',7:'', 8:''};
Map<int, String> row6 = {1:'',2:'',3:'',4:'',5:'',6:'',7:'', 8:''};
Map<int, String> row7 = {1:'',2:'',3:'',4:'',5:'',6:'',7:'', 8:''};
Map<int, String> row8 = {1:'',2:'',3:'',4:'',5:'',6:'',7:'', 8:''};

String player = 'Player1';
bool rebuildBoard = false;
String inputText = '';
bool illegalMove = false;
String illegalMoveDescrip = '';

// colour scheme
bool lightMode = true;
Color primaryColour = const Color(0xFF16324F);
Color secondaryColour = const Color(0xFF7D7C7A);
Color tertiaryColour = const Color(0xFFABA9BF);
Color textColour = Colors.white;

// used for resetting the board
int p1NewQueenPieces = 0;
int p2NewQueenPieces = 0;
int piecesOwnedByP1 = 16;
int piecesOwnedByP2 = 16;
bool endOfGame = false;

// navigation rail variables
int _selectedIndex = 0;
double groupAlignment = 0;
NavigationRailLabelType labelType = NavigationRailLabelType.none;

Future<void> main() async {
  // whole bit of code below until ** is taking the data from p1pieces.csv and adding it to a box of all player 1's pieces
  WidgetsFlutterBinding.ensureInitialized(); //HIVE SETUP
  await Hive.initFlutter();   //HIVE SETUP
  Hive.registerAdapter(p2Adapter());
  Hive.registerAdapter(p1Adapter());
  P2box = await Hive.openBox<p2>('P2');
  P1box = await Hive.openBox<p1>('P1');
  String csv = "p1pieces.csv"; //path to csv file asset
  String fileData = await rootBundle.loadString(csv);
  List <String> player1pieces = fileData.split("\n");
  addItemsToP1box(player1pieces);
  // **
  // From now until ***, this is the code used to put the p2pieces.csv file into P2box
  csv = "p2pieces.csv"; //path to csv file asset
  fileData = await rootBundle.loadString(csv);
  List <String> player2pieces = fileData.split("\n");
  addItemsToP2box(player2pieces);
  //***
  piecesByRow();
  runApp (
     MaterialApp(
       // hides the debug barrier
        debugShowCheckedModeBanner: false,
      home: board(),
    ),
  );
}

// populates all the row variables
void piecesByRow(){
  pieceByRow(row1, 1);
  pieceByRow(row2, 2);
  pieceByRow(row3, 3);
  pieceByRow(row4, 4);
  pieceByRow(row5, 5);
  pieceByRow(row6, 6);
  pieceByRow(row7, 7);
  pieceByRow(row8, 8);
}

// chess board class - first thing displayed when the program is loaded
class board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<board> {
  // changes the current player
  String currentPlayer(String current) {
    if (current == 'Player1') {
      current = 'Player2';
    } else {
      current = 'Player1';
    }
    return current;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: primaryColour,
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children:[
            // light mode/dark mode switch & current player text
            Align(
              alignment: Alignment.topLeft,
              child: SwitchListTile(
                value: lightMode,
                onChanged: (bool value) {
                  setState(() {
                    changeColourScheme();
                    if(lightMode == false){
                      lightMode = true;
                    }
                    else{
                      lightMode = false;
                    }
                  });
                },
                contentPadding: EdgeInsets.fromLTRB(150, 12, 12, 12),
                title: Text(
                  '$player',
                  style: TextStyle(
                    color: textColour,
                    fontSize: 30.0, // Adjust the font size as needed
                  ),
                ),
                activeColor: Color(0xFF16324F),
                activeTrackColor: Colors.white,
                inactiveThumbColor: Color(0xFFF3FFB9),
                inactiveTrackColor: Colors.black,
              ),
            ),
            // column guide
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 285.0),
                  child:
                  Column(
                    children: List.generate(8, (index) => rowGuide(index)),
                  ),
                )
              ],
            ),
            // board
            buildChessBoard(),
            // textfield to enter move
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 200, 
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          inputText = value;
                        }
                        );
                      },
                      style: TextStyle(color: textColour),
                      decoration: InputDecoration(
                        hintText: 'Enter your move',
                        hintStyle: TextStyle(color: textColour),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: tertiaryColour), // Set focused border color
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: tertiaryColour), // Set enabled border color
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  )
                ),
              ),
            ),
            // enter move button
            Align(
            alignment: Alignment.bottomRight,
            child:
            Padding(
                padding: EdgeInsets.all(16.0), // Adjust the value as needed
                child: FilledButton(
                  style: ButtonStyle(
                   backgroundColor: MaterialStatePropertyAll<Color>(tertiaryColour),
                ),
              onPressed: ()
              {setState(() {
                if(inputText == '' || inputText == ' '){
                  illegalMove = true;
                }
                else{
                  illegalMove = movePiece();
                }
                // if move is legal then rebuild the chess board
                if(illegalMove == false){
                  rebuildBoard = !illegalMove;
                }
                if(illegalMove == true){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${illegalMoveDescrip}', style: TextStyle(
                          color: textColour,
                        ),),
                          duration: const Duration(milliseconds: 1500),
                          backgroundColor: secondaryColour,
                        )
                  );
                  illegalMove = false;
              }
                if (rebuildBoard == true) {
                  if(endOfGame == true){
                    endOfGameDialog(context);
                    endOfGame = false;
                    {setState(() {
                      // Call the reset function here
                      resetVariables();
                      player = 'Player1';
                    });}
                  }
                  else{
                    player = currentPlayer(player);
                  }
                  clearRows();
                  piecesByRow();
                  board();
                  rebuildBoard = false;
                }
              });},
              //enter the players move
              //change the current player displayed
              child: Text ("Enter Move", style: TextStyle(color: textColour),),
            )
        ),
            ),
            // navigation rail
            Row(
              children: <Widget> [NavigationRail(
                  selectedIndex: _selectedIndex,
                  groupAlignment: groupAlignment,
                  backgroundColor: tertiaryColour,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                      _getPage(index, context);
                    });
                  },
                  labelType: labelType,
                  destinations: <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      selectedIcon: Icon(Icons.home_filled, color: secondaryColour),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.help_outline),
                      selectedIcon: Icon(Icons.help, color: secondaryColour),
                      label: Text('Help'),
                    ),
            ]),
                ]
            ),
            // total pieces for each player
            Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(padding: EdgeInsets.only(top: 160.0, right: 40), child: Text('Player 1 total pieces: ${piecesOwnedByP1}', style: TextStyle(color: textColour, fontSize: 20)))),
              Align(
                  alignment: Alignment.topRight,
                  child: Padding(padding: EdgeInsets.only(top: 20.0, right: 40), child: Text('Player 2 total pieces: ${piecesOwnedByP2}', style: TextStyle(color: textColour, fontSize: 20))))]
          ),
            // reset button
            Align(
              alignment: Alignment.bottomLeft,
              child:
              Padding(
                  padding: EdgeInsets.only(left:90.0, bottom: 16),
                  child: FilledButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(tertiaryColour),
                    ),
                    onPressed: ()
                    {setState(() {
                      // Call the reset function here
                      resetVariables();
                    });},
                    //enter the players move
                    //change the current player displayed
                    child: Text ("Reset", style: TextStyle(color: textColour),),
                  )
              ),
            ),
          ],
      ),)
    ),
    );}
}

// clears all the row variables - used when resetting the board
void clearRows(){
  row1 = {1:'',2:'',3:'',4:'',5:'',6:'',7:'', 8:''};
  row2 = {1:'',2:'',3:'',4:'',5:'',6:'',7:'', 8:''};
  row3 = {1:'',2:'',3:'',4:'',5:'',6:'',7:'', 8:''};
  row4 = {1:'',2:'',3:'',4:'',5:'',6:'',7:'', 8:''};
  row5 = {1:'',2:'',3:'',4:'',5:'',6:'',7:'', 8:''};
  row6 = {1:'',2:'',3:'',4:'',5:'',6:'',7:'', 8:''};
  row7 = {1:'',2:'',3:'',4:'',5:'',6:'',7:'', 8:''};
  row8 = {1:'',2:'',3:'',4:'',5:'',6:'',7:'', 8:''};
}

// builds the chess board - called when the program first loads, then whenever a move is made.
Widget buildChessBoard(){
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // prints the column letters above each column
        children: List.generate(8, (index) => columnGuide(index)),
      ),
      createRowOfContainers(0),
      createRowOfContainers(1),
      createRowOfContainers(2),
      createRowOfContainers(3),
      createRowOfContainers(4),
      createRowOfContainers(5),
      createRowOfContainers(6),
      createRowOfContainers(7)
    ],
  );
}

// generates each row of containers, using the info from the row variables
Widget createRowOfContainers(int row) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children:
    List.generate(8, (column) {
      return createContainer(column, row);}
    ),
  );
}

Widget createContainer(column, row) {
  // board has alternating colours
  Color currentColour = Colors.grey;
  if(row % 2 == 0){
    if(column % 2 == 0){
      currentColour = Colors.brown;
    }
  }
  else{
    if(column % 2 == 0){
    }
    else{
      currentColour = Colors.brown;
    }
  }
  // determines the text for the container
  String cellText = determiningText(row, column);
  // creates a container containing the cellText and the correct colour
  return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: currentColour,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: Color(0x4d9e9e9e), width: 1),
      ),
      child: Center(
        child: Text(
          cellText,
          style: TextStyle(
            color: determineTextColour(cellText), // Text color
          ),
        ),
      ));
}

// used by the navigation rail - selecting the icons changes the page between the board page and the help page.
Widget _getPage(int index, BuildContext context){
  if (index case 0) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => board()),
    );
    return board();
  } else if (index case 1) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => rules()),
    );
    return rules();
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => board()),
    );
    return board();
  }
}

// creates the rules page
class rules extends StatefulWidget {
  @override
  _rulesState createState() => _rulesState();
}

class _rulesState extends State<rules> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColour,
      body: Row(
        children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // navigation rail
                Row(
                    children: <Widget> [NavigationRail(
                        selectedIndex: _selectedIndex,
                        groupAlignment: groupAlignment,
                        backgroundColor: tertiaryColour,
                        onDestinationSelected: (int index) {
                          setState(() {
                            _selectedIndex = index;
                            _getPage(index, context);
                          });
                        },
                        labelType: labelType,
                        destinations: <NavigationRailDestination>[
                          NavigationRailDestination(
                            icon: Icon(Icons.home),
                            selectedIcon: Icon(Icons.home_filled, color: secondaryColour),
                            label: Text('Home'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.help_outline),
                            selectedIcon: Icon(Icons.help, color: secondaryColour),
                            label: Text('Help'),
                          ),
                        ]),
                    ]
                ),
                // first block of text
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 90.0),
                    child: Container(
                      width: 320,
                      height: 470,
                      color: secondaryColour,
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "            To play this game:\n"
                        "The game starts with player 1's go, and to move a piece please enter the name of the piece, then the new piece location e.g 1Pa 1e. Then press the enter move button.\n"
                        "The program checks that the move is 'legal' aka the piece belongs to the correct player, and that the move is correct for the piece type.\n",
                          style: TextStyle(
                            color: textColour,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          // middle section of the page - title and middle text block
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // page title
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Container(
                        width: 200,
                        height: 40,
                        color: secondaryColour,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Text(
                            "Rules & help: ",
                            style: TextStyle(
                              color: textColour,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // second block of text
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 40),
                      child: Container(
                        width: 320,
                        height: 470,
                        color: secondaryColour,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Pawns - these can move 2 moves forward on the first go, then only one move forward after \n"
                                "Knight - these move in an L shape, and can jump over other pieces \n"
                                "Bishop - these move diagonally as many moves as it likes \n"
                                "Rook - these can move as many pieces either vertically or horizontally \n"
                                "Queen - this piece can move any number of moves in any direction \n"
                                "King - this piece can only move one square at any time, in any direction \n",
                            style: TextStyle(
                              color: textColour,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ]
          ),
      // end section of text
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Container(
              width: 320,
              height: 470,
              color: secondaryColour,
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                      "The aim of the game is to take the other players king.\n"
                      "This version of the game does not check if a player is in check, so players need to keep their eye on their king at all times.\n"
                      "This game also does not allow en passant to work, or castling to work.\n"
                      "However, the pawn pieces can move forward 2 squares during their first move.\n",
                  style: TextStyle(
                    color: textColour,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),],
      )
      ],),
    );
  }
}

// Takes the list of player 1 and 2's pieces and separates them by location
Map<int, String> pieceByRow(Map<int, String>row, int RowNum){
  for(int i=0;i<P1box.length;i++){
    if (P1box.get(P1box.keyAt(i))!.location[0].toString() == RowNum.toString()){
      String toStore = P1box.keyAt(i);
      int colNum = convertColumnToNum(P1box.get(P1box.keyAt(i))!.location[1]);
      row[colNum] = toStore;
    }
  }
  // Separate for loops for each players pieces because one player may have less pieces than another
  for(int i=0;i<P2box.length;i++){
    if (P2box.get(P2box.keyAt(i))!.location[0] == RowNum.toString()){
      String toStore = P2box.keyAt(i);
      int colNum = convertColumnToNum(P2box.get(P2box.keyAt(i))!.location[1]);
      row[colNum] = toStore;
    }
  }
  return row;
}

// coverts the column letter to number
int convertColumnToNum(location){
  List<String> columnNames = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
  int colAsNum = 0;
  for(int i=0;i<7;i++){
    if(columnNames[i] == location){
      colAsNum = i+1;
    }
  }
  if(colAsNum == 0){
    colAsNum = 8;
  }
  return colAsNum;
}

// find the piece and displays it for each container - based on the current column and row
String determiningText(row, column){
  String text = '';
  if(row == 0){
    if(row1.isEmpty){
      text = ' ';
    }
    else {
      text = row1[column+1].toString();
    }
  }
  else if(row == 1){
    if(row2.isEmpty){
      text = ' ';
    }
    else {
      text = row2[column+1].toString();
    }
  }
  else if(row == 2){
    if(row3.isEmpty){
      text = ' ';
    }
    else {
      text = row3[column+1].toString();
    }
  }
  else if(row == 3){
    if(row4.isEmpty){
      text = ' ';
    }
    else {
      text = row4[column+1].toString();
    }
  }
  else if(row == 4){
    if(row5.isEmpty){
      text = ' ';
    }
    else {
      text = row5[column+1].toString();
    }
  }
  else if(row == 5){
    if(row6.isEmpty){
      text = ' ';
    }
    else {
      text = row6[column+1].toString();
    }
  }
  else if(row == 6){
    if(row7.isEmpty){
      text = ' ';
    }
    else {
      text = row7[column+1].toString();
    }
  }
  else if(row == 7){
    if(row8.isEmpty){
      text = ' ';
    }
    else {
      text = row8[column+1].toString();
    }
  }
  return text;
}

// Determines whether the piece belongs to player 1 or player 2 and changes the colour of the text the piece is displayed in
Color determineTextColour(String cellText){
  Color textColour = Colors.black;
  if(cellText.contains('1')){
    textColour = Colors.white;
  }
  return textColour;
}

// switches the colour scheme from light mode to dark mode
void changeColourScheme(){
  if(lightMode == true){
    primaryColour = const Color(0xFFF3FFB9);
    secondaryColour = const Color(0xFF82A7A6);
    tertiaryColour = const Color(0xFF6F584B);
    textColour = Colors.black;
  }
  else{
    primaryColour = const Color(0xFF16324F);
    secondaryColour = const Color(0xFF7D7C7A);
    tertiaryColour = const Color(0xFFABA9BF);
    textColour = Colors.white;
  }
}

// creates the column guide - displays the name of each column on the board.
class columnGuide extends StatelessWidget {
  final int index;
  List<String> columnNames = ['        a        ', '        b        ', '        c        ', '        d        ', '        e        ', '        f        ', '        g        ', '        h        '];
  columnGuide(this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '${columnNames[index]}',
        style: TextStyle(fontSize: 13.0,
          color: textColour),
      ),
    );
  }
}

// creates a row guide - displays the row number by each row on the board
class rowGuide extends StatelessWidget {
  final int index;
  List<String> rowNames = ['\n\n\n\n1\n\n', '\n\n2\n', '\n\n3\n', '\n\n4\n', '\n\n5\n', '\n\n6\n', '\n\n7\n', '\n\n8\n'];
  rowGuide(this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '${rowNames[index]}',
        style: TextStyle(fontSize: 13.0,
          color: textColour
        ),
      ),
    );
  }
}

// deals with the end of the game - displays an alertDialog (popup box) to state which player has won.
Future<void> endOfGameDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('The game has ended'),
        content: Text('Player ${determineWinner()} has won! Congratulations!!!'),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

int determineWinner(){
  if(player[player.length-1] == '1'){
    return 2;
  }
  else{
    return 1;
  }
}