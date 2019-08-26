%======================================================
% (v1a)
%
%======================================================

function [SPHs] = GenAllDeg3SphHarms45z_v1a(matsz)

arrx = linspace(-1,1,matsz(1));
arry = linspace(-1,1,matsz(2));
arrz = linspace(-1,1,matsz(3));
[X,Y,Z] = meshgrid(arry,arrx,arrz);
SPHs = zeros(matsz(1),matsz(2),matsz(3),17);

SPHs(:,:,:,1) = 1;                                                      % 
SPHs(:,:,:,2) = Z;                                                      % z
SPHs(:,:,:,3) = 2*Z.^2 - (X.^2 + Y.^2);                                 % z2
SPHs(:,:,:,4) = Z.*(2*Z.^2 - 3*(X.^2 + Y.^2));                          % z3
SPHs(:,:,:,5) = 8*Z.^2.*(Z.^2 - 3*(X.^2 + Y.^2)) + 3*(X.^2 + Y.^2).^2;  % z4
SPHs(:,:,:,6) = 48*Z.^3.*(Z.^2 - 5*(X.^2 + Y.^2)) + 90*Z.*(X.^2 + Y.^2).^2;  %z5
SPHs(:,:,:,7) = X;                                                      % x
SPHs(:,:,:,8) = Y;                                                      % y
SPHs(:,:,:,9) = Z.*X;                                                   % zx
SPHs(:,:,:,10) = Z.*Y;                                                   % zy
SPHs(:,:,:,11) = X.*Y;                                                  % xy
SPHs(:,:,:,12) = X.^2 - Y.^2;                                           % x2-y2
SPHs(:,:,:,13) = X.*(X.^2 - 3*Y.^2);                                    % x3
SPHs(:,:,:,14) = Y.*(3*X.^2 - Y.^2);                                    % y3
SPHs(:,:,:,15) = X.*(4*Z.^2 - (X.^2 + Y.^2));                           % z2x
SPHs(:,:,:,16) = Y.*(4*Z.^2 - (X.^2 + Y.^2));                           % z2y
SPHs(:,:,:,17) = X.*Y.*Z;                                               % xyz
SPHs(:,:,:,18) = Z.*(X.^2 - Y.^2);                                      % z(x2-y2)
