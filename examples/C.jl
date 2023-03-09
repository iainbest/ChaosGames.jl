using Pkg; Pkg.activate(".")

include("../src/ChaosGames.jl")

using .ChaosGames
using GR

C = [[0.0,0],[3,0],[3,1],[1,1],[1,4],[3,4],[3,5],[0,5]]

x,y,pointsx,pointsy = ChaosGame(C,50000,0.5,:WithinOneNeighbour)
# x,y,pointsx,pointsy = ChaosGame(C,50000,0.5,:WithinTwoNeighbours)

p1=CGscatter(x,y,pointsx,pointsy)