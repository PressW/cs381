-- Luay Alshawi: alshawil
-- Preston Wipf: wipfp


module MiniLogo where
import Data.List
import Prelude

type Var   = String
type Macro = String
type Prog  = [Cmd]

data Mode  = Up
           | Down
           deriving (Show, Eq)

data Expr  = Ref Var
           | Val Int
           | Add Expr Expr
           deriving (Show, Eq)

data Cmd   = Pen Mode
           | Move (Expr, Expr)
           | Define Macro [Var] Prog
           | Call Macro [Expr]
           deriving (Show, Eq)


-- Problem 2:
-- Define a MiniLogo macro line (x1,y1,x2,y2) that (starting from anywhere on the canvas) draws a line segment
-- from (x1,y1) to (x2,y2).
--
--  define line (x1,y1,x2,y2) {
--     pen up;
--     move (x1,y1);
--     pen down;
--     move (x2,y2);
--     pen up;
--  }

line = Define "line" ["x1", "y1", "x2", "y2"]
                     [Pen Up, Move (Ref "x1", Ref "y1"), Pen Down, Move (Ref "x2", Ref "y2"), Pen Up]





-- Problem 3:
-- Use the line macro you just defined to define a new MiniLogo macro nix (x,y,w,h) that draws a big “X” of
-- width w and height h, starting from position (x,y). Your definition should not contain any move commands.

-- define nix(x,y,w,h)
-- {
--   line (x,y,x+w,y+h),
--   line (x+w,y,x,y+h)
-- }
nix = Define "nix" ["x", "y", "w", "h"] [
      Call "line" [Ref "x", Ref "y", Add (Ref "x") (Ref "w"), Add (Ref "y") (Ref "h") ],
      Call "line" [Add (Ref "x") (Ref "w"), Ref "y", Ref "x", Add (Ref "y") (Ref "h") ] ]





-- Problem 4:
-- Define a Haskell function steps :: Int -> Prog that constructs a MiniLogo program that draws a staircase
-- of n steps starting from (0,0). Below is a visual illustration of what the generated program should draw
-- for a couple different applications of steps.

steps :: Int -> Prog
steps 0 = []
steps n = [Call "line" [Val n, Val n, Val (n - 1), Val n],
           Call "line" [Val (n - 1), Val n, Val (n - 1), Val (n - 1)]] ++ steps (n - 1)





-- Problem 5:
-- Define a Haskell function macros :: Prog -> [Macro] that returns a list of the names of all of the
-- macros that are defined anywhere in a given MiniLogo program. Don’t worry about duplicates—if a macro
-- is defined more than once, the resulting list may include multiple copies of its name.

macros :: Prog -> [Macro]
macros []     = []
macros (x:xs) = case x of
    Define m _ _ -> m:macros xs
    otherwise    -> macros xs





-- Problem 6:
-- Define a Haskell function pretty :: Prog -> String that pretty-prints a MiniLogo program. That is, it
-- transforms the abstract syntax (a Haskell value) into nicely formatted concrete syntax (a string of
-- characters). Your pretty-printed program should look similar to the example programs given above;
-- however, for simplicity you will probably want to print just one command per line.

pretty :: Prog -> String
pretty []                      = ""
pretty (Pen Up:xs)             = "\n  pen up; " ++ pretty xs
pretty (Pen Down:xs)           = "\n  pen down; " ++ pretty xs
pretty (Move (l, r):xs)        = "move (" ++ prettyExpr l ++ ", " ++ prettyExpr r ++ "); " ++ pretty xs
pretty (Call n vars:xs)        = "\n  " ++ n ++ "(" ++ intercalate ", " (map prettyExpr vars) ++ ");" ++ pretty xs
pretty (Define m vars prog:xs) = "define " ++ m ++ "(" ++ intercalate ", " vars ++ "){" ++ pretty prog ++ "\n};\n" ++ pretty xs

prettyExpr :: Expr -> String
prettyExpr (Val num) = show num
prettyExpr (Ref str) = str
prettyExpr (Add l r) = prettyExpr l ++ " + " ++ prettyExpr r

-- Another way for pretty print
-- pretty :: Prog -> String
-- pretty []      = ""
-- pretty (cmd: progs) = prettyC cmd ++ pretty progs
--
-- prettyC :: Cmd -> String
-- prettyC (Pen Up) = "pen up;"
-- prettyC (Pen Down) = "pen down;"
-- prettyC (Move exb1 exb2) = "move ( " ++
--                            prettyExpr exb1 ++
--                            ", " ++
--                            prettyExpr exb2 ++
--                            ");"
-- prettyC (Define m v p)   = "define " ++
--                             m ++
--                             "(" ++
--                             prettyV v ++
--                             "){" ++
--                             pretty p ++
--                             "};"
-- prettyC (Call m expr) = "call " ++ m ++
--                         "(" ++
--                         concat (intersperse "," (map prettyExpr expr)) ++
--                         ");"
-- prettyExpr :: Expr -> String
-- prettyExpr (Ref var) = var
-- prettyExpr (Num int) = show int
-- prettyExpr (Add a b) = prettyExpr a ++ "+" ++ prettyExpr b
--
-- prettyV :: [Var] -> String
-- prettyV [] = ""
-- prettyV [a] = a
-- prettyV (x:xs) = x ++ "," ++ prettyV xs





-- Problem 7:
-- Define a Haskell function optE :: Expr -> Expr that partially evaluates expressions by replacing any
-- additions of literals with the result. For example, given the expression (2+3)+x, optE should return
-- the expression 5+x.

optE :: Expr -> Expr
optE (Add (Val l) (Val r)) = Val $ l + r
optE otherwise             = otherwise





-- Problem 8:
-- Define a Haskell function optP :: Prog -> Prog that optimizes all of the expressions contained in a
-- given program using optE.

optP :: Prog -> Prog
optP []     = []
optP (x:xs) = case x of
    Move (l, r)   -> Move (optE l, optE r):optP xs
    Call  m es    -> Call m (map optE es):optP xs
    Define m vs x -> Define m vs (optP x):optP xs
    otherwise     -> x:optP xs
