export CGscatter
export CGgif

### TODO add gif/animations options
### TODO expand below


"""
    CGscatter(x,y,pointsx,pointsy)

Plot the bounding shape and points from a chaos game.
"""
function CGscatter(x,y,pointsx,pointsy)

    plt=plot(vcat(x,x[1]),vcat(y,y[1]),label="")

    scatter!(plt,pointsx,pointsy,label="",colour=:black,ms=1)

    return plt
end

"""
    CGgif(x,y,pointsx,pointsy)

Simple gif like scatter plot above
"""
function CGgif(x,y,pointsx,pointsy)

    plt=plot(vcat(x,x[1]),vcat(y,y[1]),label="")

    out_gif = @animate for i in 1:length(pointsx)
        scatter!(plt,[pointsx[i]],[pointsy[i]],label="",colour=:black,ms=1)
    end every 20

    gif(out_gif,"test.gif")

end