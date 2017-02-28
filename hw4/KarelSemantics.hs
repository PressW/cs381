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
stmt Shutdown   _ _ r = Done r
stmt Move       _ _ _ = undefined
stmt PickBeeper _ w r = let p = getPos r
                        in if hasBeeper p w
                              then OK (decBeeper p w) (incBag r)
                              else Error ("No beeper to pick at: " ++ show p)
stmt PutBeeper  _ _ _ = undefined
stmt Turn       _ _ _ = undefined
stmt Block      _ _ _ = undefined
stmt Block      _ _ _ = undefined
stmt If         _ _ _ = undefined
stmt Call       _ _ _ = undefined
stmt Iterate    _ _ _ = undefined
stmt While      _ _ _ = undefined
    
    
    
-- | Run a Karel program.
prog :: Prog -> World -> Robot -> Result
prog (m,s) w r = stmt s m w r
