# using Random
# using Plots
# gr(fmt=:png,size=(800,800))

### try examples from wiki: https://en.wikipedia.org/wiki/Chaos_game

### honestly cant remember why i bothered making these? 
struct ShapeException <: Exception end
struct RestrictionException <: Exception end

"""
    GetVertices(shape,centre)

Returns list of (coordinates of) vertices of a regular polygon.

# Arguments
- `shape::Int64`: number of sides of regular polygons
- `centre::Vector{Float64}`: position of centre of shape

inspired from luxor.jl ngon
"""
function GetVertices(shape::Int,centre)
    if shape < 3 
        throw(ShapeException)
    end

    ### make regular polygons be flat - probably a nicer way to do this but whatever honestly. maths is for chumps
    orientation = (1.5 + (shape-3)*1.5)pi/shape

    x,y = centre

    return [ [x+cos(orientation + (n * 2pi/shape)), 
              y+sin(orientation + (n * 2pi/shape))] 
              for n in 1:shape ]

end

function GetVerticesXY(vertices)
    x,y = [i[1] for i in vertices],[i[2] for i in vertices]
    return x,y
end


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

### TODO add gif animations?
"""
    CGscatter(x,y,pointsx,pointsy)

Plot the bounding shape and points from a chaos game.
"""
function CGscatter(x,y,pointsx,pointsy)

    plt=plot(vcat(x,x[1]),vcat(y,y[1]),label="")

    scatter!(plt,pointsx,pointsy,label="",colour=:black,ms=1)

    return plt
end

### TODO: fix docs here
"""
    ChaosGame(shape,N,movefactor,restriction,initialpoint,centre)

Returns points from a chaos game. 

# Arguments
- `shape::Int64`: number of sides of regular polygons
- `N::Int64`: number of iterations in game
- `movefactor::Float64=0.5`: scaling distance to move towards next vertex. 
- `restriction::Symbol`: restriction for chaos game. TODO: more detail here
- `initialpoint::Vector{Float64}`: (x,y) position to begin game
- `centre::Vector{Float64}`: (x,y) position of centre of shape

Returns (x,y) values for chosen shape, and the (x,y) points from the specified chaos game, as four separate arrays.

"""
function ChaosGame(shape::Int,N::Int,movefactor=0.5,
    restriction::Symbol=:NoRestriction,initialpoint=[1.0,1.0],
    centre=[1.0,1.0])

    ### get vertices of shape (and x,y coords)
    vertices = GetVertices(shape,centre)
    x,y = GetVerticesXY(vertices)

    ### save history of chosen vertices 
    ### (TODO: remove if not required)
    vertexhistory = Vector{Int64}(undef,N+2)
    vertexhistory[1:2] .= 1

    ### save points for plotting
    points = Vector{Vector{Float64}}(undef, N+1)
    points[1] = initialpoint

    currentpoint = initialpoint

    for (count,i) in enumerate(1:N)

        chosenvertex,chosenindex = ChooseVertex(vertices,
            restriction, vertexhistory,count)

        nextpoint = GetNextPoint(currentpoint,chosenvertex,
            movefactor)

        ###update vertexhistory,points,currentpoint
        vertexhistory[i+2] = chosenindex
        points[i+1] = nextpoint
        currentpoint = nextpoint

    end

    pointsx = [i[1] for i in points]
    pointsy = [i[2] for i in points]

    return x,y,pointsx,pointsy

end

### barnsley fern 
### how can we use machinery above to generate this?
### copied from https://en.wikipedia.org/wiki/Barnsley_fern
f1(x, y) = [0 0; 0 0.16] * [x, y]
f2(x, y) = [0.85 0.04; -0.04 0.85] * [x, y] + [0, 1.6]
f3(x, y) = [0.2 -0.26; 0.23 0.22] * [x, y] + [0, 1.6]
f4(x, y) = [-0.15 0.28; 0.26 0.24] * [x, y] + [0, 0.44]

function f(x, y)
    r = rand()
    r < 0.01 && return f1(x, y)
    r < 0.86 && return f2(x, y)
    r < 0.93 && return f3(x, y)
    return f4(x, y)
end

function barnsley_fern(iter)
    X = [0.0]
    Y = [0.0]
    for i in 1:iter
        x, y = f(X[end], Y[end])
        push!(X, x)
        push!(Y, y)
    end
    scatter(X, Y, color=:green, markersize=1,label="")
end