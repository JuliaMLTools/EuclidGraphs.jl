struct EuclidGraph{C, A, N, E, G, NR<:Real}
    nodes::C
    adj_mat::A
    node_style::N
    edge_style::E
    graph_style::G
    node_radius::NR
end

function EuclidGraph(nodes::AbstractVector; kwargs...)
    EuclidGraph(()->nodes; kwargs...)
end

function EuclidGraph(
    nodes::Function; 
    node_style=nothing, 
    edge_style=nothing, 
    graph_style=nothing, 
    adj_mat=nothing,
    node_radius=12,
    fully_connected=false,
    )
    if isnothing(adj_mat)
        if fully_connected
            adj_mat = ones(Int, length(nodes()), length(nodes()))
        else
            adj_mat = zeros(Int, length(nodes()), length(nodes()))
        end
    end
    @assert ndims(adj_mat) == 2
    num_nodes = size(adj_mat, 1)
    num_edges = findall(isone(adj_mat))
    @assert length(nodes()) == num_nodes
    EuclidGraph(
        nodes, 
        adj_mat,
        node_style, 
        edge_style, 
        graph_style,
        node_radius,
    )
end

Broadcast.broadcastable(e::EuclidGraph) = Ref(e)
getuniedges(e::EuclidGraph) = getuniedges(e.adj_mat)
getbiedges(e::EuclidGraph) = getbiedges(e.adj_mat)
getnonselfbiedges(e::EuclidGraph) = getnonselfbiedges(e.adj_mat)

function addbiedges!(e::EuclidGraph, edges::AbstractVector)
    addbiedge!.(e, edges)
end

(e::EuclidGraph)(; kwargs...) = EuclidGraphSVG(e, nothing, nothing; kwargs...)
(e::EuclidGraph)(nf; kwargs...) = EuclidGraphSVG(e, nf, nothing; kwargs...)
(e::EuclidGraph)(nf, ef; kwargs...) = EuclidGraphSVG(e, nf, ef; kwargs...)

function getnodestyle(e::EuclidGraph, node::EuclidNode)
    if !isnothing(e.node_style)
        return e.node_style(node)
    end
    NodeStyle()
end

function getedgestyle(e::EuclidGraph, euclid_edge)
    if !isnothing(e.edge_style)
        return e.edge_style(euclid_edge)
    end
    EdgeStyle()
end

addbiedge!(e::EuclidGraph, (i,j)) = addbiedge!(e, i, j)

function addbiedge!(e::EuclidGraph, i, j)
   addbiedge!(e.adj_mat, i, j)
end