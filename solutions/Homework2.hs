---------------------------------------
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

import Data.List ( sortOn )
import System.IO ()
import Data.Maybe ( mapMaybe )
import Data.Ord ( Down(Down) ) 
import Test.QuickCheck
    ( choose, elements, vectorOf, Arbitrary(arbitrary), Gen )

type Name = String
data PyramidScheme = Recruiter Name [PyramidScheme] | Member Name
data Paycheck = Paycheck Name Float
type Paychecks = [Paycheck]

instance Show Paycheck where
    show (Paycheck name methemoney) = name ++ ": " ++ show methemoney ++ "$"

instance Show PyramidScheme where
    show scheme = showL 0 scheme
        where
            showL l (Member name) = replicate (2*l) ' ' ++ "M: " ++ name ++ "\n"
            showL l (Recruiter name recruits) =
                replicate (2*l) ' ' ++ "R: " ++ name ++ "\n" ++ concatMap (showL $ succ l) recruits

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

calcPayouts :: PyramidScheme -> Paychecks
calcPayouts (Member name) = [Paycheck name memberPay]
calcPayouts (Recruiter name recruits) =
    let memBelow = concatMap calcPayouts recruits in
        Paycheck name ((+recruiterPay).(recruiterScale*) $ sum $ map getMoney memBelow) : memBelow

calcMonthlyRevenue :: PyramidScheme -> Float
calcMonthlyRevenue (Member _) = memberFee
calcMonthlyRevenue (Recruiter _ recruits) =
    recruiterFee + sum (map calcMonthlyRevenue recruits)

calcMonthlyProfits :: PyramidScheme -> Float
calcMonthlyProfits scheme = calcMonthlyRevenue scheme - sum (map getMoney $ calcPayouts scheme)

getMoney :: Paycheck -> Float
getMoney (Paycheck _ money) = money

removeFromScheme :: Name -> PyramidScheme -> Maybe PyramidScheme
removeFromScheme n m@(Member name)
    | n == name = Nothing
    | otherwise = Just m
removeFromScheme n (Recruiter name recruits)
    | n == name = Nothing
    | otherwise = Just $ Recruiter name $ mapMaybe (removeFromScheme n) recruits

-- this is just a specialized mapM_ (whatever that means)!
-- you don't have to make use of it, but it could be a nice bonus ;)
mapIO_ :: (a -> IO b) -> [a] -> IO ()
mapIO_ _ [] = return ()
mapIO_ act (x:xs) = do
    act x
    mapIO_ act xs

main :: IO()
main = do
    let scheme = example
    -- if you want a randomly generated scheme, uncomment below + comment above
    --scheme <- generate arbitrary 
    cmdLoop scheme

cmdLoop :: PyramidScheme -> IO ()
cmdLoop scheme = do
    putStr "\nEnter command: "
    cmd <- getLine
    case cmd of
        "print" -> do
            print scheme
            cmdLoop scheme

        "rm" -> do
            putStr "Enter name: "
            name <- getLine
            case removeFromScheme name scheme of
                Nothing -> do
                    putStrLn "Cannot remove!"
                    cmdLoop scheme
                Just scheme' -> cmdLoop scheme'

        "pay" -> do
            mapIO_ print $ sortOn (Down . getMoney) (calcPayouts scheme)
            cmdLoop scheme

        "profit" -> do
            print $ calcMonthlyProfits scheme
            cmdLoop scheme

        "q" -> return ()

        _ -> do
            putStrLn "Unknown command!"
            cmdLoop scheme

--- EXAMPLE
example :: PyramidScheme
example = Recruiter "a" [Member "b", Member "c", 
    Recruiter "d" [Recruiter "e" [Member "f"], Member "g"] , Recruiter "h" []]

--- GENERATORS FOR QUICKCHECK
instance Arbitrary PyramidScheme where
    arbitrary = choose(2,3) >>= genSchemeDepth

-- didn't do this at first and the results where frightening
genSafeChar :: Gen Char
genSafeChar = elements ['a'..'z']

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