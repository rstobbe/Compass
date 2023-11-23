%==================================================
%  (4c)
%       - (convchw + 2) = extent of convolution reach
%==================================================

function [Ksz,Kx,Ky,Kz,center] = NormProjGridIdx_v4c(kmat,nproj,npro,kstep,convchw,normss,type,idx)

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
center = ceil(normss*kmax/kstep) + (convchw + 2);   
if strcmp(type,'A2A')
    error;  % don't use 
    ArrKmat = kmat;
    Kx = normss*(ArrKmat(:,1)/kstep) + center;                   
    Ky = normss*(ArrKmat(:,2)/kstep) + center;  
    Kz = normss*(ArrKmat(:,3)/kstep) + center;  
    Ksz = center*2 - 1; 
elseif strcmp(type,'M2A')
    kmatx = kmat(:,:,1);
    kmaty = kmat(:,:,2);
    kmatz = kmat(:,:,3);     
    Kx = normss*(kmatx(idx)/kstep) + center;                   
    Ky = normss*(kmaty(idx)/kstep) + center;  
    Kz = normss*(kmatz(idx)/kstep) + center;  
    Ksz = center*2 - 1;
    Kx = Kx.';
    Ky = Ky.';
    Kz = Kz.';
elseif strcmp(type,'M2M')
    error;  % finish
    Kx = normss*(kmat(:,:,1)/kstep) + center;                   
    Ky = normss*(kmat(:,:,2)/kstep) + center;  
    Kz = normss*(kmat(:,:,3)/kstep) + center;  
    Ksz = center*2 - 1;
end