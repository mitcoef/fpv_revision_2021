# Memestocks
## DISCLAIMER
*This is not financial advice. Stay far away from risky trades and always be prepared to
lose everyhing. The task below exists solely for the purposes of learning (and entertainment).*

For your own practice, try to implement
the following without making use of 
the existing string-functionality of Data.List.
Your goal should be getting comfortable with using
recursion :)

## Your task

After watching some of your fellow students
, who even checked *during* the exam, go
crazy about the prize of $GME, you want in and make some quick $$. Your genius strategy: 
 
Check reddit posts for mentions of a list of predetermined stocks with *"potential"*.
You then plan investing in the stock with the most *"meme-value"*, which you conclude must be the one mentioned most often.

First, implement a function
````haskell
countMatches :: String -> String -> Int
````
Where `countMatches needle haystack` should
return how many times `needle` occurs as a 
substring of `haystack`. Example:

`countMatches "an" "banana" = 2`

You might want to think of suitable helper-functions. 

With that out of the way, write a function

````haskell
findMemeStock :: [String] -> [String] -> [(String, Int)]
````

Which takes a list of potential stocks and a list of reddit-posts. Find out how many times
each potential stock is mentioned in each post
and return the combined counts for each
stock. Example:

`findMemeStock potentialStocks redditPosts 
= [("AMC",80),("GME",160),("TSLA",80),("BB",80)]`

The order of elements is not important. 

There are of course many ways to do this, but a
function with the signature below might help you:

````haskell
f :: String -> Int -> [(String, Int)] -> [(String, Int)]
````
