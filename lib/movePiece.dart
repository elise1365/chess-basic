import 'package:chess/p1pieces.dart';
import 'package:chess/p2pieces.dart';
import 'main.dart';
import 'pieceMoves.dart';

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
    for (var key in P2box.keys) {
      var value = P2box.get(key);
        // Check if the location value = newLocation
      if (value?.location == (newLocation[1] + newLocation[0])) {
        pieceBeingTaken = true;
      }
    }
    // first move is only important if the piece is a pawn
    if(pieceName.contains('P')){
      if(P1box.get(pieceName)!.firstMove.contains("true")){
        firstMove = true;
      }
    }
  }
  else{
    // get the current location
    pieceName = pieceName.replaceAll(' ', '');
    currentLoc = P2box.get(pieceName)!.location;
    // find out if the new location contains a piece belonging to the other player
    for (var key in P1box.keys) {
      var value = P1box.get(key);
      // Check if the location value = newLocation
      if (value?.location == (newLocation[1] + newLocation[0])) {
        pieceBeingTaken = true;
      }
    }
    // check if the piece is a pawn, and if it is then check if this is the pawns first move
    if(pieceName.contains('P')){
      if(P2box.get(pieceName)!.firstMove.contains("true")){
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
        for (int i=0;i<P2box.length;i++) {
          if (P2box.get(P2box.keyAt(i))!.location == (newLocation[1] + newLocation[0])) {
            key = i;
          }
        }
        P2box.deleteAt(key);
      }
      else {
        int key = 0;
        // finding the key of the item in the list to remove.
        for (int i=0;i<P1box.length;i++) {
          if (P1box.get(P1box.keyAt(i))!.location == (newLocation[1] + newLocation[0])) {
            key = i;
          }
        }
        P1box.delete(key); // remove the piece from the players list of pieces
      }
    }
    // now change the location of the piece being moved & call the chessBoard build function etc... basically rebuild the board with the updated location
    if(player[6] == '1'){
      P1box.get(pieceName)?.location = newLocation[1] + newLocation[0];
      if(firstMove == true){
        P1box.get(pieceName)?.firstMove = "false";
      }
    }
    else{
      P2box.get(pieceName)?.location = newLocation[1] + newLocation[0];
      if(firstMove == true){
        P2box.get(pieceName)?.firstMove = "false";
      }
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
          for (var key in P1box.keys) {
            var value = P1box.get(key);
            // Check if the location value = newLocation
            if (value?.location == (newLocation[1] + newLocation[0])) {
              currentPlayerPieceAlreadyThere = true;
            }
          }
        }
        else{
          for (var key in P2box.keys) {
            var value = P2box.get(key);
            // Check if the location value = newLocation
            if (value?.location == (newLocation[1] + newLocation[0])) {
              currentPlayerPieceAlreadyThere = true;
            }
          }
        }
        if(currentPlayerPieceAlreadyThere == false){
          int spaceLocation = 0;
          for(int i=0;i<inputText.length;i++){
            if(inputText[i] == ' '){
              spaceLocation = i;
            }
          }
          // because queen and king idNames are 1 character shorter than rest of the pieces, check for them separately
          if(inputText.contains("Q")){
            return queenMove(currentLoc, newLocation);
          }
          else if(inputText.contains("K")){
            return kingMove(currentLoc, newLocation);
          }
          else{
            String piece = inputText[spaceLocation-2];
            if(piece == 'P'){
              return pawnMove(currentLoc, newLocation, firstMove, takingPiece, currentPlayer);
            }
            else if(piece == 'n'){
              return knightMove(currentLoc, newLocation);
            }
            else if(piece == 'B'){
              return bishopMove(currentLoc, newLocation);
            }
            else if(piece == 'R'){
              return rookMove(currentLoc, newLocation);
            }
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
