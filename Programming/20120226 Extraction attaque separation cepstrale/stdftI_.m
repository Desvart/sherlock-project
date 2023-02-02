function signal = stdftI_(spectrumUM, spectrumUP, win, shift, sStopPadding)
%
% 2012.02.26

if nargin < 5
    sStopPadding = 0;
end

% Restauration de la phase
[nBand, nBlock] = size(spectrumUM);
N = (nBand-1)*2;
sFrame = N * shift;
spectrumU = spectrumUM .* exp(1j * spectrumUP);

% Rebuild the entire time-frenquency matrix
spectrumU = [spectrumU(1,:) ; 1/2*spectrumU(2:nBand-1,:) ; spectrumU(nBand,:)];
bilateralMissingPart = conj(spectrumU(nBand-1 : -1 : 2, :)); 
spectrum = [spectrumU ; bilateralMissingPart];   

% Inverse transformation
signalMatrix = real(ifft(spectrum * N));    % Inverse DFT Transformation and remove residual imaginary components
winMatrix       = win' * ones(1, nBlock);
signalMatrix = signalMatrix .* winMatrix;       % Windowing of each block

% Overlap-add operation
signalPadded = zeros(1, N + (nBlock-1) * sFrame); % Preallocating
for i = 1 : nBlock,                           % Loop for every block 
   a = 1 + (i-1) * sFrame;                      % Index of first sample
   b = N + (i-1) * sFrame;                  % Index of last sample
   signalPadded(a:b) = signalPadded(a:b) + signalMatrix(:,i).';% Perform overlap-add
end
    
% Rescaling 
signalPadded = signalPadded / ( (1/2)*(N/sFrame) );
    
% Remove added samples 
sStartPadding = N;
signal = signalPadded(sStartPadding + 1 : end - sStopPadding);

if sStopPadding == 0,
    for idx = length(signal):-1:1,
        if abs(signal(idx)) > 1e-16,
            signal = signal(1:idx);
            break;
        end
    end
end

end