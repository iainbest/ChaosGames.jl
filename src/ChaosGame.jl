export ChaosGame


### TODO: fix docs here
"""
    ChaosGame(shape,N,movefactor,restriction,initialpoint,centre)

Returns points from a chaos game. 

# Arguments
- `shape`: if Int, number of sides of regular polygon. Else must be vector of (ordered?) coordinates
- `N::Int64`: number of iterations in game
- `movefactor::Float64=0.5`: scaling distance to move towards next vertex. 
- `restriction::Symbol`: restriction for chaos game. TODO: more detail here
- `initialpoint::Vector{Float64}`: (x,y) position to begin game
- `centre::Vector{Float64}`: (x,y) position of centre of shape

Returns (x,y) values for chosen shape, and the (x,y) points from the specified chaos game, as four separate arrays.

"""
function ChaosGame(shape,N::Int,movefactor=0.5,restriction::Symbol=:NoRestriction,initialpoint=[1.0,1.0],centre=[1.0,1.0])

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


"""
    MultipleShapeChaosGame()

WIP
"""
function MultipleShapeChaosGame()

    ### define multiple shapes & vertices
    
    ### save history of chosen vertices

    ### save points for plotting

    ### choose initial point and initial shape

    for (count,i) in enumerate(1:N)
        ### choose next vertex from one shape

        ### get next point

        ### update vertex history

        ### random chance to swap to next shape? 
            ### if swap do we clear vertex history? 

    end

    pointsx = [i[1] for i in points]
    pointsy = [i[2] for i in points]

    ### return vector of x- and y- coords of vertices for each shape
    return x_list,y_list,pointsx,pointsy
end



### TODO: either incorporate or delete this
# ### barnsley fern 
# ### how can we use machinery above to generate this?
# ### copied from https://en.wikipedia.org/wiki/Barnsley_fern
# f1(x, y) = [0 0; 0 0.16] * [x, y]
# f2(x, y) = [0.85 0.04; -0.04 0.85] * [x, y] + [0, 1.6]
# f3(x, y) = [0.2 -0.26; 0.23 0.22] * [x, y] + [0, 1.6]
# f4(x, y) = [-0.15 0.28; 0.26 0.24] * [x, y] + [0, 0.44]

# function f(x, y)
#     r = rand()
#     r < 0.01 && return f1(x, y)
#     r < 0.86 && return f2(x, y)
#     r < 0.93 && return f3(x, y)
#     return f4(x, y)
# end

# function barnsley_fern(iter)
#     X = [0.0]
#     Y = [0.0]
#     for i in 1:iter
#         x, y = f(X[end], Y[end])
#         push!(X, x)
#         push!(Y, y)
#     end
#     scatter(X, Y, color=:green, markersize=1,label="")
# end