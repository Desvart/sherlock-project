function [y, E] = sammon(x, n, opts)
%SAMMON Performs Sammon's MDS mapping on dataset X
%
%    Y = SAMMON(X) applies Sammon's nonlinear mapping procedure on
%    multivariate data X, where each row represents a pattern and each column
%    represents a feature.  On completion, Y contains the corresponding
%    co-ordinates of each point on the map.  By default, a two-dimensional
%    map is created.  Note if X contains any duplicated rows, SAMMON will
%    fail (ungracefully). 
%
%    [Y,E] = SAMMON(X) also returns the value of the cost function in E (i.e.
%    the stress of the mapping).
%
%    An N-dimensional output map is generated by Y = SAMMON(X,N) .
%
%    A set of optimisation options can also be specified using a third
%    argument, Y = SAMMON(X,N,OPTS) , where OPTS is a structure with fields:
%
%       MaxIter        - maximum number of iterations
%       TolFun         - relative tolerance on objective function
%       MaxHalves      - maximum number of step halvings
%       Input          - {'raw','distance'} if set to 'distance', X is 
%                        interpreted as a matrix of pairwise distances.
%       Display        - {'off', 'on', 'iter'}
%       Initialisation - {'pca', 'random'}
%
%    The default options structure can be retrieved by calling SAMMON with
%    no parameters.
%
%    References :
%
%       [1] Sammon, John W. Jr., "A Nonlinear Mapping for Data Structure
%           Analysis", IEEE Transactions on Computers, vol. C-18, no. 5,
%           pp 401-409, May 1969.
%
%    See also : SAMMON_TEST

%
% File        : sammon.m
%
% Date        : Monday 12th November 2007.
%
% Author      : Gavin C. Cawley and Nicola L. C. Talbot
%
% Description : Simple vectorised MATLAB implementation of Sammon's non-linear
%               mapping algorithm [1].
%
% References  : [1] Sammon, John W. Jr., "A Nonlinear Mapping for Data
%                   Structure Analysis", IEEE Transactions on Computers,
%                   vol. C-18, no. 5, pp 401-409, May 1969.
%
% History     : 10/08/2004 - v1.00
%               11/08/2004 - v1.10 Hessian made positive semidefinite
%               13/08/2004 - v1.11 minor optimisation
%               12/11/2007 - v1.20 initialisation using the first n principal
%                                  components.
%
% Thanks      : Dr Nick Hamilton (nick@maths.uq.edu.au) for supplying the
%               code for implementing initialisation using the first n
%               principal components (introduced in v1.20).
%
% To do       : The current version does not take advantage of the symmetry
%               of the distance matrix in order to allow for easy
%               vectorisation.  This may not be a good choice for very large
%               datasets, so perhaps one day I'll get around to doing a MEX
%               version using the BLAS library etc. for very large datasets.
%
% Copyright   : (c) Dr Gavin C. Cawley, November 2007.
%
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; if not, write to the Free Software
%    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

% This file is part of the Matlab Toolbox for Dimensionality Reduction v0.7b.
% The toolbox can be obtained from http://ticc.uvt.nl/~lvdrmaaten
% You are free to use, change, or redistribute this code in any way you
% want for non-commercial purposes. However, it is appreciated if you 
% maintain the name of the original author.
%
% (C) Laurens van der Maaten
% Tilburg University, 2008


    % use the default options structure
    if nargin < 3
        opts.Display        = 'iter';
        opts.Input          = 'raw';
        opts.MaxHalves      = 20;
        opts.MaxIter        = 500;
        opts.TolFun         = 1e-9;
        opts.Initialisation = 'random';

    end

    % the user has requested the default options structure
    if nargin == 0
        y = opts;
        return;
    end

    % Create a two-dimensional map unless dimension is specified
    if nargin < 2
        n = 2;
    end

    % Set level of verbosity
    if strcmp(opts.Display, 'iter')
        display = 2;
    elseif strcmp(opts.Display, 'on')
        display = 1;
    else
        display = 0;
    end

    % Create distance matrix unless given by parameters
    if strcmp(opts.Input, 'distance')
        D = x;
    else
        D = euclid(x, x);
    end

    % Remaining initialisation
    N     = size(x, 1);
    scale = 0.5 / sum(D(:));
    D     = D + eye(N);
    Dinv  = 1 ./ D;
    if strcmp(opts.Initialisation, 'pca')
        [UU,DD] = svd(x);
        y       = UU(:,1:n)*DD(1:n,1:n);
    else
        y = randn(N, n);
    end
    one   = ones(N,n);
    d     = euclid(y,y) + eye(N);
    dinv  = 1./d;
    delta = D - d;
    E     = sum(sum((delta.^2).*Dinv));

    % Get on with it
    for i=1:opts.MaxIter

        % Compute gradient, Hessian and search direction (note it is actually
        % 1/4 of the gradient and Hessian, but the step size is just the ratio
        % of the gradient and the diagonal of the Hessian so it doesn't
        % matter).
        delta    = dinv - Dinv;
        deltaone = delta * one;
        g        = delta * y - y .* deltaone;
        dinv3    = dinv .^ 3;
        y2       = y .^ 2;
        H        = dinv3 * y2 - deltaone - 2 * y .* (dinv3 * y) + y2 .* (dinv3 * one);
        s        = -g(:) ./ abs(H(:));
        y_old    = y;

        % Use step-halving procedure to ensure progress is made
        for j=1:opts.MaxHalves
            y(:) = y_old(:) + s;
            d     = euclid(y, y) + eye(N);
            dinv  = 1 ./ d;
            delta = D - d;
            E_new = sum(sum((delta .^ 2) .* Dinv));
            if E_new < E
                break;
            else
                s = 0.5*s;
            end
        end

        % Bomb out if too many halving steps are required
        if j == opts.MaxHalves
            warning('MaxHalves exceeded. Sammon mapping may not converge...');
        end

        % Evaluate termination criterion
        if abs((E - E_new) / E) < opts.TolFun
            if display
                fprintf(1, 'Optimisation terminated - TolFun exceeded.\n');
            end
            break;
        end

        % Report progress
        E = E_new;
        if display > 1
            fprintf(1, 'epoch = %d : E = %12.10f\n', i, E * scale);
        end
    end

    % Fiddle stress to match the original Sammon paper
    E = E * scale;
end

function d = euclid(x, y)
    d = sqrt(sum(x.^2,2)*ones(1,size(y,1))+ones(size(x,1),1)*sum(y.^2,2)'-2*(x*y'));
end

