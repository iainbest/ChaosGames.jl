# Chaos Games

A simple bit of code to generate fractal patterns from a polygon(s). 

Includes restriction rules to change the games.

Includes basic plot recipe, to be expanded on.

## Installation
Git instructions

## Usage example
Inside cloned repository, activate environment. 

Then if you want to explore different options, do something like:

```julia
julia> include("src/ChaosGames.jl")

julia> using .ChaosGames

julia> x,y,pointsx,pointsy = ChaosGame(3,100000,0.5,...)

julia> p1 = CGscatter(x,y,pointsx,pointsy)
```

 Alternatively for simple sierpinski construction (or as a first try!) do: 

```
$ julia ./examples/sierpinksi.jl
```

![sierpinksi](./images/sierpinski.png)

Other example scripts will eventually be contained in the examples folder.

## To Do:
- option for multiple shape chaos games?
- clean up restriction code: naming, saving of unnecessary history of previous chosen vertices, ...
- option of generic (non-regular) polygon for the game
  - currently require some ordering of polygon? nicer way to do this?
- simple plots and examples in repo examples folder and readme
  - started
- example codes, simple explanation of basic algorithm in readme
  - started
- install/clone instructions for readme
- and more probably

## See also:
Wiki: https://en.wikipedia.org/wiki/Chaos_game
