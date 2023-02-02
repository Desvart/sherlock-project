function outputTab = generate_permutation_with_order(nElement, nElementToPermut, nPermut)

    nPermutMax = factorial(nElement)/factorial(nElement - nElementToPermut);

    nPermut = min(nPermut, nPermutMax);
    outputTab = zeros(nPermut, nElementToPermut);

    for iPermut = 1 : nPermut,
        check = false;
        while check == false,
            check = true;
            raw = randperm(nElement);
            outputTab(iPermut, :) = raw(1:nElementToPermut);

            for iCheck = 1 : iPermut - 1,
                if all(outputTab(iPermut, :) == outputTab(iCheck, :)),
                    check = false;
                    break;

                end
            end
        end
    end  
end

