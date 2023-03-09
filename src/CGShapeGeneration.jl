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

Returns list of (coordinates of) vertices of chosen shape.

If shape is integer-valued, returns regular polygon with shape-many sides.
If shape is already vector of vertices, simply re-return that vector.

# Arguments
- `shape`: either integer or vector of vertices
- `centre::Vector{Float64}`: position of centre of shape (for regular polygons)

regular polygon portion heavily inspired by luxor.jl ngon
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

################################################################
### Arbitrary shapes defined by list of coordinates:
C = [[0.0,0],[3,0],[3,1],[1,1],[1,4],[3,4],[3,5],[0,5]]
H = [[0.0,0],[1,0],[1,2],[2,2],[2,0],[3,0],[3,5],[2,5],
        [2,3],[1,3],[1,5],[0,5]]
# A = 
# O = 
# S = 
# G = 
# M = 
# E = 
# dot = 
# J = 
# L = 

################################################################

"""
    GetVerticesMultipleShapes()

WIP
"""
function GetVerticesMultipleShapes(shapes::Vector{Union{Int64,Vector{Vector{Float64}}}},centres::Vector{Vector{Float64}})
    
    return 
end