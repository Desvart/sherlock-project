function [mnew,cnew] = class_rand( K, M, Q )
%CLASS_RAND	Generate random multi-class lists of statistics
%
%Usage:		[M_NEW,C_NEW] = CLASS_RAND( K, M, Q )
%
%	This function generates a multi-class list of K M-dimensional classes.
%	The maximum value for any eigenvalue is given by Q.  M must be less
%	than 3.

%	(c) Copyright 1993-1995 by Dave Caughey.  All rights reserved.

if nargin ~= 3 | nargout ~= 2,
    help class_rand
    return
end

for i = 1:K,
    if M == 1,
	v = 1;
    elseif M == 2,
	t = 2*pi*rand(1,1);
	v = [cos(t) sin(t); -sin(t) cos(t)];
    elseif M == 3,
	t = 2*pi*rand(1,1);
	v1 = [cos(t) sin(t) 0; -sin(t) cos(t) 0; 0 0 1];
	t = pi*rand(1,1)-pi/2;
	v2 = [1 0 0; 0 cos(t) sin(t); 0 -sin(t) cos(t)];
	v = v1*v2;
    end;
    d = diag(Q*rand(1,M));
    cx = v*d*v';
    cnew(i,:) = cx(:)';
    mnew(i,:) = randn(1,M);
end;
