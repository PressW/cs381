-- Luay Alshawi: alshawil
-- Preston Wipf: wipfp





module MiniLogo where
import Prelude

type Num   = Int
type Var   = String
type Macro = String
type Prog  = [Cmd]

data Mode  = Up 
           | Down
           deriving Show

data Expr  = Var
           | Num
           | Add Expr Expr
	   deriving Show

data Cmd   = Pen Mode
           | Move Expr Expr
	   | Define Macro [Var] Prog
           | Call Macro Expr
	   deriving Show





-- Problem 2:
-- Define a MiniLogo macro line (x1,y1,x2,y2) that (starting from anywhere on the canvas) draws a line segment from (x1,y1) to (x2,y2).
--
--  define line (x1,y1,x2,y2) {
--     pen up;
--     move (x1,y1);
--     pen down;
--     move (x2,y2);
--     pen up;
--  }
--





-- Problem 3:
-- Use the line macro you just defined to define a new MiniLogo macro nix (x,y,w,h) that draws a big “X” of width w and height h, starting from position (x,y). Your definition should not contain any move commands.
--
--  define nix (x,y,w,h) {
--     pen up;
--     move (x,y);
--     pen down;
--     move (x+w,y+h);
--     pen up;
--     move (x+w,y);
--     pen down;
--     move (x,y+h);
--     pen up;
--  }





-- Probelm 4:
-- Define a Haskell function steps :: Int -> Prog that constructs a MiniLogo program that draws a staircase of n steps starting from (0,0). Below is a visual illustration of what the generated program should draw for a couple different applications of steps.
--




-- Problem 5:
-- Define a Haskell function macros :: Prog -> [Macro] that returns a list of the names of all of the macros that are defined anywhere in a given MiniLogo program. Don’t worry about duplicates—if a macro is defined more than once, the resulting list may include multiple copies of its name.





-- Problem 6:
-- Define a Haskell function pretty :: Prog -> String that pretty-prints a MiniLogo program. That is, it transforms the abstract syntax (a Haskell value) into nicely formatted concrete syntax (a string of characters). Your pretty-printed program should look similar to the example programs given above; however, for simplicity you will probably want to print just one command per line.





-- Problem 7:
-- Define a Haskell function optE :: Expr -> Expr that partially evaluates expressions by replacing any additions of literals with the result. For example, given the expression (2+3)+x, optE should return the expression 5+x.





-- Problem 8:
-- Define a Haskell function optP :: Prog -> Prog that optimizes all of the expressions contained in a given program using optE.
