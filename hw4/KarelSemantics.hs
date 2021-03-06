-- Luay Alshawi: alshawil
-- Preston Wipf: wipfp

module KarelSemantics where

import Prelude hiding (Either(..))
import Data.Function (fix)

import KarelSyntax
import KarelState


-- | Valuation function for Test.
test :: Test -> World -> Robot -> Bool
test (Not tst)     w r = not (test tst w r)
test (Facing crd)  _ r = crd == getFacing r
test (Clear dir)   w r = isClear (relativePos dir r) w
test (Beeper)      w r = hasBeeper (getPos r) w
test (Empty)       _ r = isEmpty r



-- | Valuation function for Stmt.
stmt :: Stmt -> Defs -> World -> Robot -> Result
-- end the program
stmt Shutdown        _ _ r = Done r
-- move forward
stmt Move            _ w r = let p = relativePos Front r
                             in if isClear p w
                                    then OK w (setPos p r)
                                    else Error ("Blocked at: " ++ show p)
-- take a beeper
stmt PickBeeper      _ w r = let p = getPos r
                             in if hasBeeper p w
                                    then OK (decBeeper p w) (incBag r)
                                    else Error ("No beeper to pick at: " ++ show p )
-- leave a beeper
stmt PutBeeper       _ w r = let p = getPos r
                             in if isEmpty r
                                    then Error ("No beeper to put.")
                                    else OK (incBeeper p w) (decBag r)
-- rotate in place
stmt (Turn dir)      _ w r = OK w (setFacing (cardTurn dir (getFacing r)) r)
-- invoke a macro
stmt (Call m)        d w r = case lookup m d of
                                    (Just mac) -> stmt mac d w r
                                    _         -> Error ("Undefined macro: " ++ m)
-- fixed repetition loop
stmt (Iterate i mac) d w r = if i > 0
                                 then case stmt mac d w r of
                                            (OK w' r') -> stmt (Iterate (i-1) mac) d w' r'
                                            (Done r')  -> Done r'
                                            (Error m)  -> Error m
                                 else OK w r
-- conditional branch
stmt (If tst t e)    d w r = if test tst w r
                                 then stmt t d w r
                                 else stmt e d w r
-- conditional loop
stmt (While tst s) d w r = if test tst w r
                                 then case stmt s d w r of
                                   (OK w' r') -> stmt (While tst s) d w' r'  -- recursive stmt call
                                   (Done r')  -> Done r'                  -- bubble up shutdown
                                   (Error m)  -> Error m                  -- raise error
                           else OK w r
-- empty statement block
stmt (Block [])      d w r = OK w r
-- non-empty statement block
stmt (Block (s:ss))  d w r = case stmt s d w r of
                                   (OK w' r') -> stmt (Block ss) d w' r'  -- recursive stmt call
                                   (Done r')  -> Done r'                  -- bubble up shutdown
                                   (Error m)  -> Error m                  -- raise error



-- | Run a Karel program.
prog :: Prog -> World -> Robot -> Result
prog (m,s) w r = stmt s m w r
