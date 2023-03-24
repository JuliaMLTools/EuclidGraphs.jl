struct EdgeStyle
    directed_stroke_width
    directed_stroke
    arrow_color
    undirected_stroke
    undirected_stroke_width
    directed_opacity
    undirected_opacity
    function EdgeStyle(;
        stroke="#333",
        stroke_width=3,
        opacity=1,
        directed_stroke_width=nothing,
        directed_stroke=nothing,
        arrow_color=nothing,
        undirected_stroke=nothing,
        undirected_stroke_width=nothing,
        directed_opacity=nothing,
        undirected_opacity=nothing,
        )
        if isnothing(directed_stroke_width)
            directed_stroke_width = stroke_width
        end
        if isnothing(directed_stroke)
            directed_stroke = stroke
        end
        if isnothing(arrow_color)
            arrow_color = stroke
        end
        if isnothing(undirected_stroke)
            undirected_stroke = stroke
        end
        if isnothing(undirected_stroke_width)
            undirected_stroke_width = stroke_width
        end
        if isnothing(directed_opacity)
            directed_opacity = opacity
        end
        if isnothing(undirected_opacity)
            undirected_opacity = opacity
        end
        new(
            directed_stroke_width,
            directed_stroke,
            arrow_color,
            undirected_stroke,
            undirected_stroke_width,
            directed_opacity,
            undirected_opacity,
        )
    end
end