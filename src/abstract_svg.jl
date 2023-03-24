abstract type AbstractSVG end

function Base.show(io::IO, m::MIME"image/svg+xml", g::AbstractSVG)
    print(io, string(getsvg(g)))
end

function Base.show(io::IO, m::MIME"image/svg+xml", xdoc::EzXML.Document)
    print(io, string(xdoc))
end

getsvgviewbox(g) = (0, 0, g.svg_width, g.svg_height)

function adddocattrs(x)
    x["xmlns"] = "http://www.w3.org/2000/svg"
    x["xmlns:xlink"] = "http://www.w3.org/1999/xlink"
    x["version"] = "1.1"
end

function getsvgroot(g; kwargs...)
    EzXML.root(getsvg(g; is_doc=false, kwargs...))
end

function Base.write(filename::AbstractString, svg::AbstractSVG)
    write(
        filename,
        getsvg(svg)
    )
end

save(a::AbstractSVG) = write("./output.svg", a)

function getsvg(
    content::AbstractSVG; 
    x=0, 
    y=0, 
    width=content.svg_width,
    height=content.svg_height,
    view_box=content.svg_view_box,
    style=content.svg_style,
    class=content.svg_class,
    is_doc=true
    )
    xdoc = EzXML.XMLDocument()
    xroot = ElementNode("svg")
    setroot!(xdoc, xroot)
    xroot["x"] = x
    xroot["y"] = y
    xroot["width"] = width
    xroot["height"] = height
    xroot["viewBox"] = join(view_box, " ")

    if is_doc
        xroot["xmlns"] = "http://www.w3.org/2000/svg"
        xroot["xmlns:xlink"] = "http://www.w3.org/1999/xlink"
        xroot["version"] = "1.1"
    end

    if !isnothing(style)
        xroot["style"] = style
    end
    if !isnothing(class)
        xroot["class"] = class
    end

    # defs
    defs = ElementNode("defs")
    link!(xroot, defs)
    
    # styles
    style = ElementNode("style")
    link!(defs, style)
    style["type"] = "text/css"
    # link!(style, CDataNode("some.css {}"))

    link!(xroot, getchildren(content))

    xdoc
end