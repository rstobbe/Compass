%==================================================
%  (4c)
%       - (convchw + 2) = extent of convolution reach
%==================================================

function [Ksz,Kx,Ky,centre] = NormProjGrid2D_v4c(kmat,nproj,npro,kstep,convchw,normss,type)

%---------------------------------------------
% Find Max k-Space excursion
%---------------------------------------------
if strcmp(type,'M2A') || strcmp(type,'M2M')
    rad = sqrt(kmat(:,:,1).^2 + kmat(:,:,2).^2);
else
    rad = sqrt(kmat(:,1).^2 + kmat(:,2).^2);
end
kmax = max(rad(:));

%---------------------------------------------
% Normalize to Grid
%---------------------------------------------
centre = ceil(normss*kmax/kstep) + (convchw + 2);   
if strcmp(type,'A2A')
    ArrKmat = kmat;
    Kx = normss*(ArrKmat(:,1)/kstep) + centre;                   
    Ky = normss*(ArrKmat(:,2)/kstep) + centre;  
    Ksz = centre*2 - 1; 
elseif strcmp(type,'M2A')
    [ArrKmat] = KMat2Arr2D(kmat,nproj,npro);       
    Kx = normss*(ArrKmat(:,1)/kstep) + centre;                   
    Ky = normss*(ArrKmat(:,2)/kstep) + centre;  
    Ksz = centre*2 - 1;
elseif strcmp(type,'M2M')
    Kx = normss*(kmat(:,:,1)/kstep) + centre;                   
    Ky = normss*(kmat(:,:,2)/kstep) + centre;  
    Ksz = centre*2 - 1;
end