import 'package:chess/p1pieces.dart';
import 'package:chess/p2pieces.dart';
import 'main.dart';

bool pawnMove(currentLocation, newLocation, bool firstMove, takingPiece, currentPlayer){
  bool moveLegal = false;
  // determine the horizontal and vertical value of current and new locations
  List<String> columnValues = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
  String currentcolumnLoc = currentLocation[1];
  String newcolumnLoc = newLocation[0];
  int currentrowLoc = int.parse(currentLocation[0]);
  int newrowLoc = int.parse(newLocation[1]);

  // if the pawn is taking a piece, it moves diagonally rather than vertically
  if(takingPiece == true) {
    // continueCheck variable indicates whether the row number has changed by 1
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
    // if row has changed by 1, check if column has changed by 1
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
      // else need to check whether new column is column on left or right compared to current location
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
          if(newrowLoc == currentrowLoc - 2){
            String previousLocation = ((newrowLoc+1).toString())+newcolumnLoc;
            if(checkSpaceForPiece(previousLocation) == true){
              moveLegal = true;
            }
          }
          else{
            moveLegal = true;
          }
        }
      }
      // if this isnt the pawns first move, can only move forward 1 square
      else {
        if (newrowLoc == currentrowLoc - 1) {
          moveLegal = true;
        }
      }
    }
    // if player 2 is moving their piece, then the row number increases rather than decreases.
    else{
      if (firstMove == true) {
        if (newrowLoc == currentrowLoc + 1 ||
            newrowLoc == currentrowLoc + 2) {
          if(newrowLoc == currentrowLoc + 2){
            String previousLocation = ((newrowLoc-1).toString())+newcolumnLoc;
            if(checkSpaceForPiece(previousLocation) == true){
              moveLegal = true;
            }
          }
          else{
            moveLegal = true;
          }
        }
      }
      else {
        if (newrowLoc == currentrowLoc + 1) {
          moveLegal = true;
        }
      }
    }
  }

  // when the pawn reaches the other side of the board it automatically becomes a queen
  if(newrowLoc == 8 || newrowLoc == 1){
    // get piece name
    List <String> inputList = inputText.split(" ");
    String pieceName = inputList[0];
    String newPieceName = inputText[0] + 'Q';

    // if player = 1
    if(inputText[0] == '1'){
      // add a new queen piece to P1box
      newPieceName += columnValues[p1NewQueenPieces];
      p1NewQueenPieces += 1;
      P1box.delete(pieceName);
      p1 newItem = p1(newPieceName, newLocation[1] + newLocation[0], 'false',);
      P1box.put(newPieceName, newItem);
    }
    else{
      newPieceName += columnValues[p2NewQueenPieces];
      p2NewQueenPieces += 1;
      P2box.delete(pieceName);
      p2 newItem = p2(newPieceName, newLocation[1] + newLocation[0], 'false',);
      P2box.put(newPieceName, newItem);
    }
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
  // checks if the piece is moving left or right by 1 square
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

  bool columnIncreasing = false;
  bool rowIncreasing = false;

  // Rest of this function is checking for a clear path between current and new location
  int rowIndex = 0;
  int columnIndex = 0;
  // if both column and row have changed, then the piece is going diagonally
  if(columnChange == true && rowChange == true){
    // translating the column names (A,B,C etc) to numbers so they can be compared easily
    int currentColAsNum = columnValues.indexOf(currentcolumnLoc);
    int newColAsNum = columnValues.indexOf(newcolumnLoc);
    // Comparing the current and new row and column values, to create an index for each - basically how many squares between current and new location
    if(currentrowLoc > newrowLoc){
      rowIndex = currentrowLoc - newrowLoc;
    }
    else{
      rowIncreasing = true;
      rowIndex = newrowLoc - currentrowLoc;
    }
    if(currentColAsNum > newColAsNum){
      columnIndex = currentColAsNum - newColAsNum;
    }
    else{
      columnIncreasing = true;
      columnIndex = newColAsNum - currentColAsNum;
    }

    // if both row and column have changed by the same value, the piece must have moved diagonal, so the move is legal (as long as path is clear)
    if(rowIndex == columnIndex){
      // if player is only moving 1 space, this space has already been checked if its empty, done in checkMove, so no need to check again
      if(rowIndex == 1){
        moveLegal = true;
      }
      else if(columnIncreasing == true){
        if(rowIncreasing == true){
          // means that both the column and row are increasing, this piece is moving diagonally downwards on the board from left to right
          for(int i=1;i<rowIndex;i++){
            String location = (currentrowLoc +i).toString() + columnValues[currentColAsNum+i];
            if(i==rowIndex-1 && checkSpaceForPiece(location) == true){
              // means that we've gone through every space (apart from the last space before the new location) from previous location to current location and all the spaces are clear
              moveLegal = true;
            }
            else{
              // if i!=rowindex-1 this means we need to check a space
              if(checkSpaceForPiece(location) == false){
                // if the space is full, exit the for loop and the move is illegal
                break;
              }
            }
          }
        }
        // this is for pieces moving right and up
        else{
          for(int i=1;i<rowIndex;i++){
            String location = (currentrowLoc -i).toString() + columnValues[currentColAsNum+i];
            if(i==rowIndex-1 && checkSpaceForPiece(location) == true){
              moveLegal = true;
            }
            else{
              if(checkSpaceForPiece(location) == false){
                break;
              }
            }
          }
        }
      }
      // for pieces moving left
      else{
        if(rowIncreasing == true){
          // pieces moving left and down
          for(int i=1;i<rowIndex;i++){
            String location = (currentrowLoc +i).toString() + columnValues[currentColAsNum-i];
            if(i==rowIndex-1 && checkSpaceForPiece(location) == true){
              // means that we've gone through every space (apart from the last space before the new location) from previous location to current location and all the spaces are clear
              moveLegal = true;
            }
            else{
              // if i!=rowindex-1 this means we need to check a space
              if(checkSpaceForPiece(location) == false){
                // if the space is full, exit the for loop and the move is illegal
                break;
              }
            }
          }
        }
        else{
          // this is for pieces moving left and up
          for(int i=1;i<rowIndex;i++){
            String location = (currentrowLoc -i).toString() + columnValues[currentColAsNum-i];
            if(i==rowIndex-1 && checkSpaceForPiece(location) == true){
              moveLegal = true;
            }
            else{
              if(checkSpaceForPiece(location) == false){
                break;
              }
            }
          }
        }
      }
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

  List<String> columnValues = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

  int? currentColumnLocNum = columnValuesMap[currentcolumnLoc];
  int? newColumnLocNum = columnValuesMap[newcolumnLoc];

  // if row has changed by 1 and column has changed by 2, need to check the columns path
  if(currentrowLoc+1 == newrowLoc || currentrowLoc-1 == newrowLoc){
    if(newColumnLocNum == currentColumnLocNum!+2 || newColumnLocNum == currentColumnLocNum-2){
      // check if the path from previous location to new location is empty
      // determine if the column change was to the left or right
      if(newColumnLocNum == currentColumnLocNum-2){
        // column change to the left
        // only need to check 2 squares
        for(int i=0;i<2;i++){
          int index = currentColumnLocNum - (i+2);
          String location = currentrowLoc.toString() + columnValues[index];
          if(i==1 && checkSpaceForPiece(location) == true){
            legalMove = true;
          }
          else{
            if(checkSpaceForPiece(location) == false){
              break;
            }
          }
        }
      }
      else{
        // column change to the right
        for(int i=0;i<2;i++){
          int index = currentColumnLocNum + i;
          print(index);
          String location = currentrowLoc.toString() + columnValues[index];
          if(i==1 && checkSpaceForPiece(location) == true){
            legalMove = true;
          }
          else{
            if(checkSpaceForPiece(location) == false){
              break;
            }
          }
        }
      }
    }
  }
  // column changes by 1 and row changes by 2 - so need to check row path
  else if(newColumnLocNum == currentColumnLocNum!+1 || newColumnLocNum == currentColumnLocNum-1){
    if(currentrowLoc+2 == newrowLoc || currentrowLoc-2 == newrowLoc){
      if(newrowLoc == currentrowLoc-2){
        // column change to the  left
        for(int i=0;i<2;i++){
          String location = (currentrowLoc-(i+1)).toString() + currentcolumnLoc;
          if(i==1 && checkSpaceForPiece(location) == true){
            legalMove = true;
          }
          else{
            if(checkSpaceForPiece(location) == false){
              break;
            }
          }
        }
      }
      else{
        // column change to the right
        for(int i=0;i<2;i++){
          String location = (currentrowLoc+(i+1)).toString() + currentcolumnLoc;
          if(i==1 && checkSpaceForPiece(location) == true){
            legalMove = true;
          }
          else{
            if(checkSpaceForPiece(location) == false){
              break;
            }
          }
        }
      }
    }
  }
  return legalMove;
}

bool queenMove(currentLoc, newLoc){
  // queen can make the same moves as bishop and rook, so just use already generated code for those pieces
  bool moveLegal = false;
  bool rook = false;
  bool bishop = false;

  rook = rookMove(currentLoc, newLoc);
  bishop = bishopMove(currentLoc, newLoc);

  if(rook == true || bishop == true){
    moveLegal = true;
  }
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

  List<String> columnValues = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
  bool colIncreasing = false;
  bool rowIncreasing = false;
  int currentColAsNum = columnValues.indexOf(currentcolumnLoc);
  int newColAsNum = columnValues.indexOf(newcolumnLoc);

  if(currentrowLoc != newrowLoc){
    rowChange = true;
    // determining whether the piece is moving up or down
    // rowIncreasing = true means the piece is moving down
    if(currentrowLoc < newrowLoc){
      rowIncreasing = true;
    }
  }
  if(currentcolumnLoc != newcolumnLoc){
    colChange = true;
    // this is in preparation for checking the path from current to new location
    // determining whether the piece is moving left or right - colIncreasing = true means the piece is moving right
    if(currentColAsNum < newColAsNum){
      colIncreasing = true;
    }
  }

  // checking that the path is clear
  if(colChange == true && rowChange == false || rowChange == true && colChange == false) {
    if (colChange == true) {
      // determine whether the column is increasing or decreasing (the piece is moving left or right)
      if (colIncreasing) {
        int numOfColChanges = newColAsNum - currentColAsNum;
        // if the piece is only moving 1 piece, no need to check the path as the new location has already been checked.
        if (numOfColChanges == 1) {
          legalMove = true;
        }
        else {
          for (int i = 0; i < numOfColChanges - 1; i++) {
            String location = currentrowLoc.toString() +
                columnValues[currentColAsNum + (i + 1)];
            if (checkSpaceForPiece(location) == true) {
              if (i == (numOfColChanges - 2)) {
                legalMove = true;
              }
            }
            else {
              break;
            }
          }
        }
      }
      else {
        int numOfColChanges = currentColAsNum - newColAsNum;
        if (numOfColChanges == 1) {
          legalMove = true;
        }
        else {
          for (int i = 0; i < numOfColChanges - 1; i++) {
            String location = currentrowLoc.toString() +
                columnValues[currentColAsNum - (i + 1)];
            if (checkSpaceForPiece(location) == true) {
              if (i == (numOfColChanges - 2)) {
                legalMove = true;
              }
            }
            else {
              break;
            }
          }
        }
      }
    }
    else {
      if (rowIncreasing == true) {
        int numOfRowsChanging = newrowLoc - currentrowLoc;
        if (numOfRowsChanging == 1) {
          legalMove = true;
        }
        else {
          for (int i = 0; i < numOfRowsChanging - 1; i++) {
            String location = (currentrowLoc + (i+1)).toString() + currentcolumnLoc;
            if(checkSpaceForPiece(location) == true){
              if(i == numOfRowsChanging - 2){
                legalMove = true;
              }
            }
            else{
              break;
            }
          }
        }
      }
      else{
        int numOfRowsChanging = currentrowLoc - newrowLoc;
        if (numOfRowsChanging == 1) {
          legalMove = true;
        }
        else {
          for (int i = 0; i < numOfRowsChanging - 1; i++) {
            String location = (currentrowLoc - (i+1)).toString() + currentcolumnLoc;
            if(checkSpaceForPiece(location) == true){
              if(i == numOfRowsChanging - 2){
                legalMove = true;
              }
            }
            else{
              break;
            }
          }
        }
      }
    }
  }
  return legalMove;
}

// iteration of a function in movePiece, but checks both boxes, this function is used when checking the path between current location and new location is clear
bool checkSpaceForPiece(String location){
  bool spaceEmpty = true;

  for(int i=0;i<P1box.length;i++){
    if(P1box.getAt(i)?.location == location){
      spaceEmpty = false;
    }
  }

  for(int i=0;i<P2box.length;i++){
    if(P2box.getAt(i)?.location == location){
      spaceEmpty = false;
    }
  }

  return spaceEmpty;
}
