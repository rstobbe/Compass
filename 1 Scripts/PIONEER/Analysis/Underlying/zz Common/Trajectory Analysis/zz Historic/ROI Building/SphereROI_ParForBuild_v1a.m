%===========================================
% 
%===========================================

function [ROI,err] = SphereROI_ParForBuild_v1a(ROI)

Status2('busy','Build ROI (Workers in Parallel)',3);    

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input Variables
%---------------------------------------------
fov = ROI.fov;
zf = ROI.zerofill;
diam = ROI.diam;

%---------------------------------------------
% Calculate Sphere
%---------------------------------------------
zfvoxdim = fov/zf;
zfdiamnum = diam/zfvoxdim;
R = zfdiamnum/2;
roi = zeros(zf,zf,zf);
C = (zf+1)/2;
Tot = 0;

bot = floor(C-R-1);
top = ceil(C+R+1);
elip = 1;
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
                roi(x,y,z) = 1;
                Tot = Tot + 1;
            end
        end
    end  
end

%---------------------------------------------
% Return
%---------------------------------------------
ROI.roi = roi;
ROI.tot = Tot;
ROI.volume = Tot*zfvoxdim^3;

Status2('done','',3);
