function [c1, c2] = appel2(struct)

    h2 = struct.h;

    for i = 1:10,
        j = i;
        
        tic;
        c2 = h2(j*2, j^2);
        toc
        
        tic;
        c1 = struct.h(i*2, i^2);
        toc
        
        
        
    end

end