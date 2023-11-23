%==================================================
%  (4c)
%       - Same as NormProjGrid_4c
%==================================================

function [Ksz,Kx,Ky,Kz,centre] = NormProjGridExtIdx_v4c(kmat,nproj,npro,kstep,convchw,normss,centre,type,idx)

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
centretest = ceil(normss*kmax/kstep) + (convchw + 2); 
if centre < centretest
    error;      % for now (could accept 1 less)
end
if strcmp(type,'A2A')
    error;  % don't use 
    ArrKmat = kmat;
    Kx = normss*(ArrKmat(:,1)/kstep) + centre;                   
    Ky = normss*(ArrKmat(:,2)/kstep) + centre;  
    Kz = normss*(ArrKmat(:,3)/kstep) + centre;  
    Ksz = centre*2 - 1; 
elseif strcmp(type,'M2A')
    kmatx = kmat(:,:,1);
    kmaty = kmat(:,:,2);
    kmatz = kmat(:,:,3);     
    Kx = normss*(kmatx(idx)/kstep) + centre;                   
    Ky = normss*(kmaty(idx)/kstep) + centre;  
    Kz = normss*(kmatz(idx)/kstep) + centre;  
    Ksz = centre*2 - 1; 
    Kx = Kx.';
    Ky = Ky.';
    Kz = Kz.';
elseif strcmp(type,'M2M')
    error;  % finish
    Kx = normss*(kmat(:,:,1)/kstep) + centre;                   
    Ky = normss*(kmat(:,:,2)/kstep) + centre;  
    Kz = normss*(kmat(:,:,3)/kstep) + centre;  
    Ksz = centre*2 - 1;
end