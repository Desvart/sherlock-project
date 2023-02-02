% function multispace_plot()

%% Compute histograms



   
    carIdxArray = bsxfun(@plus, (1:5:nObsPerFile/2*nFiles)'*ones(1, nObsPerFile/2), 0:4);
    
    class1Array = carIdxArray(classE00, :)';
    class1Array = class1Array(:);

    class2Array = carIdxArray(classE0x, :)';
    class2Array = class2Array(:);
    
    
%%% Prealloc
class1 = nan(length(classE00)*10, nCarKept);
class2 = nan(length(classE0x)*10, nCarKept);
vectIdx = 0; 
    
for iVar = 1 : nCarKept,
    
    vectIdx = vectIdx(end) + (1:2);
    a = eval(varKept{iVar});
    aClass1T = a(class1Array, :)';
    aClass2T = a(class2Array, :)';
    class1(:, iVar) = aClass1T(:);
    class2(:, iVar) = aClass2T(:);
    
end
% 
% for iVar = 1 : nFeat,
%     
%     
% end



screenSize = get(0, 'ScreenSize');
figure('Color', 'white', ...
       'OuterPosition', screenSize + [screenSize(3)-1, 0, 0, 0]);
   
subplotDim = nFeat;
   
for j = 1 : 5,
    
    subplot(subplotDim, subplotDim, (j-1)*6+1);
    hold on;
    [a, b] = hist(class1(:, j), 50);
    [c, d] = hist(class2(:, j), 50);
    bar(b, a, 'b', 'EdgeColor', 'none', 'BarWidth', 1);
    bar(d, c, 'r', 'EdgeColor', 'none', 'BarWidth', 0.3);

    for i = (j-1)*6+1 + (1:(5-j)),
        subplot(subplotDim, subplotDim, i);
        hold on;
        k = mod(i-1, 5)+1;
        plot(class1(:, j), class1(:, k), '.b');
        plot(class2(:, j), class2(:, k), '.r');
        xlim([min([class1(:, j); class2(:, j)]), max([class1(:, j); class2(:, j)])]);
        ylim([min([class1(:, k); class2(:, k)]), max([class1(:, k); class2(:, k)])]);
    end
    
end

