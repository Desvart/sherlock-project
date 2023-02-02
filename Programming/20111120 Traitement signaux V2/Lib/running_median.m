function signalFiltered = running_median(signal, sWindow)

    sSignal = length(signal);
    signalFiltered = zeros(1, sSignal);
    for i = sWindow : sSignal,
        signalFiltered(i) = median(signal(i-sWindow+1 : i));
    end
end
