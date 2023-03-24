cd(@__DIR__)
import Pkg
Pkg.activate(".")

using EuclidGraphs

################################
# Setup
################################

nodes() = [
    (0,0),
    (0,90),
    (95,21),
    (59,-90),
    (-59,-90),
    (-95,31),
]
adj_mat = rand(0:1, 6, 6)

################################
# Example 1: Basic Graph
################################

basic = EuclidGraph(nodes, adj_mat=adj_mat)
basic()
write("basic.svg", basic())

################################
# Example 2: Featured Graph
################################

f = EuclidGraph(
    nodes, 
    adj_mat=adj_mat,
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
num_edges = length(filter(isone, adj_mat[:]))
num_nodes = size(adj_mat, 1)
node_features = zeros(Int, num_nodes)
node_features[rand(1:num_nodes)] = 1
edge_features = rand(["red", "#273E5B", "#273E5B", "#9493F2"], num_edges)
f(node_features, edge_features) 
write("ex1.svg", f(node_features, edge_features))