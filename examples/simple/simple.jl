cd(@__DIR__)
import Pkg
Pkg.activate(".")
using EuclidGraphs

###
# Example 1: Basic Graph
###

nodes = [(0,-10),(0,70),(75,21),(49,-70),(-49,-70),(-75,21)]
g1 = EuclidGraph(nodes, adj_mat=rand(0:1, 6, 6))
g1() # Renders in VSCode
write("basic.svg", g1())

###
# Example 2: Featured Graph
###

g2 = EuclidGraph(
    [(0,-10),(0,70),(75,21),(49,-70),(-49,-70),(-75,21)], 
    adj_mat=rand(0:1, 6, 6),
    node_style=(node) -> NodeStyle(
        inner_fill=(isone(node.features[node.idx]) ? "green" : "#ccc"),
        font_color="white",
        stroke=(iseven(node.idx) ? "blue" : "#333"),
        value=(node) -> nothing,
    ),
    edge_style=(edge) -> EdgeStyle(
        directed_stroke=edge.features[edge.idx],
        arrow_color=edge.features[edge.idx],
        undirected_stroke="#ccc",
    ),
)
num_edges = length(filter(isone, g2.adj_mat))
num_nodes = size(g2.adj_mat, 1)
node_features = zeros(Int, num_nodes)
node_features[rand(1:num_nodes)] = 1
edge_features = rand(["red", "#273E5B", "#273E5B", "#9493F2"], num_edges)
g2(node_features, edge_features) # Renders in VSCode
write("styled.svg", g2(node_features, edge_features))

###
# Example 3: The EuclidGraphs.jl logo
###

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
svg = logo(node_features; svg_style="background-color:transparent;") # Renders in VSCode
write("logo.svg", svg)

###
# Example 4: Shapes
###

shapes = [pole triangle square; pentagon hexagon heptagon; octagon nonagon decagon]
svgs = [g(; svg_width=200, svg_height=200) for g in EuclidGraph.(shapes; fully_connected=true)]
grid = SVG(svgs) # Renders in VSCode
write("grid.svg", grid)

###
# Example 5: Graph Neural Network X/Y/Ŷ visualization
###

num_nodes = 6
xgraph = EuclidGraph(ngon(num_nodes), fully_connected=true)
targetgraph = EuclidGraph(
    ngon(num_nodes),
    adj_mat=rand([0,0,0,1], num_nodes, num_nodes),
    node_style=(node) -> NodeStyle(
        stroke="#ccc",
        inner_fill=(isone(node.features[node.idx]) ? "green" : "#fff"),
        value=(node) -> nothing
    ),
    edge_style=(edge) -> EdgeStyle(
        stroke="green",
    )
)
y_features = ŷ_features = rand([0,0,1], num_nodes)
x = SVG([SVGText("X"), xgraph()])
y = SVG([SVGText("Y"), targetgraph(y_features)])
ŷ = SVG([SVGText("Ŷ"), targetgraph(ŷ_features)])
gnn = SVG([x,y,ŷ], dims=2) # Renders in VSCode
write("gnn.svg", gnn)