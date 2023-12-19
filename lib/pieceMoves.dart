bool pawnMove(currentLocation, newLocation, bool firstMove, takingPiece, currentPlayer){
  bool moveLegal = false;
  // determine the horizontal and vertical value of current and new locations
  List<String> columnValues = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
  String currentcolumnLoc = currentLocation[1];
  String newcolumnLoc = newLocation[0];
  int currentrowLoc = int.parse(currentLocation[0]);
  int newrowLoc = int.parse(newLocation[1]);

  if(takingPiece == true) {
    bool continueCheck = false;
    // if player 1 is playing, then row number increase, player 2 row num decreases
    if (currentPlayer == 2) {
      if (newrowLoc == currentrowLoc + 1) {
        continueCheck = true;
      }
    }
    else {
      if (newrowLoc == currentrowLoc - 1) {
        continueCheck = true;
      }
    }
    if (continueCheck == true) {
      // for column a or h, only need to check one other column
      if (currentcolumnLoc == 'a') {
        if (newcolumnLoc == 'b') {
          moveLegal = true;
        }
      }
      else if (currentcolumnLoc == 'h') {
        if (newcolumnLoc == 'g') {
          moveLegal = true;
        }
      }
      else {
        int index = columnValues.indexOf(currentcolumnLoc);
        if (newcolumnLoc == columnValues[index - 1] ||
            newcolumnLoc == columnValues[index + 1]) {
          moveLegal = true;
        }
      }
    }
  }
  // check that the column is the same
  else if (currentcolumnLoc == newcolumnLoc) {
    // if this is the pawns first move - can move forward 1 square or 2
    if (currentPlayer == 1) {
      if (firstMove == true) {
        if (newrowLoc == currentrowLoc - 1 ||
            newrowLoc == currentrowLoc - 2) {
          moveLegal = true;
          //   NEED TO SET FIRSTMOVE AS FALSE
        }
      }
      // if this isnt the pawns first move
      else {
        if (newrowLoc == currentrowLoc - 1) {
          moveLegal = true;
        }
      }
    }
    // if player 2 is moving their piece, then the row number decreases rather than increases.
    else{
      if (firstMove == true) {
        if (newrowLoc == currentrowLoc + 1 ||
            newrowLoc == currentrowLoc + 2) {
          moveLegal = true;
          //   NEED TO SET FIRSTMOVE AS FALSE
        }
      }
      else {
        if (newrowLoc == currentrowLoc + 1) {
          moveLegal = true;
        }
      }
    }
  }
  if(newrowLoc == 8 || newrowLoc == 1){
    //   automatically sets the new piece as a queen - just to avoid overcomplication
    //   replace current pawn with new queen piece in box
  }
  return moveLegal;
}

bool kingMove(currentLoc, newLoc){
  bool moveLegal = false;
  List<String> columnValues = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
  String currentcolumnLoc = currentLoc[1];
  String newcolumnLoc = newLoc[0];
  int currentrowLoc = int.parse(currentLoc[0]);
  int newrowLoc = int.parse(newLoc[1]);

  // check for each possible move - up,down,left,right,diagonals
  if(newrowLoc == currentrowLoc + 1){
    // means that the piece is moving up by 1 square, or diagonally up left/right
    if(currentcolumnLoc == newcolumnLoc || columnValues.indexOf(currentcolumnLoc) == columnValues.indexOf(newcolumnLoc)-1 || columnValues.indexOf(currentcolumnLoc) == columnValues.indexOf(newcolumnLoc)+1){
      moveLegal = true;
    }
  }
  if(newrowLoc == currentrowLoc - 1){
    // means that the piece is moving down by 1 square, or diagonally up left/right
    if(currentcolumnLoc == newcolumnLoc || columnValues.indexOf(currentcolumnLoc) == columnValues.indexOf(newcolumnLoc)-1 || columnValues.indexOf(currentcolumnLoc) == columnValues.indexOf(newcolumnLoc)+1){
      moveLegal = true;
    }
  }
  if(newrowLoc == currentrowLoc && (columnValues.indexOf(currentcolumnLoc) == columnValues.indexOf(newcolumnLoc)-1 || columnValues.indexOf(currentcolumnLoc) == columnValues.indexOf(newcolumnLoc)+1)){
    moveLegal = true;
  }

  return moveLegal;
}

