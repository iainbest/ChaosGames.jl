export ShapeException,RestrictionException
export ChooseVertex,GetNextPoint

### honestly cant remember why i bothered making these? 
struct ShapeException <: Exception end
struct RestrictionException <: Exception end

### TODO: cleaner way to store different restrictions?
### TODO: add in option of moving to midpoints (other points?) between vertices of regular ngons
### TODO: optimise / only keep required parts of vertex history (dont save crap)
"""
    ChooseVertex(vertices,restriction,vertexhistory,currentiteration)

Chooses next vertex to move towards in a chaos game.

# Arguments
- `vertices::Vector{Vector{Float64}}`: list of vertices of regular polygon. 
- `restriction::Symbol`: restriction for chaos game. TODO: more detail here
- `vertexhistory::Vector{Int64}`: history of chosen vertex indices. Used in some restrictions.
- `currentiteration`::Int64: current iteration through game. Used to get correct parts of vertexhistory.

Essentially works by randomly choosing index from vector of possible vertices, defined by specific chosen rule. 

"""
function ChooseVertex(vertices::Vector{Vector{Float64}},restriction::Symbol,vertexhistory::Vector{Int64},currentiteration::Int64)

    if restriction == :NoRestriction
        ### random choice
        chosenindex = rand(1:length(vertices))
        chosenvertex = vertices[chosenindex]
    
    elseif restriction == :NotPrevious
        # vertexhistory needed here

        previousindex = vertexhistory[currentiteration+1]

        possiblevertices = collect(1:length(vertices))
        deleteat!(possiblevertices,possiblevertices.==previousindex)

        chosenindex = rand(possiblevertices)
        chosenvertex = vertices[chosenindex]

    elseif restriction == :NotOnePlaceAwayOneSided
        @assert length(vertices) > 3

        previousindex = vertexhistory[currentiteration+1]

        possiblevertices = collect(1:length(vertices))

        ### append last index so we never get bounds errors
        possiblevertices = vcat(possiblevertices,possiblevertices[1:1])

        upper = possiblevertices[previousindex+1]

        deleteat!(possiblevertices,possiblevertices.==upper)

        chosenindex = rand(possiblevertices)
        chosenvertex = vertices[chosenindex]


    elseif restriction == :NotTwoPlacesAway

        ### TODO: check behaviour of this restriction.
        ### x,y,pointsx,pointsy = ChaosGame(4,100000,0.5,:NotTwoPlacesAway,[0.0,0.0]);
        ### should this restriction be 'one-sided' ? 

        @assert length(vertices) > 3

        previousindex = vertexhistory[currentiteration+1]

        possiblevertices = collect(1:length(vertices))

        ### append first pair and last pair of indices so we never get bounds errors
        possiblevertices = vcat(vcat(possiblevertices[end-1:end],possiblevertices),possiblevertices[1:2])

        upper = possiblevertices[previousindex+4]
        lower = possiblevertices[previousindex]

        deleteat!(possiblevertices,possiblevertices.==upper)
        deleteat!(possiblevertices,possiblevertices.==lower)

        chosenindex = rand(possiblevertices)
        chosenvertex = vertices[chosenindex]

    elseif restriction == :NotNeighbourIfTwoPreviousTheSame

        if vertexhistory[currentiteration] == vertexhistory[currentiteration+1]

            previousindex = vertexhistory[currentiteration+1]

            possiblevertices = collect(1:length(vertices))

            ### append first and last indices so we never get bounds errors
            possiblevertices = vcat(vcat(possiblevertices[end:end],possiblevertices),possiblevertices[1:1])

            upper = possiblevertices[previousindex+2]
            lower = possiblevertices[previousindex]

            deleteat!(possiblevertices,possiblevertices.==upper)
            deleteat!(possiblevertices,possiblevertices.==lower)

            chosenindex = rand(possiblevertices)
            chosenvertex = vertices[chosenindex]

        else
            ### defaults to random/no restriction
            chosenvertex,chosenindex = ChooseVertex(vertices,:NoRestriction,vertexhistory,currentiteration)
        end

    elseif restriction == :WithinOneNeighbour
        previousindex = vertexhistory[currentiteration+1]

        possiblevertices = collect(1:length(vertices))

        ### append first and last indices so we never get bounds errors
        possiblevertices = vcat(vcat(possiblevertices[end:end],possiblevertices),possiblevertices[1:1])

        upper = possiblevertices[previousindex+2]
        prev = possiblevertices[previousindex+1]
        lower = possiblevertices[previousindex]

        ### filter out so only previous vertex, or first neighbours are included
        filter!(v->v∈[upper,prev,lower],possiblevertices)

        chosenindex = rand(possiblevertices)
        chosenvertex = vertices[chosenindex]

    elseif restriction == :WithinTwoNeighbours
        previousindex = vertexhistory[currentiteration+1]

        possiblevertices = collect(1:length(vertices))

        ### append first pair and last pair of indices so we never get bounds errors
        possiblevertices = vcat(vcat(possiblevertices[end-1:end],possiblevertices),possiblevertices[1:2])

        upper = possiblevertices[previousindex+4]
        prev = possiblevertices[previousindex+2]
        lower = possiblevertices[previousindex]

        ### filter out so only previous vertex, or first neighbours are included
        filter!(v->v∈[upper,prev,lower],possiblevertices)

        chosenindex = rand(possiblevertices)
        chosenvertex = vertices[chosenindex]

    else
        throw(RestrictionException)
    end
    
    return chosenvertex, chosenindex
end

"""
    GetNextPoint(currentpoint,chosenvertex,movefactor)

Calculates next point in a chaos game. 

We move from currentpoint towards the chosenvertex, scaled by movefactor, i.e. movefactor=0.5 we move halfway.
"""
function GetNextPoint(currentpoint,chosenvertex,movefactor)

    nextpoint = [currentpoint[1] + movefactor*(chosenvertex[1] - currentpoint[1]),
                 currentpoint[2] + movefactor*(chosenvertex[2] - currentpoint[2])]

    return nextpoint
end