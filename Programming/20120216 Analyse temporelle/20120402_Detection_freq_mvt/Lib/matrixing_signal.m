function matrixedSignal = matrixing_signal(signal, blockFirstIdx, blockSize)

    if blockFirstIdx(end) + blockSize > length(signal),
        error('Last block index is out of signal size.');
    end

    nBlock         = length(blockFirstIdx);
    bandIdx        = 1:blockSize;
    matrixedSignal = signal(ones(blockSize, 1)*(blockFirstIdx-1) + bandIdx'*ones(1, nBlock));

end