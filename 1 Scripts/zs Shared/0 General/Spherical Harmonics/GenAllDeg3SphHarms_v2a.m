%======================================================
% (v2a)
%
%======================================================

function [SPHs] = GenAllDeg3SphHarms_v2a(matsz)

arr = linspace(-1,1,matsz);
[X,Y,Z] = meshgrid(arr,arr,arr);
SPHs = zeros(matsz,matsz,matsz,15);

SPHs(:,:,:,1) = Z;                              % z
SPHs(:,:,:,2) = 2*Z.^2 - (X.^2 + Y.^2);         % z2
SPHs(:,:,:,3) = Z.*(2*Z.^2 - 3*(X.^2 + Y.^2));  % z3
SPHs(:,:,:,4) = X;                              % x
SPHs(:,:,:,5) = Y;                              % y
SPHs(:,:,:,6) = Z.*X;                           % zx
SPHs(:,:,:,7) = Z.*Y;                           % zy
SPHs(:,:,:,8) = X.*(4*Z.^2 - (X.^2 + Y.^2));    % z2x
SPHs(:,:,:,9) = Y.*(4*Z.^2 - (X.^2 + Y.^2));    % z2y
SPHs(:,:,:,10) = X.^2 - Y.^2;                   % x2-y2
SPHs(:,:,:,11) = X.*Y;                          % xy
SPHs(:,:,:,12) = Z.*(X.^2 - Y.^2);              % z(x2-y2)
SPHs(:,:,:,13) = X.*Y.*Z;                       % xyz
SPHs(:,:,:,14) = X.*(X.^2 - 3*Y.^2);            % x3
SPHs(:,:,:,15) = Y.*(3*X.^2 - Y.^2);            % y3