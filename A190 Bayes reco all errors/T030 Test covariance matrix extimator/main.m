
nC1 = 12;
nC2 = 18;
nClasses = 2;

nObsPerClassArr = [nC1, nC2];
nObs = nC1*nC2;

garbageProba = [0, 0]/100;
garbageProba = [0, 10]/100;

confMatEstimator = nan(12, 18);

for i1 = 1 : nC1+1,
    for i2 = 1 : nC2+1,
        
        confusionMat = [nC1-i1+1,     i1-1;...
                            i2-1, nC2-i2+1];
                        
        confusionMatEquil = bsxfun(@times, confusionMat, [nC2; nC1]);
        
        confusionMatEquilNorm = confusionMatEquil / (nC1*nC2*2);
                         
%         a1 = (confusionMatEquilNorm(1, 1) / sum(confusionMatEquilNorm(:, 1)) - 1)^2 / (1-garbageProba(1))^2;
%         a2 = (confusionMatEquilNorm(2, 2) / sum(confusionMatEquilNorm(:, 2)) - 1)^2 / (1-garbageProba(2))^2;

        a1 = (confusionMatEquilNorm(1, 1) / sum(confusionMatEquilNorm(:, 1)) - 1)^2 + 0.5^2*(garbageProba(1));
        a2 = (confusionMatEquilNorm(2, 2) / sum(confusionMatEquilNorm(:, 2)) - 1)^2 + 0.5^2*(garbageProba(2));
        
        confMatEstimator(i1, i2) = a1 + a2;

    end
end


% figure; 

subplot(1,2,1); hold on;
plot(confMatEstimator', 'k');
subplot(1,2,2); hold on
plot(confMatEstimator, 'k');
