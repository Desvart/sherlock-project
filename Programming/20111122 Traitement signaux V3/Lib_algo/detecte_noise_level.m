function noiseLevel = detecte_noise_level(histogram, histogramFreq, energyMedian, shouldPlot)

% Au lieu d'utiliser des valeurs arbitraires 1/4 et 3/4 (peu robuste), on doit pouvoir faire un 
% histogramme dans le temps (fenêtrage dans le temps) pour détecter les deux flancs raides et
% positionner les limitations actuellement définies par 1/4 et 3/4. Attention cette méthode ne
% marche que si l'histogramme du signal présente un petit replat cassant les flancs raides. A
% vérifier d'une montre à l'autre.


    if nargin == 3,
        shouldPlot = false;
    end

dbstop in detecte_noise_level at 38
    id = find(histogramFreq>10*log10(energyMedian), 1);
    histFreq2 = histogramFreq(histogramFreq>10*log10(energyMedian));
    hist2     = histogram(histogramFreq>10*log10(energyMedian));

    sHist3 = 20;
    [histo3, histFreq3] = hist(hist2, sHist3);
    roi = round(sHist3/4):round(sHist3*3/4); 
    [maxVal, maxId] = max(histo3(roi));
    
    maxId2 = find(histo3>maxVal, 1, 'last');
    
    tmpLevel = histFreq3(round((maxId+roi(1)-1+maxId2)/2));
    
    noiseLevelId1 = find(hist2<tmpLevel, 1, 'first');
    noiseLevelId2 = find(hist2>tmpLevel, 1, 'last');
    if abs(hist2(noiseLevelId1) - tmpLevel) <= abs(hist2(noiseLevelId2) - tmpLevel),
        noiseLevelId = noiseLevelId1;
    else
        noiseLevelId = noiseLevelId2;
    end
    noiseLevel = histFreq2(noiseLevelId);
    noiseLevel = histFreq2(24);
    
    
    if shouldPlot == true,
       
        figure('color', 'white');
        
        subplot(5,5,2:5); hold on;
        plot(histogramFreq, histogram/1e3);
        stem(10*log10(energyMedian), max(histogram/1e3), '.k');
        stem(histogramFreq(id+noiseLevelId), max(histogram/1e3), '.r');
        stem(max(histogramFreq), max(histogram/1e3), '.k');
        axis tight;
        legend('Signal histogram', 'RoI delimitation', 'Detected noise level');
        xlabel('Energy [dB]');
        ylabel('Nb. of samples [kS]');
        
        subplot(5,5,[7:10, 12:15, 17:20, 22:25]); hold on;
        plot(histFreq2, hist2/1e3);
        stem(noiseLevel, max(histFreq3)/1e3, '.r');
        plot(histFreq2, repmat(linspace(min(hist2), max(hist2), sHist3+1)/1e3, length(hist2), 1), '--k');
        plot(histFreq2, (histFreq3(round((maxId+roi(1)-1+maxId2)/2))/1e3)*ones(1, length(histFreq2)), '-r');
        axis tight;
        legend('Signal histogram (RoI)', 'Detected noise level', 'Histogram levels');
        xlabel('Energy [dB]');
        ylabel('Nb. of samples [kS]');
        
        subplot(5,5,6:5:21); hold on;
        plot(histo3, histFreq3/1e3);
        set(gca, 'xDir', 'reverse');
        plot(histo3, ((round(max(histFreq3))/4)/1e3)*ones(1, length(histo3)), '-g');
        plot(maxVal, histFreq3(roi(1)-1+maxId)/1e3, '*r');
        plot(histo3(maxId2), histFreq3(maxId2)/1e3, '*k');
        plot(histo3, (histFreq3(round((maxId+roi(1)-1+maxId2)/2))/1e3)*ones(1, length(histo3)), '-r');
        plot(histo3, ((round(max(histFreq3))*3/4)/1e3)*ones(1, length(histo3)), '-g');
        axis tight;
        legend('Histogram of the signal histogram (RoI)', 'RoI delimitation', 'Detected pic 1', 'Detected pic 2', 'Mean level between detected pics');
        xlabel('Nb. of samples [Samples]');
        ylabel('Nb. of samples [kS]');
        
    end
    
end



% 
% delay=10;
% a = hist2(delay:end) - hist2(1:end-delay+1);
% figure; plot(a);







