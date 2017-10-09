(* Sudoku *)

datatype sudokuValue = S1 | S2 | S3 | S4 | S5 | S6 | S7 
                     | S8 | S9;

datatype sudokuSpace = Given of sudokuValue | Open of sudokuValue list;

fun printValue(S1) = "1"
  | printValue(S2) = "2"
  | printValue(S3) = "3"
  | printValue(S4) = "4"
  | printValue(S5) = "5" 
  | printValue(S6) = "6"
  | printValue(S7) = "7"
  | printValue(S8) = "8" 
  | printValue(S9) = "9";

fun printSpace(Given(a)) = printValue(a)
  | printSpace(Open([a])) = printValue(a)
  | printSpace(Open([])) = "X"
  | printSpace(Open(aa)) = "_";

val fullOpen = Open([S1, S2, S3, S4, S5, S6, S7, S8, S9]);


fun printBoard(board) =
  let fun printHelper([], n) = ()
        | printHelper(a::rest, n) =
          (print(printSpace(a) ^ " ");
           if n = 80 then print("\n")
           else if n mod 27 = 26 then print("\n-----------------------\n")
           else if n mod 9 = 8 then print("\n")
           else if n mod 3 = 2 then print "| "
           else ();
           printHelper(rest, n+1));
  in
    printHelper(board, 0)
  end;

    (* from www.websudoku.com, 6/25/10. "Easy Puzzle 4,240,655,484" *)
val sample = [Given(S2), fullOpen, fullOpen, Given(S7), fullOpen, Given(S8),
              fullOpen, Given(S1), Given(S3),
              fullOpen, Given(S7), Given(S3), fullOpen, fullOpen, fullOpen,
              fullOpen, Given(S5), fullOpen,
              Given(S6), fullOpen, fullOpen, Given(S2), fullOpen, Given(S3),
              Given(S4), fullOpen, fullOpen,
              Given(S8), fullOpen, fullOpen, fullOpen, fullOpen, Given(S4),
              fullOpen, Given(S3), fullOpen,
              fullOpen, fullOpen, Given(S1), Given(S8), fullOpen, Given(S9),
              Given(S7), fullOpen, fullOpen,
              fullOpen, Given(S4), fullOpen, Given(S1), fullOpen, fullOpen,
              fullOpen, fullOpen, Given(S9),
              fullOpen, fullOpen, Given(S9), Given(S5), fullOpen, Given(S2),
              fullOpen, fullOpen, Given(S8),
              fullOpen, Given(S2), fullOpen, fullOpen, fullOpen, fullOpen,
              Given(S1), Given(S4), fullOpen,
              Given(S4), Given(S8), fullOpen, Given(S3), fullOpen, Given(S1),
              fullOpen, fullOpen, Given(S5)];

fun numToCoords(n) = (n mod 9, n div 9);

fun getRowMates(x, y, [], n) = []
  | getRowMates(x, y, a::rest, n) =
    if y = n div 9 andalso x <> n mod 9
    then a::getRowMates(x, y, rest, n+1)
    else getRowMates(x, y, rest, n+1);

(* Project 4.A:  getColumnMates and getSquareMates *)
fun getColumnMates(x, y, [], n) = []
  | getColumnMates(x, y, a::rest, n) =
    if y <> n div 9 andalso x = n mod 9
    then a::getColumnMates(x, y, rest, n+1)
    else getColumnMates(x, y, rest, n+1);
	
fun getSquareMates(x, y, [], n) = []
  | getSquareMates(x, y, a::rest, n) =
	let val (x1, y1) = numToCoords(n);
	in if x div 3 = x1 div 3 andalso y div 3 = y1 div 3 andalso (x <> x1 orelse y <> y1)
	   then a::getSquareMates(x, y, rest, n+1)
       else getSquareMates(x, y, rest, n+1)
	end;

(* makeList and test are functions for testing getRowMates, getColumnMates, and getSquareMates *)	

fun makeList a = if (a < 81) then a::makeList(a + 1)
				 else [];

fun test n = 
	let val valList = makeList(0);
	    val (x,y) = numToCoords(n);
	in getSquareMates(x, y, valList, 0)
	end;

fun remove(x, []) = []
  | remove(x, a::rest) = 
     if x = a then remove(x, rest) else a::remove(x, rest);

