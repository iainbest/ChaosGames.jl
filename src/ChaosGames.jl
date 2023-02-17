module ChaosGames

using Random
using Plots

default(fmt=:png,size=(800,800))

# Write your package code here.
include("ChaosGame.jl")
include("CGRules.jl")
include("CGPlots.jl")
include("CGShapeGeneration.jl")

end
