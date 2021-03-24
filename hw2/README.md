# Pyramid Scheme
## DISCLAIMER
*Pyramid-Schemes are an illegal practice. Do not
engage in or with such practices. This is not legal advice.
The task below exists solely for the purposes of learning (and entertainment).*


## Your task

After failing to make the big bucks trading with stocks, you
decide on a new business venture. While searching the web you stumble
upon the practice of [pyramid schemes](https://en.wikipedia.org/wiki/Pyramid_scheme).

A member of your pyramid scheme pays a fixed monthly rate
for "investment tips". They also get some money from the great 
profits you make, as a fixed monthly paycheck.

The "real money" however is made as a recruiter. They pay extra
each month to get "hot leads" on potential new members. They also
get extra money *aswell* as a percentage of the money earned by
everybody recruited by them. Amazing!

## Important
*Make use of the utility functions given to you in 
`Data.List`. If you try and solve these tasks (aswell as those below)
without them, they will take you much much longer to complete.
This is especially important considering that the most common issue in the exam is a lack of time!*

## Subtask 1
To plan your very own, you first come up with some datatypes
to represent the above scheme:

````haskell
type Name = String
data PyramidScheme = Recruiter Name [PyramidScheme] | Member Name
````
An example scheme is given, aptly named `example`.

To get a better overview, first implement a `Show` instance for
`PyramidScheme`. Members are printed as `M: <membername>`,
recruiters as `R: <recruitername>`. To make the hierachy clearer 
add indentation, starting with 0 spaces
and adding 2 for each level below.
For `example` this should give:
```
R: a
  M: b
  M: c
  R: d
    R: e
      M: f
    M: g
  R: h
```




## Subtask 2

In the sourcefile, you will find the following constants (I really despise magic numbers):
````haskell
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
````

You first want to know about $$, so you write some utility-functions, making use of two new utility-types:
````haskell
data Paycheck = Paycheck Name Float
type Paychecks = [Paycheck]
````
`Paycheck` represents the ammount of money earned by 
member/recruiter with the corresponding name. A `Show` instance
is given.

Begin by writing a function
````haskell
calcPayouts :: PyramidScheme -> Paychecks
````
which calculates the `Paycheck` for each member/recruiter of your scheme.
A member gets a flat payout of `memberPay`.
A recruiter gets a flat payout of `recruiterPay` *plus* 
`recruiterScale` times the ammount of money earned by everybody below
them combined.

Next, implement
````haskell
calcMonthlyRevenue :: PyramidScheme -> Float
````
which calculates your monthly revenue.
Each member gets you `memberFee` and each recruiter `recruiterFee`
plus the sum of revenue of everbody below him.

Finally you can write
````haskell
calcMonthlyProfits :: PyramidScheme -> Float
````
To make matters easier, your monthly profits are just your
revenue minus the sum of money you pay out. No extra costs when running
your shady "business" from home ;)


## Subtask 3

A pyramid scheme depends on a constant influx of new members - after
all, you essentially pay people by giving them some of the fees you collect.
When people start wising up, you want to remove them as quickly
as possible! They might make others leave aswell, or worse,
demand their money back. Yikes!

Implement

````haskell
removeFromScheme :: Name -> PyramidScheme -> Maybe PyramidScheme
````
where `removeFromScheme n scheme` should remove the member named `n`
from `scheme`. Who could have guessed?!
Be careful though, you don't want to remove your final member or recruiter! `mapMaybe` from `Data.Maybe` can be of help here.


## Subtask 4
Finally, make this whole thing interactive by bringing some
`IO` into the mix.
A template for main is already given; The default scheme is `example`,
a random scheme-generator is given aswell.

Write a function 
````haskell
cmdLoop :: PyramidScheme -> IO ()
````
Which interacts with you, the user! It takes a command, executes it, then
waits for a new command. They are as follows:

1. `print` prints the current scheme
2. `pay` prints the payouts in descending order - bonus points for using `mapIO_` ;)
3. `profit` prints your monthly profit
4. `rm` asks for a name and removes that person from the scheme. Should this
fail, print an error-message and wait for another command, keeping the current scheme.
5. `q` quits the program

When receiving an unkown command, print an error-message and continue.

A session using `example` could look like this. You don't have to, but adding prompts
is always a plus:
```
*Homework2> main

Enter command: print
R: a
  M: b
  M: c
  R: d
    R: e
      M: f
    M: g
  R: h


Enter command: profit
365.76

Enter command: pay
a: 129.44$
d: 78.8$
e: 56.0$
h: 50.0$
b: 20.0$
c: 20.0$
f: 20.0$
g: 20.0$

Enter command: rm
Enter name: f

Enter command: print
R: a
  M: b
  M: c
  R: d
    R: e
    M: g
  R: h


Enter command: rm
Enter name: a
Cannot remove!

Enter command: who wrote this crappy program????
Unknown command!

Enter command: q
```