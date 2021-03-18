module Homework1 where

import qualified Data.List as YOUSUREABOUTTHAT

countMatches :: String -> String -> Int
countMatches = undefined

findMemeStock :: [String] -> [String] -> [(String, Int)]
findMemeStock = undefined

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