[![][docs-dev-img]][docs-dev-url]

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://juliamltools.github.io/EuclidGraphs.jl/dev/

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://juliamltools.github.io/EuclidGraphs.jl/stable/

# EuclidGraphs.jl

## Example 1: Basic graph

```julia
using EuclidGraphs
nodes = [(0,-10),(0,70),(75,21),(49,-70),(-49,-70),(-75,21)]
g1 = EuclidGraph(nodes, adj_mat=rand(0:1, 6, 6))
g1() # Renders in VSCode
write("basic.svg", g1())
```

<p align="center">
    <img width="400px" src="https://raw.githubusercontent.com/JuliaMLTools/EuclidGraphs.jl/main/docs/src/assets/basic.svg"/>
</p>


## Example 2: Styled graph

```julia
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
```

<p align="center">
    <img width="400px" src="https://raw.githubusercontent.com/JuliaMLTools/EuclidGraphs.jl/main/docs/src/assets/styled.svg"/>
</p>

## Example 3: The EuclidGraphs.jl logo

```julia
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
write("logo.svg", logo(node_features))
```

<p align="center">
    <img width="400px" src="https://raw.githubusercontent.com/JuliaMLTools/EuclidGraphs.jl/main/docs/src/assets/logo.svg"/>
</p>