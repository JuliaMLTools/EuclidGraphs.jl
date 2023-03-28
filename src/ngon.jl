"""
    Get the vertices of a regular polygon.
"""
function ngon(n::Int, r::Real=80)
    θ = 2π/n
    tround(xy) = round.(xy, digits=2)
    [(r*cos(i*θ), r*sin(i*θ)) for i in 0:n-1] .|> tround
end

pole(args...) = ngon(2, args...)
triangle(args...) = ngon(3, args...)
square(args...) = ngon(4, args...)
pentagon(args...) = ngon(5, args...)
hexagon(args...) = ngon(6, args...)
heptagon(args...) = ngon(7, args...)
octagon(args...) = ngon(8, args...)
nonagon(args...) = ngon(9, args...)
decagon(args...) = ngon(10, args...)