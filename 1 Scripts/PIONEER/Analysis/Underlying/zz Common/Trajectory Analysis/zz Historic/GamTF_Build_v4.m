%======================================================
%
%======================================================

function [GamTF,Tot,err] = GamTF_Build_v4(TRAJ,TF_diam,err)
                                                            
Status2('busy','Gamma Function',2);

GAM = TRAJ.GAM;
elip = TRAJ.elip;

R = TF_diam/2;
Ksz = 2*ceil(R)+1;   
C = (Ksz+1)/2;
GamTF = zeros(Ksz,Ksz,Ksz);
Tot = 0;
for x = 1:Ksz
    for y = 1:Ksz
        for z = 1:Ksz
            r0 = sqrt((x-C)^2 + (y-C)^2 + (z-C)^2);
            if r0 == 0
                r = 0;
            else
                phi = acos((z-C)/r0);
                rmax = sqrt(((elip*R)^2)/(elip^2*(sin(phi))^2 + (cos(phi))^2));
                r = r0/rmax;
            end
            if r <= 1
                GamTF(x,y,z) = interp1(GAM.r,GAM.gam,r);
                Tot = Tot + 1;
            end
        end
    end
    Status2('busy',num2str(x),3);    
end
compV = elip*pi*(4/3)*R.^3;
Dif = compV/Tot;
if abs((1-Dif)*100) > 2
    err.flag = 1;
    err.msg = 'Spheroid Creation More than 2% in error (increase matrix dimension)';
    return
end

Status2('done','',2);
Status2('done','',3);

