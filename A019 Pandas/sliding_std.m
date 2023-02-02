function s = sliding_std( v, window)

    m1 = filter( ones(window,1)/window, 1, v);
    m2 = filter( ones(window,1)/window, 1, v.^2);
    s = sqrt(m2 - m1.^2); 
    
end