function plot_ESPS(ticMeanArray, ticStdArray, tacMeanArray, tacStdArray, yStrLabel, titleStr)


    colorArray = [  0,   0, 142; ...
                    0,  79, 255; ...
                   31, 255, 223; ...
                  239, 255,  15; ...
                  255,  63,   0; ...
                  127,   0,   0] / 255;
 
    hold on;

    h = stem(1-0.25:1:3.30, ticMeanArray(:, 1));
    set(h, 'LineWidth', 5, 'Marker', 'none', 'Color', colorArray(1, :));
    h = stem(1-0.22:1:3.30, tacMeanArray(:, 1));
    set(h, 'LineWidth', 5, 'Marker', '+', 'Color', colorArray(1, :));
    set(h, 'MarkerSize', 3, 'MarkerEdgeColor', [127, 127, 127]/255);
    
    
    %%%
    for iBarilletLevel = 2 : 6,
        h = stem(1-0.15+0.1*(iBarilletLevel-2):1:3.30, ticMeanArray(:, iBarilletLevel) );
        set(h, 'LineWidth', 5, 'Marker', 'none', 'Color', colorArray(iBarilletLevel, :));
    end
    
    for iBarilletLevel = 2 : 6,
        h = stem(1-0.12+0.1*(iBarilletLevel-2):1:3.30, tacMeanArray(:, iBarilletLevel) );
        set(h, 'LineWidth', 5, 'Marker', '+', 'Color', colorArray(iBarilletLevel, :));
        set(h, 'MarkerSize', 3, 'MarkerEdgeColor', [127, 127, 127]/255);
    end
    
    for iBarilletLevel = 1 : 6,
        xPos = 1-0.25+0.1*(iBarilletLevel-1):1:3.30;
        plot(xPos, ticMeanArray(:, iBarilletLevel)+1*ticStdArray(:, iBarilletLevel), '^', 'Color', colorArray(iBarilletLevel, :), 'MarkerSize', 3);
        plot(xPos, ticMeanArray(:, iBarilletLevel)-1*ticStdArray(:, iBarilletLevel), 'v', 'Color', [255, 255, 255]/255, 'MarkerSize', 3);   
        xPos = xPos + 0.03;
        plot(xPos, tacMeanArray(:, iBarilletLevel)+1*tacStdArray(:, iBarilletLevel), '^', 'Color', colorArray(iBarilletLevel, :), 'MarkerSize', 3);
        plot(xPos, tacMeanArray(:, iBarilletLevel)-1*tacStdArray(:, iBarilletLevel), 'v', 'Color', [255, 255, 255]/255, 'MarkerSize', 3);
    end
    
    %%%
%     h = stem(1-0.12:1:3.30, tacMeanArray(:,2) );
%     set(h, 'LineWidth', 5, 'Marker', 'square', 'Color', [0, 79, 255]/255);
%     set(h, 'Marker', '+', 'MarkerSize', 3, 'MarkerEdgeColor', [127, 127, 127]/255);
%     h = stem(1-0.02:1:3.30, tacMeanArray(:,3) );
%     set(h, 'LineWidth', 5, 'Marker', 'square', 'Color', [31, 255, 223]/255);
%     set(h, 'Marker', '+', 'MarkerSize', 3, 'MarkerEdgeColor', [127, 127, 127]/255);
%     h = stem(1+0.08:1:3.30, tacMeanArray(:,4) );
%     set(h, 'LineWidth', 5, 'Marker', 'square', 'Color', [239, 255, 15]/255);
%     set(h, 'Marker', '+', 'MarkerSize', 3, 'MarkerEdgeColor', [127, 127, 127]/255);
%     h = stem(1+0.18:1:3.30, tacMeanArray(:,5) );
%     set(h, 'LineWidth', 5, 'Marker', 'square', 'Color', [255, 63, 0]/255);
%     set(h, 'Marker', '+', 'MarkerSize', 3, 'MarkerEdgeColor', [127, 127, 127]/255);
%     h = stem(1+0.28:1:3.30, tacMeanArray(:,6) );
%     set(h, 'LineWidth', 5, 'Marker', 'square', 'Color', [127, 0, 0]/255);
%     set(h, 'Marker', '+', 'MarkerSize', 3, 'MarkerEdgeColor', [127, 127, 127]/255);

    allMean = [ticMeanArray; tacMeanArray];
    allStd  = [ticStdArray; tacStdArray];
    yLimMin = min(min(allMean)) - max(max(allStd)) * 0.95;
    yLimMax = max(max(allMean)) + max(max(allStd)) * 1.05;
    ylim([yLimMin, yLimMax] );
    set(gca,'XTick',1:3, 'XTickLabel',1:3);

    xlabel('Id. du mouvement');
    ylabel(yStrLabel);
    legend('1 tour de remontage - Tic', ...
           '1 tour de remontage - Tac', ...
           '2 tour de remontage', ...
           '3 tour de remontage', ...
           '4 tour de remontage', ...
           '5 tour de remontage', ...
           '6 tour de remontage');

    title(titleStr);



end
