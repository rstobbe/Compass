%======================================================
% (v1a)
%
%======================================================

function [SPHs] = GenAll47TDeg3SphHarms_v1a(matsz)

arrx = linspace(-1,1,matsz(1));
arry = linspace(-1,1,matsz(2));
arrz = linspace(-1,1,matsz(3));
[X,Y,Z] = meshgrid(arry,arrx,arrz);
SPHs = zeros(matsz(1),matsz(2),matsz(3),17);

SPHs(:,:,:,1) = 1;                                                      % 
SPHs(:,:,:,2) = Z;                                                      % z
SPHs(:,:,:,3) = 2*Z.^2 - (X.^2 + Y.^2);                                 % z2
SPHs(:,:,:,4) = Z.*(2*Z.^2 - 3*(X.^2 + Y.^2));                          % z3
SPHs(:,:,:,5) = X;                                                      % x
SPHs(:,:,:,6) = Y;                                                      % y
SPHs(:,:,:,7) = Z.*X;                                                   % zx
SPHs(:,:,:,8) = Z.*Y;                                                   % zy
SPHs(:,:,:,9) = X.*Y;                                                  % xy
SPHs(:,:,:,10) = X.^2 - Y.^2;                                           % x2-y2
SPHs(:,:,:,11) = X.*(X.^2 - 3*Y.^2);                                    % x3
SPHs(:,:,:,12) = Y.*(3*X.^2 - Y.^2);                                    % y3
SPHs(:,:,:,13) = X.*(4*Z.^2 - (X.^2 + Y.^2));                           % z2x
SPHs(:,:,:,14) = Y.*(4*Z.^2 - (X.^2 + Y.^2));                           % z2y
SPHs(:,:,:,15) = X.*Y.*Z;                                               % xyz
SPHs(:,:,:,16) = Z.*(X.^2 - Y.^2);                                      % z(x2-y2)

