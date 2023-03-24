struct EuclidGraphSVG <: AbstractSVG
    g::EuclidGraph
    node_features
    edge_features
    svg_width
    svg_height
    svg_view_box
    svg_style
    svg_class
end

function EuclidGraphSVG(
    g::EuclidGraph, 
    node_features, 
    edge_features; 
    svg_width=300,
    svg_height=300,
    svg_view_box=(-100,-100,200,200),
    svg_style="background-color:transparent;",
    svg_class=nothing,
    )
    EuclidGraphSVG(
        g,
        node_features,
        edge_features,
        svg_width,
        svg_height,
        svg_view_box,
        svg_style,
        svg_class,
    )
end

Base.string(e::EuclidGraphSVG) = string(getsvg(e))

function getsvgverts(s::EuclidGraphSVG)
    (; node_features, g) = s
    (; node_radius) = g
    full_r = node_radius
    inner_r = (2/3) * full_r
    points = g.nodes()
    map(enumerate(points)) do (idx, point)
        euclid_node = EuclidNode(idx, point, node_features)
        user_style = getnodestyle(g, euclid_node)
        (; 
            value, 
            stroke, 
            stroke_width, 
            fill, 
            inner_fill, 
            font_size,
            font_size,
            text_anchor,
            dominant_baseline,
            font_color,
            font_family,
            value_x,
            value_y,
        ) = user_style
        cx, cy = point
        tx, ty = value_x(euclid_node), value_y(euclid_node)
        label_x = cx + full_r
        label_y = -(cy + full_r)
        text_content = value(euclid_node)
        if isnothing(text_content)
            text = ""
        else
            text = """
                <text 
                    x="$tx" 
                    y="$ty" 
                    text-anchor="$text_anchor" 
                    dominant-baseline="$dominant_baseline" 
                    fill="$font_color" 
                    font-family="$font_family" 
                    font-size="$font_size"
                    >
                    $(text_content)
                </text>
            """
        end
        """
            <circle cx="$cx" cy="$cy" r="$full_r" fill="$fill" stroke-width="$stroke_width" stroke="$stroke" transform="scale(1,-1)"/>
            <circle cx="$cx" cy="$cy" r="$inner_r" stroke-width="0" fill="$inner_fill" transform="scale(1,-1)" />
            $text
        """
    end
end

function getedgeswitharrows(e)
    (; edge_features, g) = e
    (; node_radius) = g
    full_r = node_radius
    nodes = g.nodes()
    map(enumerate(getuniedges(g))) do (idx, edge)
        i, j = edge
        user_style = getedgestyle(g, EuclidEdge(idx, edge, edge_features))
        (; 
            directed_stroke,
            directed_stroke_width,
            directed_opacity,
        ) = user_style
        src_node = nodes[i]
        dst_node = nodes[j]
        x1, y1 = src_node
        x2, y2 = dst_node
        diff = [x2, y2] .- [x1, y1]
        len = norm(diff)
        if iszero(len)
            return ""
        end
        len_padded = len - (3*full_r)
        degs = vec2degs(diff)
        """
            <line 
                x1="0" 
                y1="0" 
                x2="$len_padded" 
                y2="0" 
                stroke-width="$directed_stroke_width" 
                stroke="$directed_stroke"
                opacity="$directed_opacity"
                transform="scale(1,-1) translate($(x1), $(y1)) rotate($(degs)) translate($(1.5*full_r), 0)" 
            />
        """
    end
end

function getedgeswithoutarrows(e)
    (; edge_features, g) = e
    (; node_radius) = g
    full_r = node_radius
    nodes = g.nodes()
    map(enumerate(getbiedges(g))) do (idx, edge)
        i, j = edge
        src_node = nodes[i]
        dst_node = nodes[j]
        x1, y1 = src_node
        x2, y2 = dst_node
        diff = [x2, y2] .- [x1, y1]
        len = norm(diff)
        if iszero(len)
            return ""
        end
        len_padded = len - (2.5*full_r)
        degs = vec2degs(diff)
        color = "#ccc"
        user_style = getedgestyle(g, EuclidEdge(idx, edge, edge_features))
        (; 
            undirected_stroke,
            undirected_stroke_width,
            undirected_opacity,
        ) = user_style
        """ 
            <line 
                x1="0" 
                y1="0" 
                x2="$len_padded" 
                y2="0" 
                stroke-width="$undirected_stroke_width" 
                stroke="$undirected_stroke" 
                opacity="$undirected_opacity"
                transform="scale(1,-1) translate($(x1), $(y1)) rotate($(degs)) translate($(1.25*full_r), 0)"
            />
        """
    end
end

function getarrows(e)
    (; edge_features, g) = e
    (; node_radius) = g
    full_r = node_radius
    nodes = g.nodes()
    arrows = map(enumerate(getuniedges(g))) do (idx, edge)
        i, j = edge
        src_node = nodes[i]
        dst_node = nodes[j]
        x1, y1 = src_node
        x2, y2 = dst_node
        diff = [x2, y2] .- [x1, y1]
        len = norm(diff)
        if iszero(len)
            return ""
        end
        dst_degs = vec2degs([x1, y1] .- [x2, y2])
        user_style = getedgestyle(g, EuclidEdge(idx, edge, edge_features))
        (; 
            arrow_color,
        ) = user_style
        """
            <polygon 
                points="$(13+full_r),-5 $(3+full_r),0 $(13+full_r),5" 
                fill="$arrow_color" 
                transform="scale(1,-1) translate($(x2), $(y2)) rotate($dst_degs)" 
            />
        """
    end 
end

function getchildren(e::EuclidGraphSVG)
    SVGNode("""
        <g>
            $(join(getedgeswithoutarrows(e), " "))
            $(join(getedgeswitharrows(e), " "))
            $(join(getarrows(e), " "))
            $(join(getsvgverts(e), " "))
        </g>
    """).node
end

