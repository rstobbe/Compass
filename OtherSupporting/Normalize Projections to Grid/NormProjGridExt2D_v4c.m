%==================================================
%  (4c)
%       - Same as NormProjGrid_4c
%==================================================

function [Ksz,Kx,Ky,centre] = NormProjGridExt2D_v4c(kmat,nproj,npro,kstep,convchw,normss,centre,type)

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
centretest = ceil(normss*kmax/kstep) + (convchw + 2); 
if centre < centretest
    error;      % for now (could accept 1 less)
end
if strcmp(type,'A2A')
    ArrKmat = kmat;
    Kx = normss*(ArrKmat(:,1)/kstep) + centre;                   
    Ky = normss*(ArrKmat(:,2)/kstep) + centre;  
    Ksz = centre*2 - 1; 
elseif strcmp(type,'M2A')
    [ArrKmat] = KMat2Arr(kmat,nproj,npro);       
    Kx = normss*(ArrKmat(:,1)/kstep) + centre;                   
    Ky = normss*(ArrKmat(:,2)/kstep) + centre;  
    Ksz = centre*2 - 1;
elseif strcmp(type,'M2M')
    Kx = normss*(kmat(:,:,1)/kstep) + centre;                   
    Ky = normss*(kmat(:,:,2)/kstep) + centre;  
    Ksz = centre*2 - 1;
end