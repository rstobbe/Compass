%======================================================
% (v1a)
%
%======================================================

function [SPHs] = GenAllDeg1SphHarms_v1a(matsz)

arrx = linspace(-1,1,matsz(1));
arry = linspace(-1,1,matsz(2));
arrz = linspace(-1,1,matsz(3));
[X,Y,Z] = meshgrid(arry,arrx,arrz);
SPHs = zeros(matsz(1),matsz(2),matsz(3),4);

SPHs(:,:,:,1) = 1;                                                      % 
SPHs(:,:,:,2) = Z;                                                      % z
SPHs(:,:,:,3) = X;                                                      % x
SPHs(:,:,:,4) = Y;                                                      % y
