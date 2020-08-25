# Super Sudoku Solver

## DESCRIPTION
This sudoku solver uses both bifurcation and non-bifurcation algorithms to quickly solve any sudoku puzzles, regardless of how "evil" they may be...

## MOTIVATION
This project is for a high school independent study computer science class in discrete mathematics and functional programming. It comes from the Chapter 4 extended example section of Thomas VanDrunen's *Discrete Mathematics and Functional Programming* textbook. 

This project emphasizes recursion, user-defined data types, and bifurcation in Standard ML.

## INSTALLATION
Download SuperSudokuSolver.sml and open it using a SML IDE such as Notepad++ or Sublime Text. To execute code online, https://www.tutorialspoint.com/execute_smlnj_online.php would be a good option.

## USAGE
Test out the puzzle solver with a sudoku board of any level. The easy and "evil" puzzle refernced in this code comes from websudoku.com. The solver is also able to detect whether a sudoku board is impossible to solve. A board is implemented as a list of length 81 with each number slot being filled (Given) or empty (fullOpen). The sudoku board is assigned an index in the list through a row-wise traversal. 
