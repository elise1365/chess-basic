# Chess in flutter

Basic 2 player chess game in flutter & dart.

Displays a 8x8 chess board with all the piece id names e.g., 1Pa means player 1's pawn A.

Players take turns to enter a piece name and location (e.g., 1Pa e4) into a textField and the program checks the move, and (if its legal) moves the piece. 

## To install and run this project
1. Clone the repository
2. Navigate to the chess file - "cd chess-basic" => "cd chess"
3. Run this: "flutter run -d chrome"

## Further info

Features: 

  - Light mode and dark mode toggle switch
  - Navigation rail with icons to navigate between a help & rules page and the main chess board page
  - Reset button so that the game can be reset anytime
  - Text field for users to enter moves and check button to check each entered move
  - Text displaying the number of pieces each player owns, and text displaying which player is currently playing
  - Program utilises hive database - one database per player, stores pieces, first move & locations


Due to time constraints, the project has the following limitations:

  - Can't use en passant,
  - Castling doesn't exist
  - The program doesn't let you know when you're in check
  - Pawns are automatically assigned as queens when they reach the other side of the board
  - Typing in a piece name and location isn't the most efficient way to play chess, drag and drop would be preferable
  - Knights cannot jump over other pieces on the board. 
