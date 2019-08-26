%===========================================
% 
%===========================================

function [OB,err] = UserOb_Sphere_v1a_Func(OB,INPUT)

Status2('busy','Create Spherical Object',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
ZF = INPUT.zf;
FoV = OB.fov;
Diam = OB.diam;
clear INPUT

%---------------------------------------------
% Calculate Voxels
%---------------------------------------------
voxdim = FoV/ZF;
diamnum = Diam/voxdim;
OB.voxdim = voxdim;

%---------------------------------------------
% Calculate Sphere
%---------------------------------------------
elip = 1;
%--
R = diamnum/2;
Ob = zeros(ZF,ZF,ZF);
C = (ZF+1)/2;
Tot = 0;

bot = floor(C-R-1);
top = ceil(C+R+1);
Status2('busy','Workers in Parallel...',3);    
parfor x = bot:top
    for y = bot:top
        for z = bot:top
            r0 = sqrt((x-C)^2 + (y-C)^2 + (z-C)^2);
            if r0 == 0
                r = 0;
            else
                phi = acos((z-C)/r0);
                rmax = sqrt(((elip*R)^2)/(elip^2*(sin(phi))^2 + (cos(phi))^2));
                r = r0/rmax;
            end
            if r <= 1
                Ob(x,y,z) = 1;
                Tot = Tot + 1;
            end
        end
    end
end
Status2('done','',3);  

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
OB.Ob = Ob;

Status2('done','',2);
Status2('done','',3);
