% � 2012-2015 Pitch Corp.
%   Author  : GS
%   Modif.  : Pitch
%   Build   : Matlab R2012b (8.0.0.783) x64 - Windows 7 x64
%             Matlab R2013a (8.1.0.604) x64 - Windows 7 x64

% History
% 1.1.b0.0020   Add functionnality
%               decNumber can now be an array. If so, binArr will be an array.
% 1.0.b0.0000	First functionnal version
% 0.0.a0.0000	File creation (2013.08.08)


function binArr = dec2binArr(decNumber, nBits)

    nDecNumber = length(decNumber);
    binArr = zeros(nDecNumber, nBits);

    for iDecNumber = 1 : nDecNumber,
        for iBit = nBits-1 : -1 : 0,

            iBitDecVal = 2^iBit;

            if decNumber(iDecNumber) >= iBitDecVal,

                binArr(iDecNumber, iBit+1) = 1;
                decNumber(iDecNumber) = decNumber(iDecNumber) - iBitDecVal;

            end

        end
    end

end

% eof
