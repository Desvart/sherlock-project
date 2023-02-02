function [cepstrum, env, fin] = cepstrum_(spectrum, cutIdx)



%%% Cepstral analysis of the matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nBand = size(spectrum, 1);
    cepstrum = ifft(log(spectrum)) / nBand;
    
%%% Cut the cepstrum to split the envelope from the fine structure %%%%%%%%
    cepsEnvMatV = cepstrum;
    cepsEnvMatV(cutIdx : end-cutIdx , :) = min(min(cepstrum));
    cepsFineMatV = cepstrum;
    cepsFineMatV([1 : cutIdx , end-cutIdx : end], :) = min(min(cepstrum));
    
%%% Pseudo inverse cepstrum analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    logEnvMatV  = real( fft(cepsEnvMatV *nBand) );
    logFineMatV = real( fft(cepsFineMatV*nBand) );
    env         = exp(logEnvMatV);
    fin         = exp(logFineMatV);    


end
