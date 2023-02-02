function plot_ESPS2(tocArray, yStrLabel, titleStr)


    colorArray = [  0,   0, 142; ...
                    0,  79, 255; ...
                  196,  52, 198; ...
                   79, 188,  13; ...
                  255,  63,   0; ...
                  127,   0,   0] / 255;
              
lineWidth = 3;
 
    hold on;

    h = stem(1-0.25:1:3.30, tocArray(:, 1, 1));
    set(h, 'LineWidth', lineWidth, 'Marker', 'none', 'Color', colorArray(1, :));
    h = stem(1-0.22:1:3.30, tocArray(:, 1, 3));
    set(h, 'LineWidth', lineWidth, 'Marker', '+', 'Color', colorArray(1, :));
    set(h, 'MarkerSize', 3, 'MarkerEdgeColor', [127, 127, 127]/255);
    
    
    %%%
    for iBarilletLevel = 2 : 6,
        h = stem(1-0.15+0.1*(iBarilletLevel-2):1:3.30, tocArray(:, iBarilletLevel, 1) );
        set(h, 'LineWidth', lineWidth, 'Marker', 'none', 'Color', colorArray(iBarilletLevel, :));
    end
    
    for iBarilletLevel = 1 : 1,
        xPos = 1-0.25+0.1*(iBarilletLevel-1):1:3.30;
        plot(xPos, tocArray(:, iBarilletLevel, 1)+1*tocArray(:, iBarilletLevel, 2), '^', 'Color', colorArray(iBarilletLevel, :), 'MarkerSize', 3);
        plot(xPos, tocArray(:, iBarilletLevel, 1)-1*tocArray(:, iBarilletLevel, 2), 'v', 'Color', [240, 240, 240]/255, 'MarkerSize', 3);   
        xPos = xPos + 0.03;
        plot(xPos, tocArray(:, iBarilletLevel, 3)+1*tocArray(:, iBarilletLevel, 4), '^', 'Color', colorArray(iBarilletLevel, :), 'MarkerSize', 3);
        plot(xPos, tocArray(:, iBarilletLevel, 3)-1*tocArray(:, iBarilletLevel, 4), 'v', 'Color', [240, 240, 240]/255, 'MarkerSize', 3);
    end
    
    for iBarilletLevel = 2 : 6,
        h = stem(1-0.12+0.1*(iBarilletLevel-2):1:3.30, tocArray(:, iBarilletLevel, 3) );
        set(h, 'LineWidth', lineWidth, 'Marker', '+', 'Color', colorArray(iBarilletLevel, :));
        set(h, 'MarkerSize', 3, 'MarkerEdgeColor', [127, 127, 127]/255);
    end
    
    
    for iBarilletLevel = 2 : 6,
        xPos = 1-0.25+0.1*(iBarilletLevel-1):1:3.30;
        plot(xPos, tocArray(:, iBarilletLevel, 1)+1*tocArray(:, iBarilletLevel, 2), '^', 'Color', colorArray(iBarilletLevel, :), 'MarkerSize', 3);
        plot(xPos, tocArray(:, iBarilletLevel, 1)-1*tocArray(:, iBarilletLevel, 2), 'v', 'Color', [240, 240, 240]/255, 'MarkerSize', 3);   
        xPos = xPos + 0.03;
        plot(xPos, tocArray(:, iBarilletLevel, 3)+1*tocArray(:, iBarilletLevel, 4), '^', 'Color', colorArray(iBarilletLevel, :), 'MarkerSize', 3);
        plot(xPos, tocArray(:, iBarilletLevel, 3)-1*tocArray(:, iBarilletLevel, 4), 'v', 'Color', [240, 240, 240]/255, 'MarkerSize', 3);
    end
    
    
    

    
    yLimMax = max(max(max(((tocArray(:,:, [1, 3]) + tocArray(:,:, [2, 4])) * 1.05))));
    yLimMin = min(min(min(((tocArray(:,:, [1, 3]) - tocArray(:,:, [2, 4])) * 0.95))));
    ylim([yLimMin, yLimMax] );
    set(gca,'XTick',1:3, 'XTickLabel',1:3);

    xlabel('Id. du mouvement');
    ylabel(yStrLabel);
%     legend('1 tour de remontage - Tic', ...
%            '1 tour de remontage - Tac', ...
%            '2 tour de remontage', ...
%            '3 tour de remontage', ...
%            '4 tour de remontage', ...
%            '5 tour de remontage', ...
%            '6 tour de remontage');

    title(titleStr);



end
