%===========================================
% 
%===========================================

function [OB,err] = DiamDefSphere_v1a_Func(OB,INPUT)

Status2('busy','Create Sphere',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
obdiam = INPUT.obdiam;
clear INPUT

%---------------------------------------------
% Calculate Sphere
%---------------------------------------------
elip = 1;
%--
R = obdiam/2;
ObMatSz = 2*ceil(R)+1;   
C = (ObMatSz+1)/2;
Ob = zeros(ObMatSz,ObMatSz,ObMatSz);
Tot = 0;
for x = 1:ObMatSz
    for y = 1:ObMatSz
        for z = 1:ObMatSz
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
    Status2('busy',num2str(x),3);    
end

%---------------------------------------------
% Testing (not needed for MEOV calc - i.e. volume recalc outside)
%---------------------------------------------
%compV = elip*pi*(4/3)*R.^3;
%Dif = compV/Tot;
%if abs((1-Dif)*100) > 2
%    err.flag = 1;
%    err.msg = 'Sphere Creation More than 2% in error';
%    return
%end

%---------------------------------------------
% Return
%---------------------------------------------
OB.Ob = Ob;
OB.ObMatSz = ObMatSz;
OB.Tot = Tot;

Status2('done','',2);
Status2('done','',3);


