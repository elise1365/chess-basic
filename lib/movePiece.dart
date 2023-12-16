import 'package:chess/p1pieces.dart';
import 'package:chess/p2pieces.dart';
import 'p1pieces.dart';
import 'p2pieces.dart';
import 'main.dart';
import 'pieceMoves.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

bool movePiece() {
  // determine player
  int currentPlayer = 0;
  if (inputText[0] == '2') {
    currentPlayer = 2;
  }
  else {
    currentPlayer = 1;
  }

  // determine new location and piece name
  bool spaceReached = false;
  String pieceName = '';
  String newLocation = '';
  for (int i = 0; i < inputText.length; i++) {
    if (spaceReached == true) {
      newLocation += inputText[i];
    }
    else{
      pieceName += inputText[i];
    }
    if (inputText[i] == ' ') {
      spaceReached = true;
    }
  }
  pieceName.replaceAll(' ', '');

  // determine whether the new location already contains a piece belonging to the other player, and find the current location name
  bool pieceBeingTaken = false;
  String currentLoc = '';
  bool firstMove = false;
  if(currentPlayer == 1){
    pieceName = pieceName.replaceAll(' ', '');
    currentLoc = P1box.get(pieceName)!.location;
    if(P2box.values.contains(newLocation)){
      pieceBeingTaken = true;
    }
    if(pieceName.contains('P')){
      print(P1box.get(pieceName)?.firstMove);
      if(P1box.get(pieceName)?.firstMove == true){
        firstMove = true;
        print(111);
      }
    }
  }
  else{
    // get the current location
    currentLoc = P2box.get(pieceName)!.location;
    // find out if the new location contains a piece belonging to the other player
    if(P1box.values.contains(newLocation)){
      pieceBeingTaken = true;
    }
    // check if the piece is a pawn, and if it is then check if this is the pawns first move
    if(pieceName.contains('P')){
      if(P2box.get(pieceName)!.firstMove == true){
        firstMove = true;
      }
    }
  }

  // ensure the piece and move entered is legal
  if (checkMove(pieceBeingTaken, currentPlayer, firstMove, currentLoc, pieceName) == true) {
    if(pieceBeingTaken == true){
      if (currentPlayer == 1) {
        int key = 0;
        // finding the key of the item in the list to remove.
        for (int i = 0; i < P2box.length; i++) {
          if (P2box.get(P2box.keyAt(i))!.location == newLocation) {
            key = i;
          }
        }
        P2box.delete(key); // remove the piece from the players list of pieces
      }
      else {
        int key = 0;
        // finding the key of the item in the list to remove.
        for (int i = 0; i < P1box.length; i++) {
          if (P1box.get(P1box.keyAt(i))!.location == newLocation) {
            key = i;
          }
        }
        P1box.delete(key); // remove the piece from the players list of pieces
      }
    }
    //now change the location of the piece in the text box, and call the function that builds the chessboard so that it updates
    if(player == 1){
      // identify the key
      int key = 0;
      for(int i=0;i<P1box.length;i++){
        if(P1box.keyAt(i) == pieceName){
          key = i;
        }
      }
      P1box.delete(key);
      P1box.put(key, newLocation as p1);
    }
    else{
      // identify the key
      int key = 0;
      for(int i=0;i<P2box.length;i++){
        if(P2box.keyAt(i) == pieceName){
          key = i;
        }
      }
      P2box.delete(key);
      P2box.put(key, newLocation as p2);
    }
  }
  else{
    illegalMove = true;
  }
  return illegalMove;
}

String findCurrentLoc(){
  String currentLoc = '';
  return currentLoc;
}

bool checkMove(takingPiece, currentPlayer, firstMove, currentLoc, pieceName){
  bool correctPlayer = false;
  bool legalMove = false;
  bool pieceExists = false;
  bool legalLocation = false;
  bool currentPlayerPieceAlreadyThere = false;

  String newLocation = '${inputText[inputText.length - 2]}${inputText[inputText.length - 1]}';

  if(currentPlayer == 1){
    if(P1box.keys.contains(pieceName)){
      pieceExists = true;
    }
  }
  else{
    if(P2box.keys.contains(pieceName)){
      pieceExists = true;
    }
  }
  if(pieceExists == true){
    // location
    List<String> columnNames = ['a','b','c','d','e','f','g','h'];
    List<String> rowNumbers = ['1','2','3','4','5','6','7','8'];
    if(columnNames.contains(newLocation[newLocation.length-2])){
      if(rowNumbers.contains(newLocation[newLocation.length-1])){
        legalLocation = true;
      }
    }
    if(legalLocation == true){
      // correctPlayer
      if(inputText[0] == player[6]){
        correctPlayer = true;
      }
      if(correctPlayer == true){
        if(currentPlayer == 1){
          if(P1box.values.contains(newLocation)){
            currentPlayerPieceAlreadyThere = true;
          }
        }
        else{
          if(P2box.values.contains(newLocation)){
            currentPlayerPieceAlreadyThere = true;
          }
        }
        if(currentPlayerPieceAlreadyThere == false){
          int spaceLocation = 0;
          for(int i=0;i<inputText.length;i++){
            if(inputText[i] == ' '){
              spaceLocation = i;
            }
          }
          String piece = inputText[spaceLocation-2];
          if(piece == 'P'){
            print(currentLoc);
            return pawnMove(currentLoc, newLocation, firstMove, takingPiece, currentPlayer);
          }
          else if(piece == 'n'){
            knightMove(currentLoc, newLocation);
          }
          else if(piece == 'Q'){
            queenMove(currentLoc, newLocation);
          }
          else if(piece == 'K'){
            kingMove(currentLoc, newLocation);
          }
          else if(piece == 'B'){
            bishopMove(currentLoc, newLocation);
          }
          else if(piece == 'R'){
            rookMove(currentLoc, newLocation);
          }
          if(legalMove == true){
            //   move piece
            return true;
          }
          else{
            illegalMove = true;
            illegalMoveDescrip = 'This move is illegal because the move entered is not legal for that piece, please try a different location or a different piece. Please try again';
            return false;
          }
        }
        else{
          illegalMove = true;
          illegalMoveDescrip = 'This move is illegal because the new location suggested already contains a piece belonging to the current player. Please try again';
          return false;
        }
      }
      else{
        illegalMove = true;
        illegalMoveDescrip = 'This move is not legal because the piece entered does not belong to the current player. Please try again';
        return false;
      }
    }
    else{
      illegalMove = true;
      illegalMoveDescrip = 'This move is not legal because the location entered does not exist. Please try again';
      return false;
    }
  }
  else{
    illegalMove = true;
    illegalMoveDescrip = 'This move is not legal because the piece entered does not exist. Please try again';
    return false;
  }
}
