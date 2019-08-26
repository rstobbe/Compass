%======================================================
%
%======================================================

function [RlxTF,Tot,err] = RlxTF_Build_v4(TRAJ,RLX,TF_diam,err)

Status2('busy','Signal Decay',2);

elip = TRAJ.elip;

R = TF_diam/2;
Ksz = 2*ceil(R)+1;
C = (Ksz+1)/2;
RlxTF = zeros(Ksz,Ksz,Ksz);  
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
                tatr = interp1(RLX.r,RLX.tatr,r,'linear','extrap');
                RlxTF(x,y,z) = RLX.func(tatr);
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

