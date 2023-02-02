function relIdx = absId_2_relId(relRefArray, absIdx, verbose, debug) %#ok<INUSL>
% ABSID_2_RELID    Convert an absolute index 'absIdx' to a relative index 'relIdx'. To be computed
% the relative index need to know the number of element of each relative reference 'relRefArray', 
% from the higher reference to the smaller (like a tree, from top to bottom). This function works
% only for an absolutely symetric tree. Each branch should have the exact number of sub-branches
% that the other branches.
%
% Inputs :
% - relRefArray     [int 1xn] Relative Reference Array : number of element in each reference.
% - absIdx          [int 1x1] Absolute Index : the absolute index to convert in a relative one.
% - [verbose]       [bool 1x1] Do nothing.
%                   Default value = false.
% - [debug]         [bool 1x1] Help debugging.
%                   Default value = false.
%
% Outputs : 
% - relIdx          [dbl 1xn] Relative Index : The coordinate of the point in the relative system of
%                   coordinate.
%
% See also -
% Subfunctions : -

% Project   : Generic purpose - 
% � 2009-2015 Pitch
%   Author  : Pitch

% Log
% 2013.02.13    [A0.0.0] File creation.


% To do (or could be done)
% - Optimization for speed.

% To fix
% -



    %% Check input-output arguments
    
    defaultValueArray = {'relRefArray',  '[3, 6, 12]'; ...
                         'absIdx',        '216';          ...
                         'verbose',      'false';       ...
                         'debug',        'false'};                 
    nArgsTot = size(defaultValueArray, 1);                 
    narginchk(0, 4);
        
    for iArg = 1 : nArgsTot,
        if ~exist(defaultValueArray{iArg, 1}, 'var'),
            eval([defaultValueArray{iArg, 1}, ' = ', defaultValueArray{iArg, 2}]);
        end
    end
    
    if debug == false,
        %
        narginchk(2, nArgsTot);
        nargoutchk(1, 1);
        
    else
        verbose = true;
        dispv('WARNING : DEBUG MODE IS ACTIVE.\n', verbose);
        %
        dbStack = dbstack('-completenames');
        commit_tortoiseSvn(dbStack.file);
    end


    
    %% Core 
    
    nRefs = length(relRefArray); % Init.
    
    relIdx = ones(1, nRefs);      % Prealloc.
    residual = absIdx;            % Init.
    for iRef = 1 : nRefs-1,
        
        % Number of elements belonging to this reference
        nElementsInThisRef  = prod(relRefArray(iRef+1 : end));
        
        % Relative index to this reference 
        relIdx(iRef)         = ceil(residual / nElementsInThisRef);
        
        % Residual from computed relative index and absolute index
        relIdx(iRef+1)       = residual - (relIdx(iRef)-1)*nElementsInThisRef;
        residual            = relIdx(iRef+1);
        
    end

end

% eof

