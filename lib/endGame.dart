import 'main.dart';
import 'package:chess/p1pieces.dart';
import 'package:chess/p2pieces.dart';

bool checkForEndOfGame(currentPlayer){
  bool endGame = false;
  if(currentPlayer == 1){
    // make a list of all the pieces in the box
    List<String> pieces = [];
    for(int i=0;i<P2box.length;i++){
      pieces.add(P2box.get(P2box.keyAt(i))!.idname);
    }

    // check if the king piece exists in the list that was just created
    if (pieces.contains('2K')){
    }
    else{
      endGame = true;
    }
  }
  else{
    // make a list of all the pieces in the box
    List<String> pieces = [];
    for(int i=0;i<P1box.length;i++){
      pieces.add(P1box.get(P1box.keyAt(i))!.idname);
    }

    // check if the king piece exists in the list that was just created
    if (pieces.contains('1K')){
    }
    else{
      endGame = true;
    }
  }

  return endGame;
}

void addItemsToP1box(listOfItems){
  for (int i = 0; i < listOfItems.length; i++) {
    String row = listOfItems[i];
    List <String> itemInRow = row.split(",");
    p1 piece = p1(
      itemInRow[0],
      itemInRow[1],
      itemInRow[2],);
    String key = itemInRow[0];
    P1box.put(key, piece);
  }
}

void addItemsToP2box(listOfItems){
  for (int i = 0; i < listOfItems.length; i++)  {
    String row = listOfItems[i];
    List <String> itemInRow = row.split(",");
    p2 piece = p2(
      itemInRow[0],
      itemInRow[1],
      itemInRow[2],);
    String key = itemInRow[0];
    P2box.put(key, piece);
  }
}

void resetVariables(){
// reset the boxes
  P1box.flush();
  List<String> player1Pieces = ['1Pa,7a,true','1Pb,7b,true','1Pc,7c,true','1Pd,7d,true','1Pe,7e,true','1Pf,7f,true','1Pg,7g,true','1Ph,7h,true','1Ra,8a,true','1Rb,8h,true','1K,8e,true','1Q,8d,true','1Ba,8c,true','1Bb,8f,true','1Kna,8b,true', '1Knb,8g,true'];
  addItemsToP1box(player1Pieces);
  P2box.flush();
  List<String> player2Pieces = ['2Pa,2a,true','2Pb,2b,true','2Pc,2c,true','2Pd,2d,true','2Pe,2e,true','2Pf,2f,true','2Pg,2g,true','2Ph,2h,true','2Ra,1a,true','2Rb,1h,true','2K,1e,true','2Q,1d,true','2Ba,1c,true','2Bb,1f,true','2Kna,1b,true', '2Knb,1g,true'];
  addItemsToP2box(player2Pieces);


// reset key variables
  player = 'Player1';
  p1NewQueenPieces = 0;
  p2NewQueenPieces = 0;
  piecesOwnedByP1 = 16;
  piecesOwnedByP2 = 16;
  inputText = '';

  clearRows();
  piecesByRow();

  board();
}
