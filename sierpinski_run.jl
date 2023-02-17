using Pkg; Pkg.activate(".")

include("./src/ChaosGames.jl")

using .ChaosGames
using Plots

x,y,pointsx,pointsy = ChaosGame(3,10000,0.5)

p1=CGscatter(x,y,pointsx,pointsy)

# savefig(p1,"images/sierpinski.png")