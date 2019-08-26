%==================================================
%  (4b)
%       - remove kmax from input
%       - stricter grid size (smaller / less leniency)
%       - CONV.chW as input = convchw
%       - (convchw + 1) = extent of convolution reach
%==================================================

function [Ksz,Kx,Ky,Kz,center] = NormProjGrid_v4b(kmat,nproj,npro,kstep,convchw,normss,type)

%---------------------------------------------
% Find Max k-Space excursion
%---------------------------------------------
if strcmp(type,'M2A') || strcmp(type,'M2M')
    rad = sqrt(kmat(:,:,1).^2 + kmat(:,:,2).^2 + kmat(:,:,3).^2);
else
    rad = sqrt(kmat(:,1).^2 + kmat(:,2).^2 + kmat(:,3).^2);
end
kmax = max(rad(:));

%---------------------------------------------
% Normalize to Grid
%---------------------------------------------
center = ceil(normss*kmax/kstep) + (convchw + 1);   
if strcmp(type,'A2A')
    ArrKmat = kmat;
    Kx = normss*(ArrKmat(:,1)/kstep) + center;                   
    Ky = normss*(ArrKmat(:,2)/kstep) + center;  
    Kz = normss*(ArrKmat(:,3)/kstep) + center;  
    Ksz = center*2 - 1; 
elseif strcmp(type,'M2A')
    [ArrKmat] = KMat2Arr(kmat,nproj,npro);       
    Kx = normss*(ArrKmat(:,1)/kstep) + center;                   
    Ky = normss*(ArrKmat(:,2)/kstep) + center;  
    Kz = normss*(ArrKmat(:,3)/kstep) + center;  
    Ksz = center*2 - 1;
elseif strcmp(type,'M2M')
    Kx = normss*(kmat(:,:,1)/kstep) + center;                   
    Ky = normss*(kmat(:,:,2)/kstep) + center;  
    Kz = normss*(kmat(:,:,3)/kstep) + center;  
    Ksz = center*2 - 1;
end