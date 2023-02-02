function zeroCrossing = zero_crossing_signal(signal, sWindow)

    zeroCrossingDetection = zeros(1, length(signal));
    zeroCrossingDetection((signal(1:end-1) .* signal(2:end)) < 0) = 1;
    zeroCrossing = running_mean(zeroCrossingDetection, sWindow);

end
