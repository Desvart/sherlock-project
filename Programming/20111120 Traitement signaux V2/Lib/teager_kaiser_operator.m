function signalEnergyTko = teager_kaiser_operator(signal, padingCondition)

    if nargin == 1 || strcmp(padingCondition, '0') || padingCondition == 0,
        pading = 0;
    end
    if nargin == 2 && strcmp(padingCondition, 'mean'),
        pading = mean(signal);
    end
    if nargin == 2 && strcmp(padingCondition, 'median'),
        pading = median(signal);
    end
    
    signalEnergyStd = signal.^2;
    signalEnergyTko = signalEnergyStd - [signal(2:end), pading] .* [pading, signal(1:end-1)];

end
