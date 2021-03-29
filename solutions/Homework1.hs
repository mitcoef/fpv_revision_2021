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
module Homework1 where

countMatches :: String -> String -> Int
countMatches _  []  = 0
countMatches []  _  = 0
countMatches pat xs = go xs 0
    where go [] acc = acc
          go all@(x:xs) acc = 
              if isPrefix pat all
               then go xs (acc + 1)
               else go xs acc

isPrefix :: String -> String -> Bool
isPrefix [] [] = True
isPrefix [] _  = True
isPrefix _ []  = False
isPrefix (p:ps) (x:xs) = p == x && isPrefix ps xs        

isPrefix' :: Eq a => [a] -> [a] -> Bool
isPrefix' ps xs = ps == take (length ps) xs

addCount :: String -> Int -> [(String, Int)] -> [(String, Int)]
addCount str add [] = [(str, add)]
addCount str add ((s,a):xs) 
    | str == s = (s, a + add) : xs
    | otherwise = (s,a):addCount str add xs

findMemeStock :: [String] -> [String] -> [(String, Int)]
findMemeStock _ [] = []
findMemeStock [] _ = []
findMemeStock ps xs = go xs []
    where
        go [] acc = acc
        go (x:xs) acc = go xs (countPats ps x acc)
        countPats [] _ acc = acc
        countPats (p:ps) s acc = 
            let nMatches = countMatches p s in
                countPats ps s (addCount p nMatches acc)

-- FOR TESTING
potentialStocks :: [String]
potentialStocks = ["AMC", "GME", "TSLA", "BB"] 

redditPosts :: [String]
redditPosts = 
    mPP (mPP (mPP ["$AMC", "$GME", "$TSLA", "$BB"] 
    <*> 
    [" is going to ", " will never ", " can not ",
     " is very unlikely to ", " could possibly "])
    <*> 
    ["go to the Moon like VW", "crash hard", "outperform $AMZN", 
     "stabilize despite volatility"])
    <*>
    [" ,according to Elon's latest Tweet.",
     " ,if we JUST HODL!!!", " ,at least that's what my horoscope said!",
     " ,a new model accounting for GME shorts predicts."]
    where mPP = map (++)