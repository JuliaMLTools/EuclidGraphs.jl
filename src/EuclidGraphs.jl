module EuclidGraphs

include("imports.jl")
include("utils.jl")

include("abstract_svg.jl")
export svgcat, svgvcat, svghcat, svgzcat

include("ngon.jl")
export ngon, pole, triangle, square, pentagon, hexagon, heptagon, octagon, nonagon, decagon

include("static_svg.jl")
export StaticSVG

include("svg.jl")
export SVG, SVGNode, SVGText

include("node_style.jl")
export NodeStyle

include("edge_style.jl")
export EdgeStyle

include("euclid_node.jl")
export EuclidNode

include("euclid_edge.jl")
export EuclidEdge

include("euclid_graph.jl")
export EuclidGraph, addbiedge!, addbiedges!

include("svg_viz.jl")
export SVGViz

include("euclid_graph_svg.jl")
export EuclidGraphSVG, getxdoc

import SnoopPrecompile
include("other/precompile.jl")

end