struct StaticSVG{T} <: AbstractSVG
    svg_width::Int
    svg_height::Int
    svg_view_box::NTuple{4, Int}
    svg_style::Union{Nothing,String}
    xdoc::T
end

getsvgviewbox(s::StaticSVG) = s.svg_view_box

function StaticSVG(
    xdoc;
    svg_width, 
    svg_height, 
    svg_view_box=(0,0,svg_width,svg_height),
    svg_style="background-color:#fff",
    )
    StaticSVG(
        svg_width, 
        svg_height,
        svg_view_box,
        svg_style,
        xdoc,
    )
end

function getxdoc(
    g::StaticSVG;  
    x=0, 
    y=0, 
    width=g.svg_width, 
    height=g.svg_height,
    view_box=getsvgviewbox(g),
    style=g.svg_style,
    is_doc=true,
    )
    xdoc = parsexml(string(root(g.xdoc)))
    xroot = EzXML.root(xdoc)
    if is_doc
        adddocattrs(xroot)
    end
    xroot["x"] = x
    xroot["y"] = y
    xroot["width"] = width
    xroot["height"] = height
    xroot["viewBox"] = join(view_box, " ")
    if !isnothing(style)
        xroot["style"] = style
    end
    xdoc
end