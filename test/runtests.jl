using EuclidGraphs
using Test

@testset "nodes as array or function" begin
    coords = [(0,0),(0,100),(95,31),(59,-81),(-59,-81), (-95,31)]
    g1 = EuclidGraph(
        coords, 
        node_style=(node)->NodeStyle(value="Z")
    )
    g2 = EuclidGraph(
        coords, 
        node_style=(node)->NodeStyle(value=(node) -> "Z"))
    str1 = string(g1())
    str2 = string(g2())
    @test str1 == str2
end

@testset "nodes value as primitive type or function" begin
    coords_a = [(0,0),(0,100),(95,31),(59,-81),(-59,-81), (-95,31)]
    coords_f() = coords_a
    str1 = string(EuclidGraph(coords_a)())
    str2 = string(EuclidGraph(coords_f)())
    @test str1 == str2
end

@testset verbose = true "Readme Examples" begin

    # Setup
    coords() = [(0,0),(0,100),(95,31),(59,-81),(-59,-81), (-95,31)]
    adj_mat = rand(0:1, 6, 6)

    @testset "example 1" begin
        g = EuclidGraph(coords, adj_mat=adj_mat)
        mktemp() do path, io
            write(path, g())
            @test isfile(path)
        end
    end

    @testset "example 2" begin
        f = EuclidGraph(
            coords, 
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
        str = string(f(node_features, edge_features))
        @test !isnothing(str)
    end

end