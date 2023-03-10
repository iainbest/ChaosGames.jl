using Pkg; Pkg.activate(".")

include("../src/ChaosGames.jl")

using .ChaosGames
using GR

# C = [[0.0,0],[3,0],[3,1],[1,1],[1,4],[3,4],[3,5],[0,5]]
C = [[0.0,1],[1,0],[3,0],[3,1],[2,1],[1,2],[1,3],[2,4],[3,4],[3,5],[1,5],[0,4]]

H = [[0.0,0],[1,0],[1,2],[2,2],[2,0],[3,0],[3,5],[2,5],[2,3],[1,3],[1,5],[0,5]]

A = [[0.0,0],[1,0],[1,2],[2,2],[2,0],[3,0],[3,4],[2,5],[1,5],[0,4]]

x,y,pointsx,pointsy = ChaosGame(C,50000,0.5,:WithinOneNeighbour)
# x,y,pointsx,pointsy = ChaosGame(C,50000,0.5,:WithinTwoNeighbours)

# x,y,pointsx,pointsy = ChaosGame(H,50000,0.5,:WithinOneNeighbour)
# x,y,pointsx,pointsy = ChaosGame(H,50000,0.5,:WithinTwoNeighbours)

# x,y,pointsx,pointsy = ChaosGame(A,50000,0.5,:WithinOneNeighbour)
# x,y,pointsx,pointsy = ChaosGame(A,50000,0.5,:WithinTwoNeighbours)


p1=CGscatter(x,y,pointsx,pointsy)