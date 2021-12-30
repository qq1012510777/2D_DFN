function f = If_pnt_inside_rectangle(pnt, Dom)
    x = pnt(1);
    y = pnt(2);

    if (x <= Dom.x_max && x >= Dom.x_min && ...
            y <= Dom.y_max && y >= Dom.y_min)
        f = 1;
    else
        f = 0;
    end

end
