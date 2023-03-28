struct SVGNode{T}
    node::T
end

function SVGNode(str::String)
    xroot = root(parsexml(str))
    unlink!(xroot)
    SVGNode(xroot)
end

struct SVG <: AbstractSVG
    svg_width::Int
    svg_height::Int
    content::Function
    svg_view_box::NTuple{4, Int}
    svg_style::Union{Nothing,String}
    svg_class::Union{Nothing,String}
    bg_color::Union{Nothing,String}
end

Base.string(e::SVG) = string(getxdoc(e))
getsvgviewbox(s::SVG) = s.svg_view_box

function SVG(
    content::String; 
    width=300,
    height=300,
    view_box=(-100,-100,200,200),
    kwargs...
    )
    SVG(
        width, 
        height, 
        () -> content; 
        view_box=view_box,
        kwargs...
    )
end

function SVG(
    width, 
    height, 
    content::Function; 
    style="background-color:#fff",
    class=nothing,
    view_box=(0,0,width,height),
    bg_color=nothing,
    )
    SVG(
        width,
        height,
        content,
        view_box,
        style,
        class,
        bg_color,
    )
end

function SVG(v::Vector{<:AbstractSVG}; dims=1, kwargs...)
    svgcat(v...; dims=dims, kwargs...)
end

function SVG(v::Matrix{<:AbstractSVG}; dims=1, kwargs...)
    rows = map(eachrow(v)) do row
        svghcat(row...; kwargs...)
    end
    svgvcat(rows...; kwargs...)
end

function linkbackgroundrect!(xroot, bg_color)
    if !isnothing(bg_color)
        bg = SVGNode("""
            <rect x="0" y="0" width="100%" height="100%" style="fill:$bg_color;"/>
        """).node
        link!(xroot, bg)
    end
end

function getxdoc(
    g::SVG;  
    x=0, 
    y=0, 
    width=g.svg_width, 
    height=g.svg_height,
    view_box=getsvgviewbox(g),
    style=g.svg_style,
    class=g.svg_class,
    is_doc=true,
    )
    xdoc = EzXML.XMLDocument()
    xroot = ElementNode("svg")
    setroot!(xdoc, xroot)
    linkbackgroundrect!(xroot, g.bg_color)
    link!(
        xroot, 
        SVGNode("""<g>$(g.content())</g>""").node
    )
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
    if !isnothing(class)
        xroot["class"] = class
    end
    xdoc
end

function SVGText(str::String)
    SVG("""
        <text 
            style="font-size:30px"
            x="0" 
            y="0" 
            dominant-baseline="middle" 
            text-anchor="middle"
            >
            $(str)
        </text>""";
        width=300,
        height=80,
        view_box=(-150,-40,300,80),
    )
end
