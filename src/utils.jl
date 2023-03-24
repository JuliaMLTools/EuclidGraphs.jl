function vec2degs(v)
    unit_v = v ./ norm(v)
    x, y = unit_v
    quadrant_rads = asin(abs(y))
    quadrant_degs = (quadrant_rads / pi) * 180
    if x >= 0 && y >= 0
        return quadrant_degs
    elseif x < 0 && y >= 0
        return 180 - quadrant_degs
    elseif x < 0 && y < 0
        return 180 + quadrant_degs
    end
    360 - quadrant_degs
end

"""
    Get all bidirectional edges in the graph.
"""
function getbiedges(adj_mat::AbstractMatrix)
    all_edges = getalledges(adj_mat)
    bidirectional = filter(e -> adj_mat[e[2], e[1]] == 1, all_edges)
    Tuple.(sort.(collect.(bidirectional))) |> unique
end

"""
    Get all edges in the graph.
"""
getalledges(adj_mat) = Tuple.(findall(adj_mat .== 1))

"""
    Get all self-directed edges in the graph.
"""
function getselfdirectededges(adj_mat::AbstractMatrix)
    all_edges = getalledges(adj_mat)
    filter(e -> e[1] == e[2], all_edges)
end

"""
    Get all unidirectional edges in the graph.
"""
function getuniedges(adj_mat::AbstractMatrix)
    all_edges = getalledges(adj_mat)
    filter(e -> adj_mat[e[2], e[1]] == 0, all_edges)
end

function getnonselfbiedges(adj_mat::AbstractMatrix)
    setdiff(Set(getbiedges(adj_mat)), Set(getselfdirectededges(adj_mat)))
end

"""
    Add bidirectional edged.
"""
function addbiedge!(adj_mat::AbstractMatrix, i, j)
    adj_mat[i, j] = 1
    adj_mat[j, i] = 1
end

"""
    Add unidirectional edge.
"""
function adduniedge!(adj_mat::AbstractMatrix, i, j)
    adj_mat[i, j] = 1
end

"""
    Add self-directed edge.
"""
function addselfedge!(adj_mat::AbstractMatrix, i)
    adj_mat[i, i] = 1
end