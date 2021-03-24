----------------------------------------
-- maintainer: marco.haucke@tum.de
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.
----------------------------------------
module Homework2 where

import Test.QuickCheck
    ( choose, elements, vectorOf, Arbitrary(arbitrary), Gen )

type Name = String
data PyramidScheme = Recruiter Name [PyramidScheme] | Member Name
data Paycheck = Paycheck Name Float
type Paychecks = [Paycheck]

instance Show Paycheck where
    show (Paycheck name methemoney) = name ++ ": " ++ show methemoney ++ "$"

instance Show PyramidScheme where
    show scheme = undefined

memberPay :: Float
memberPay = 20.0

recruiterPay :: Float
recruiterPay = 50.0

recruiterScale :: Float
recruiterScale = 0.3

recruiterFee :: Float
recruiterFee = 150.0

memberFee :: Float
memberFee = 40.0


-- TODO
calcPayouts :: PyramidScheme -> Paychecks
calcPayouts = undefined


-- TODO
calcMonthlyRevenue :: PyramidScheme -> Float
calcMonthlyRevenue = undefined


-- TODO
calcMonthlyProfits :: PyramidScheme -> Float
calcMonthlyProfits = undefined


-- TODO
removeFromScheme :: Name -> PyramidScheme -> Maybe PyramidScheme
removeFromScheme = undefined


-- this is just a specialized mapM_ (whatever that means)!
-- you don't have to make use of it, but it could be a nice bonus ;)
mapIO_ :: (a -> IO b) -> [a] -> IO ()
mapIO_ _ [] = return ()
mapIO_ act (x:xs) = do
    act x
    mapIO_ act xs

-- EXAMPLE
example :: PyramidScheme
example = Recruiter "a" [Member "b", Member "c", 
    Recruiter "d" [Recruiter "e" [Member "f"], Member "g"] , Recruiter "h" []]

main :: IO()
main = do
    let scheme = example
    -- if you want a randomly generated scheme, uncomment below + comment above
    --scheme <- generate arbitrary 
    cmdLoop scheme


-- TODO
cmdLoop :: PyramidScheme -> IO ()
cmdLoop = undefined

---------- GENERATORS ----------

-- these are usually written for QuickCheck, but you can make
-- use of them in other ways aswell :)
instance Arbitrary PyramidScheme where
    arbitrary = choose(2,3) >>= genSchemeDepth

-- didn't do this at first and the results where frightening
genSafeChar :: Gen Char
genSafeChar = elements ['a'..'z']

-- this is crappy, but it works fine-ish, so I'm keeping it 
genSchemeDepth :: Int -> Gen PyramidScheme
genSchemeDepth 0 = getMemName
genSchemeDepth d = do
    nName <- choose (3, 6)
    name <- vectorOf nName genSafeChar
    nRecs <- choose(1, d)
    nMems <- choose(1, 3)
    subs <- vectorOf nRecs (genSchemeDepth $ pred d)
    mems <- vectorOf nMems getMemName
    return $ Recruiter name (mems ++ subs)

getMemName :: Gen PyramidScheme
getMemName = do
    nName <- choose (3, 6)
    name <- vectorOf nName genSafeChar
    return $ Member name