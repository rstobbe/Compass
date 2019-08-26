%===========================================
% 
%===========================================

function [ROI,err] = UserROI_SphereDiam_v1a_Func(ROI,INPUT)

Status2('busy','Create ROI',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
ZF = INPUT.zf;
FoV = INPUT.fov;
Diam = ROI.diam;
clear INPUT

%---------------------------------------------
% Calculate Voxels
%---------------------------------------------
voxdim = FoV/ZF;
diamnum = Diam/voxdim;
ROI.voxdim = voxdim;

%---------------------------------------------
% Calculate Sphere
%---------------------------------------------
elip = 1;
%--
R = diamnum/2;
roi = zeros(ZF,ZF,ZF);
C = (ZF+1)/2;
Tot = 0;
for x = 1:ZF
    for y = 1:ZF
        for z = 1:ZF
            r0 = sqrt((x-C)^2 + (y-C)^2 + (z-C)^2);
            if r0 == 0
                r = 0;
            else
                phi = acos((z-C)/r0);
                rmax = sqrt(((elip*R)^2)/(elip^2*(sin(phi))^2 + (cos(phi))^2));
                r = r0/rmax;
            end
            if r <= 1
                roi(x,y,z) = 1;
                Tot = Tot + 1;
            end
        end
    end
    Status2('busy',num2str(x),3);    
end

%---------------------------------------------
% Testing (not needed for MEOV calc - i.e. volume recalc outside)
%---------------------------------------------
compV = elip*pi*(4/3)*R.^3;
Dif = compV/Tot;
if abs((1-Dif)*100) > 2
    err.flag = 1;
    err.msg = 'Sphere Creation More than 2% in error';
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
ROI.roi = roi;

Status2('done','',2);
Status2('done','',3);
