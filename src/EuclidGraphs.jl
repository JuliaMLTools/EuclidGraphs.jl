module EuclidGraphs

include("imports.jl")
include("utils.jl")
include("abstract_svg.jl")
include("svg.jl")

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
export EuclidGraphSVG, getsvg

import SnoopPrecompile
include("other/precompile.jl")

end