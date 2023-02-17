export GetVertices, GetVerticesXY, GetVerticesRegularPolygon
export GetVerticesMultipleShapes

"""
    GetVerticesRegularPolygon(shape::Int64)

Returns list of (coordinates of) vertices of a regular polygon.

# Arguments
- `shape::Int64`: number of sides of regular polygons
- `centre::Vector{Float64}`: position of centre of shape

inspired from luxor.jl ngon
"""
function GetVerticesRegularPolygon(shape::Int64,centre)
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

"""
    GetVertices(shape,centre)

Returns list of (coordinates of) vertices of a regular polygon.

# Arguments
- `shape`: number of sides of regular polygons
- `centre::Vector{Float64}`: position of centre of shape

inspired from luxor.jl ngon
"""
function GetVertices(shape,centre)
    if typeof(shape) == Int64
        GetVerticesRegularPolygon(shape,centre)
    elseif typeof(shape) == Vector{Vector{Float64}}
        return shape
    else
        throw(RestrictionException)
    end
end

"""
    GetVerticesXY(vertices)

Convenience code to get (x,y) coords from array of vertices
"""
function GetVerticesXY(vertices)
    ### TODO: cleaner way to do this unpacking? probably
    x,y = [i[1] for i in vertices],[i[2] for i in vertices]
    return x,y
end

"""
    GetVerticesMultipleShapes()

WIP
"""
function GetVerticesMultipleShapes(shapes::Vector{Union{Int64,Vector{Vector{Float64}}}},centres::Vector{Vector{Float64}})
    
    return 
end