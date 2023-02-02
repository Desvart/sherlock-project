%%% Plot results

% - Time domain results
figure('color', 'white');

% Raw signal
subplot(4, 1, 1);
plot(tAxis*1e3, signal);
title('Raw signal');
xlabel('Time [ms]');
ylabel('Amplitude [-]');
axis tight;


% Signal energy
subplot(4, 1, 2); hold on;
plot(tAxis*1e3, signalEnergyStd/max(signalEnergyStd), 'b');
plot(tAxis*1e3, signalEnergyTko/max(signalEnergyTko), 'r');
title('Signal energy');
xlabel('Time [ms]');
ylabel('Normalized energy [-]');
axis tight;
legend('Standard energy (e[n] = x[n]^2)', 'Teager-Kaiser energy (e[n] = x[n]^2 - x[n-1]*x[n+1])');

% Signal power [-]
subplot(4, 1, 3); hold on;
plot(tAxis*1e3, signalPowerStd/max(signalPowerStd), 'b');
plot(tAxis*1e3, signalPowerTko/max(signalPowerTko), 'r');
title(['Signal power (window = ', num2str(powerWinDuration*1e3), ' ms = ', num2str(sPowerWin), ' samples)']);
xlabel('Time [ms]');
ylabel('Normalized power [-]');
axis tight;
legend('Power from standard energy', 'Power from Teager-Kaiser energy');

% Power levels
plot(tAxis*1e3, meanPowerStdLevel*ones(1, sSignal), '--r');
plot(tAxis*1e3, meanPowerTkoLevel*ones(1, sSignal), '--k');

% Signal power [dB]
subplot(4, 1, 4); hold on;
plot(tAxis*1e3, 10*log10(signalPowerStd/max(signalPowerStd)), 'b');
plot(tAxis*1e3, 10*log10(signalPowerTko/max(signalPowerTko)), 'r');
title(['Signal power (window = ', num2str(powerWinDuration*1e3), ' ms = ', num2str(sPowerWin), ' samples)']);
xlabel('Time [ms]');
ylabel('Normalized power [dB]');
axis tight;
legend('Power from standard energy', 'Power from Teager-Kaiser energy');

% Power levels
plot(tAxis*1e3, 10*log10(meanPowerStdLevel/max(signalPowerStd))*ones(1, sSignal), '--r');
plot(tAxis*1e3, 10*log10(meanPowerTkoLevel/max(signalPowerTko))*ones(1, sSignal), '--k');
plot(tAxis*1e3, 10*log10(medianPowerStdLevel/max(signalPowerStd))*ones(1, sSignal), '--r');
plot(tAxis*1e3, 10*log10(medianPowerTkoLevel/max(signalPowerTko))*ones(1, sSignal), '--k');

% Zero crossing
figure('color', 'white');

for i = 1 : 4,
    subplot(4, 1, i); hold on;
    plot(1:sSignal, halfSignal);
    plot(1:sSignal, zeroCrossing(i, :), 'r');
    plot(1:sSignal, yf(i,:), 'k');
    plot(minDetectedIdx(i), minDetected(i), '*k')
    title(['Signal zero crossing (window = ', num2str(zeroCrossingWinDuration*1e3*i*2), ' ms = ', num2str(sZeroCrossingWin*i*2), ' samples)']);
    xlabel('Time [ms]');
    ylabel('- [-]');
    axis tight;
end

% % Zero crossing
% figure('color', 'white');
% 
% for i = 1 : 4,
%     subplot(4, 1, i); hold on;
%     plot(tAxis*1e3, halfSignal);
%     plot(tAxis*1e3, zeroCrossing(i, :), 'r');
%     plot(tAxis(minDetectedIdx(i))*1e3, minDetected(i), '*k')
%     title(['Signal zero crossing (window = ', num2str(zeroCrossingWinDuration*1e3*i*2), ' ms = ', num2str(sZeroCrossingWin*i*2), ' samples)']);
%     xlabel('Time [ms]');
%     ylabel('- [-]');
%     axis tight;
% end