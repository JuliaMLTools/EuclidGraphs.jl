cd(@__DIR__)
import Pkg
Pkg.activate(".")

using EuclidGraphs
logo = EuclidGraph(
    [(-50,0),(0,75),(0,25),(0,-25),(0,-75),(50, 25),(50,-25)], 
    node_style=(node) -> NodeStyle(
        inner_fill=node.features[node.idx],
        value=nothing,
    ),
    edge_style=(edge) -> EdgeStyle(stroke="#ccc"),
    fully_connected=false,
)
addbiedges!(logo, [(1,3),(1,2),(1,5),(1,4),(2,6),(5,7),(4,6),(3,7)])
node_features = ["#4162D9","#389825","#9558B2","#9558B2","#389825","#CB3C33","#CB3C33"]
logo(node_features; svg_style="background-color:transparent;") # Renders in VSCode
write("logo.svg", logo(node_features))