fun removeImpossible(possible, []) = possible
  | removeImpossible(possible, Given(x)::rest) = 
       removeImpossible(remove(x, possible), rest)
  | removeImpossible(possible, Open([x])::rest) =
       removeImpossible(remove(x, possible), rest)
  | removeImpossible(possible, _::rest) = removeImpossible(possible, rest);

(* For Project 4.B *)
fun oneRound(board) =
  let fun processEachPosition([], n) = []
        | processEachPosition(Given(a)::rest, n) =  Given(a) :: processEachPosition(rest, n + 1)
        | processEachPosition(Open(aa)::rest, n) = 
            let val (x, y) = numToCoords(n);
                val mates = getRowMates(x, y, board, 0) @
                            getColumnMates(x, y, board, 0) @
                            getSquareMates(x, y, board, 0);
            in 
               Open(removeImpossible(aa, mates)) :: processEachPosition(rest, n + 1)
            end;
  in 
     processEachPosition(board, 0)
  end;
 

fun attemptWithoutBifurcation(board) =
   let val board2 = oneRound(board);
   in if board = board2 then board
                        else attemptWithoutBifurcation(board2)
   end;
   
printBoard(attemptWithoutBifurcation(sample));

         (* from www.websudoku.com, 6/25/10. Evil Puzzle 4,724,921,946 *)
val evil = [Given(S2), fullOpen, Given(S6), fullOpen, Given(S5), fullOpen,
            fullOpen, Given(S7), fullOpen,
            fullOpen, fullOpen, fullOpen, fullOpen, fullOpen, Given(S6),
            fullOpen, fullOpen, fullOpen,            
            Given(S4), fullOpen, fullOpen, fullOpen, fullOpen, Given(S2),
            Given(S1), fullOpen, fullOpen,
            fullOpen, Given(S8), fullOpen, fullOpen, Given(S1), fullOpen,
            fullOpen, fullOpen, Given(S5),
            Given(S7), fullOpen, fullOpen, Given(S6), fullOpen, Given(S5),
            fullOpen, fullOpen, Given(S1),
            Given(S6), fullOpen, fullOpen, fullOpen, Given(S4), fullOpen,
            fullOpen, Given(S3), fullOpen,
            fullOpen, fullOpen, Given(S4), Given(S1), fullOpen, fullOpen,
            fullOpen, fullOpen, Given(S3),
            fullOpen, fullOpen, fullOpen, Given(S5), fullOpen, fullOpen,
            fullOpen, fullOpen, fullOpen, 
            fullOpen, Given(S1), fullOpen, fullOpen, Given(S7), fullOpen,
            Given(S6), fullOpen, Given(S8)];

(* Project 4.C: isSolved() and isImpossible() *)
fun isSolved [] = true
  | isSolved (Open[a]::rest) = isSolved(rest)
  | isSolved (Open(aa)::rest) = false
  | isSolved (x::rest) = isSolved(rest);
  
fun isImpossible [] = true
  | isImpossible(Open[a]::rest) = false
  | isImpossible(Open[]::rest) = isImpossible(rest)
  | isImpossible(x::rest) = isImpossible(rest);


(* For Project 4.D *)
fun splitAtFirstOpen([]) = ([], [], []) (* shouldn't happen *)
     (* pattern for unsolved open space *)
  | splitAtFirstOpen(Open(a::b::restOpen)::restBoard) =  ([], a::b::restOpen, restBoard)
      (* other case *)
  | splitAtFirstOpen(aa::restBoard) = 
      let val (c, d, e) = splitAtFirstOpen(restBoard)
      in
        (aa::c, d, e)
      end;



fun bifurcate(front, [], back) = []
  | bifurcate(front, a::rest, back) = 
      (front@[Open([a])]@back)::bifurcate(front, rest, back);


(* For Project 4.E *)
exception impossibleSudoku;

fun solve(board) = 
   let val fstAttempt = attemptWithoutBifurcation(board)
   in if isSolved(fstAttempt) then fstAttempt
      else if isImpossible(fstAttempt) then raise impossibleSudoku
      else 
        let fun processBifurcations([]) = []
              | processBifurcations(a::rest) =
                  let val (c, d, e) = splitAtFirstOpen(a::rest)
                      val (x::y::rest) = bifurcate(c, d, e)
                  in
                    solve (x)
                    handle impossibleSudoku => solve(y)
                  end
        in
           processBifurcations(fstAttempt)
        end
    end;

printBoard(solve(evil));
