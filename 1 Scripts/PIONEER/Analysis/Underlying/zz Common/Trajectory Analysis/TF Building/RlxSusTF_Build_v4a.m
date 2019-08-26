%======================================================
%
%======================================================

function [RLX,err] = RlxSusTF_Build_v4a(RLX)

Status2('busy','Build Signal Decay Shape',3);

err.flag = 0;
err.msg = '';

R = RLX.diam/2;
Ksz = 2*ceil(R)+1;
C = (Ksz+1)/2;
tf = zeros(Ksz,Ksz,Ksz);  
Tot = 0;

%Status2('busy','Workers in Parallel...',3);  
parfor x = 1:Ksz
    for y = 1:Ksz
        for z = 1:Ksz
            r0 = sqrt((x-C)^2 + (y-C)^2 + (z-C)^2);
            if r0 == 0
                r = 0;
            else
                phi = acos((z-C)/r0);
                rmax = sqrt(((RLX.elip*R)^2)/(RLX.elip^2*(sin(phi))^2 + (cos(phi))^2));
                r = r0/rmax;
            end
            if r <= 1
                tatr = interp1(RLX.r,RLX.tatr,r,'linear','extrap');
                tf(x,y,z) = RLX.func(tatr) * exp(1i*2*pi*tatr*RLX.offres/1000);
                Tot = Tot + 1;
            end
        end
    end
end
Status2('done','',3); 

compV = RLX.elip*pi*(4/3)*R.^3;
Dif = compV/Tot;
if abs((1-Dif)*100) > 1
    err.flag = 1;
    err.msg = 'Spheroid Creation More than 1% in error (increase matrix dimension)';
    return
end

RLX.tf = tf;
RLX.Tot = Tot;

Status2('done','',3);

