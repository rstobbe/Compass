%======================================================
%
%======================================================

function [FLT,err] = FltTF_Build_v4a(FLT)
                                                            
Status2('busy','Build k-Space Filtering Shape',3);

err.flag = 0;
err.msg = '';

R = FLT.diam/2;
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
                rmax = sqrt(((FLT.elip*R)^2)/(FLT.elip^2*(sin(phi))^2 + (cos(phi))^2));
                r = r0/rmax;
            end
            if r <= 1
                tf(x,y,z) = interp1(FLT.r,FLT.tf,r);
                Tot = Tot + 1;
            end
        end
    end  
end
Status2('done','',3); 

compV = FLT.elip*pi*(4/3)*R.^3;
Dif = compV/Tot;
if abs((1-Dif)*100) > 1
    err.flag = 1;
    err.msg = 'Spheroid Creation More than 1% in error (increase matrix dimension)';
    return
end

FLT.tf = tf/max(tf(:));
FLT.Tot = Tot;

Status2('done','',3);