bool bishopMove(currentLoc, newLoc){
  bool moveLegal = false;

  List<String> columnValues = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
  String currentcolumnLoc = currentLoc[1];
  String newcolumnLoc = newLoc[0];
  int currentrowLoc = int.parse(currentLoc[0]);
  int newrowLoc = int.parse(newLoc[1]);

  // find out whether the row and column values have changed
  bool rowChange = false;
  bool columnChange = false;
  if(currentrowLoc != newrowLoc){
    rowChange = true;
  }
  if(currentcolumnLoc != newcolumnLoc){
    columnChange = true;
  }

  int rowIndex = 0;
  int columnIndex = 0;
  if(columnChange == true && rowChange == true){
    // translating the column names (A,B,C etc) to numbers so they can be compared easily
    int currentColAsNum = columnValues.indexOf(currentcolumnLoc);
    int newColAsNum = columnValues.indexOf(newcolumnLoc);
    // Comparing the current and new row and column values, to crease an index for each
    if(currentrowLoc > newrowLoc){
      rowIndex = currentrowLoc - newrowLoc;
    }
    else{
      rowIndex = newrowLoc - currentrowLoc;
    }
    if(currentColAsNum > newColAsNum){
      columnIndex = currentColAsNum - newColAsNum;
    }
    else{
      columnIndex = newColAsNum - currentColAsNum;
    }
    // if both row and column have changed by the saem value, the piece must have moved diagonal, so the move is legal
    if(rowIndex == columnIndex){
      moveLegal = true;
    }
  }

  return moveLegal;
}

bool knightMove(currentLoc, newLoc){
  bool legalMove = false;
  Map<String, int> columnValuesMap = {'a': 1, 'b':2, 'c':3, 'd':4, 'e':5, 'f':6, 'g':7, 'h':8};
  String currentcolumnLoc = currentLoc[1];
  String newcolumnLoc = newLoc[0];
  int currentrowLoc = int.parse(currentLoc[0]);
  int newrowLoc = int.parse(newLoc[1]);

  int? currentColumnLocNum = columnValuesMap[currentcolumnLoc];
  int? newColumnLocNum = columnValuesMap[newcolumnLoc];

  if(currentrowLoc+1 == newrowLoc || currentrowLoc-1 == newrowLoc){
    if(newColumnLocNum == currentColumnLocNum!+2 || newColumnLocNum == currentColumnLocNum-2){
      legalMove = true;
    }
  }
  else if(newColumnLocNum == currentColumnLocNum!+1 || newColumnLocNum == currentColumnLocNum-1){
    if(currentrowLoc+2 == newrowLoc || currentrowLoc-2 == newrowLoc){
      legalMove = true;
    }
  }

  return legalMove;
}

bool queenMove(currentLoc, newLoc){
  bool moveLegal = false;
  bool rook = false;
  bool bishop = false;

  rook = rookMove(currentLoc, newLoc);
  bishop = bishopMove(currentLoc, newLoc);

  if(rook == true || bishop == true){
    moveLegal = true;
  }
  print(moveLegal);
  return moveLegal;
}

bool rookMove(currentLoc, newLoc){
  bool legalMove = false;
  String currentcolumnLoc = currentLoc[1];
  String newcolumnLoc = newLoc[0];
  int currentrowLoc = int.parse(currentLoc[0]);
  int newrowLoc = int.parse(newLoc[1]);

  bool colChange = false;
  bool rowChange = false;

  if(currentrowLoc != newrowLoc){
    rowChange = true;
  }
  if(currentcolumnLoc != newcolumnLoc){
    colChange = true;
  }

  if(colChange == true && rowChange == false || rowChange == true && colChange == false){
    legalMove = true;
  }
  return legalMove;
}

