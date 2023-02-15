export GetVertices, GetVerticesXY

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

"""
    GetVerticesXY(vertices)

Convenience code to get (x,y) coords from array of vertices
"""
function GetVerticesXY(vertices)
    ### TODO: cleaner way to do this unpacking? probably
    x,y = [i[1] for i in vertices],[i[2] for i in vertices]
    return x,y
end