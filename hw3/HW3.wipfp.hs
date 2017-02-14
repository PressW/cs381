-- Luay Alshawi: alshawil
-- Preston Wipf: wipfp

module HW3 where

import MiniMiniLogo
import Render


--
-- * Semantics of MiniMiniLogo
--

-- NOTE:
--   * MiniMiniLogo.hs defines the abstract syntax of MiniMiniLogo and some
--     functions for generating MiniMiniLogo programs. It contains the type
--     definitions for Mode, Cmd, and Prog.
--   * Render.hs contains code for rendering the output of a MiniMiniLogo
--     program in HTML5. It contains the types definitions for Point and Line.

-- | A type to represent the current state of the pen.
type State = (Mode,Point)

-- | The initial state of the pen.
start :: State
start = (Up,(0,0))

-- | A function that renders the image to HTML. Only works after you have
--   implemented `prog`. Applying `draw` to a MiniMiniLogo program will
--   produce an HTML file named MiniMiniLogo.html, which you can load in
--   your browswer to view the rendered image.
draw :: Prog -> IO ()
draw p = let (_,ls) = prog p start in toHTML ls


-- Semantic domains:
--   * Cmd:  State -> (State, Maybe Line)
--   * Prog: State -> (State, [Line])


-- | Semantic function for Cmd.
--   
--   >>> cmd (Pen Down) (Up,(2,3))
--   ((Down,(2,3)),Nothing)
--
--   >>> cmd (Pen Up) (Down,(2,3))
--   ((Up,(2,3)),Nothing)
--
--   >>> cmd (Move 4 5) (Up,(2,3))
--   ((Up,(4,5)),Nothing)
--
--   >>> cmd (Move 4 5) (Down,(2,3))
--   ((Down,(4,5)),Just ((2,3),(4,5)))
--
cmd :: Cmd -> State -> (State, Maybe Line)
cmd (Pen x)    = \(mode,point) -> ((x,point), Nothing)
cmd (Move x y) = \(mode,point) -> if mode == Down then
                                    ((mode,(x,y)), Just (point,(x,y)))
                                  else
                                    ((mode,(x,y)), Nothing)


-- | Semantic function for Prog.
--
--   >>> prog (nix 10 10 5 7) start
--   ((Down,(15,10)),[((10,10),(15,17)),((10,17),(15,10))])
--
--   >>> prog (steps 2 0 0) start
--   ((Down,(2,2)),[((0,0),(0,1)),((0,1),(1,1)),((1,1),(1,2)),((1,2),(2,2))])
prog :: Prog -> State -> (State, [Line])
prog [] state        = (state,[])
prog (p:progs) state = case cmd p state of
                       (_s, Just line) -> (\(state,progs) -> (state, line:progs)) $ prog progs _s
                       (_s, Nothing)   -> prog progs _s


--
-- * Extra credit
--

-- | This should be a MiniMiniLogo program that draws an amazing picture.
--   Add as many helper functions as you want.
amazing :: Prog
amazing = (leftTowers 0 0 ++ midTowers 0 0 ++ rightTowers 0 0)


-- | Left Side of Skyline
leftTowers :: Int -> Int -> Prog
leftTowers x y = [Pen Up, Move 3 19, Pen Down, Move 3 38, Move 10 50, Move 15 42, Pen Up, Move 12 20, Pen Down, Move 5 34,
                  Pen Up, Move 16 24, Pen Down, Move 16 39, Move 17 39, Move 17 40, Move 19 40, Move 22 45, Move 25 40,
                  Pen Up, Move 22 38, Pen Down, Move 27 38, Move 27 29, Pen Up, Move 28 30, Pen Down, Move 35 30, Move 35 25,
                  Pen Up, Move 34 24, Pen Down, Move 40 24, Move 40 19, Pen Up, Move 37 25, Pen Down, Move 37 27, Move 41 27,
                  Pen Up, Move 38 28, Pen Down, Move 38 32, Move 42 32]


-- | Middle of Skyline
midTowers :: Int -> Int -> Prog
midTowers x y = [Pen Up, Move 42 15, Pen Down, Move 42 41, Move 53 41, Pen Up, Move 49 22, Pen Down, Move 49 40, Pen Up,
                 Move 49 41, Pen Down, Move 49 45, Move 52 45, 
                 Pen Up, Move 55 4, Pen Down, Move 55 39, Pen Up, Move 57 37, Pen Down, Move 57 18, Pen Up, Move 59 7, 
                 Pen Down, Move 59 41, Pen Up, Move 61 41, Pen Down, Move 61 21, Pen Up, Move 65 41, Pen Down, Move 65 22,
                 Pen Up, Move 70 39, Pen Down, Move 70 65, Move 65 66, Move 65 55, Pen Up, Move 69 65, Pen Down, Move 69 69,
                 Move 67 69, Pen Up, Move 68 69, Pen Down, Move 68 70, Move 64 71, Move 58 71, Move 58 69, Pen Up, Move 61 69,
                 Pen Down, Move 57 69, Move 57 65, Pen Up, Move 62 65, Pen Down, Move 55 65, Move 55 54,
                 Pen Up, Move 55 41, Pen Down, Move 51 47, Move 57 54, Pen Up, Move 62 41, Pen Down, Move 65 46, Move 61 52,
                 Pen Up, Move 58 54, Pen Down, Move 58 62, Pen Up, Move 59 53, Pen Down, Move 59 57,
                 Pen Up, Move 62 0, Pen Down, Move 61 11]


-- | Right Side of Skyline
rightTowers :: Int -> Int -> Prog
rightTowers x y = [Pen Up, Move 70 52, Pen Down, Move 77 52, Move 85 51, Move 85 34, Pen Up, Move 72 52, Pen Down, Move 72 55,
                   Move 77 55, Move 83 54, Move 83 52, Pen Up, Move 77 55, Pen Down, Move 77 53, Pen Up, Move 77 51, Pen Down, 
                   Move 77 38, 
                   Pen Up, Move 85 45, Pen Down, Move 89 45, Move 97 44, Move 97 36, Pen Up, Move 89 44, Pen Down, Move 89 37,
                   Pen Up, Move 81 18, Pen Down, Move 81 34, Move 89 34, Move 99 33, Move 99 26, Pen Up, Move 89 33, Pen Down,
                   Move 89 13,
                   Pen Up, Move 94 15, Pen Down, Move 94 25, Move 107 25, Move 107 15, Pen Up, Move 99 10, Pen Down, Move 99 20,
                   Pen Up, Move 101 21, Pen Down, Move 106 21, Pen Up, Move 103 24, Pen Down, Move 99 21, Move 95 21,
                   Pen Up, Move 108 8, Pen Down, Move 108 19, Move 116 19, Move 128 18, Move 128 12, Pen Up, Move 110 19, Pen Down,
                   Move 110 22, Move 116 22, Move 126 21, Move 126 20, Pen Up, Move 116 19, Pen Down, Move 116 15,
                   Pen Up, Move 131 13, Pen Down, Move 131 25, Move 122 26, Move 122 23,
                   Pen Up, Move 104 28, Pen Down, Move 104 41, Move 110 41, Pen Up, Move 106 41, Pen Down, Move 106 43, Move 111 43,
                   Pen Up, Move 111 34, Pen Down, Move 111 46, Move 118 46, Move 125 45, Move 125 30, Pen Up, Move 118 34, Pen Down,
                   Move 118 44]