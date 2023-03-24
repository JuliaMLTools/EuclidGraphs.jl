struct NodeStyle
    value
    stroke
    stroke_width
    fill
    inner_fill
    font_size
    text_anchor
    dominant_baseline
    font_color
    font_family
    value_x
    value_y
    function NodeStyle(;
        value=(node)->node.idx,
        stroke="#333",
        stroke_width=3,
        fill="transparent",
        inner_fill="transparent",
        font_size=12,
        text_anchor="middle",
        dominant_baseline="middle",
        font_color="#333",
        font_family="Arial",
        value_x=nothing,
        value_y=nothing,
        )
        if isnothing(value)
            value = (node) -> nothing
        elseif !isa(value, Function)
            value_str = string(value)
            value = (node) -> value_str
        end
        if isnothing(value_x)
            value_x = (node)->node.coords[1]
        end 
        if isnothing(value_y)
            value_y = (node)->(-(node.coords[2]-1))
        end
        new(
            value,
            stroke,
            stroke_width,
            fill,
            inner_fill,
            font_size,
            text_anchor,
            dominant_baseline,
            font_color,
            font_family,
            value_x,
            value_y,
        )
    end
end



