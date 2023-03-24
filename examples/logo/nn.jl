cd(@__DIR__)
import Pkg
Pkg.activate(".")

using EuclidGraphs

basic = EuclidGraph(
    [(-50,0),(0,75),(0,25),(0,-25),(0,-75),(50, 25),(50,-25)], 
    node_style=(node) -> NodeStyle(
        inner_fill=node.features[node.idx],
        stroke="#666",
        value=nothing,
    ),
    edge_style=(edge) -> EdgeStyle(
        stroke="#ccc",
    ),
    fully_connected=false,
)

addbiedges!(basic, [(1,3),(1,2),(1,5),(1,4),(2,6),(5,7),(4,6),(3,7)])

out = basic(
    [
        "#4162D9",
        "#389825",
        "#9558B2",
        "#9558B2",
        "#389825",
        "#CB3C33",
        "#CB3C33"
    ];
    svg_width=400,
    svg_height=400,
    svg_view_box=(-100,-100,200,200),
    svg_style=nothing,
)
write("logo.svg", out)