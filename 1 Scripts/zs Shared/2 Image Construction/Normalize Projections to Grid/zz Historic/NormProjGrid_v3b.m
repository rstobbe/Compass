%==================================================
%  (3b)
%       - kmax as input
%       - stricter grid size (smaller / less leniency)
%       - CONV.chW as input = convchw
%       - (convchw + 1) = extent of convolution reach
%==================================================

function [Ksz,Kx,Ky,Kz,center] = NormProjGrid_v3b(kmat,nproj,npro,kmax,kstep,convchw,normss,type)

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