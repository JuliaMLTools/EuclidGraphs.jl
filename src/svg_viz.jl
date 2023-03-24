abstract type AbstractSVGViz end
Base.write(s::AbstractString, e::AbstractSVGViz) = write(s, string(e))
Base.read(s::AbstractString, T::Type{<:AbstractSVGViz}) = T(read(s, String))
Base.show(io::IO, m::MIME"image/svg+xml", svg::AbstractSVGViz) = print(io, string(svg))

struct SVGViz <: AbstractSVGViz
    svg
end
Base.string(x::SVGViz) = x.svg
