%======================================================
%
%======================================================

function [PSDS,err] = PSDimp_Build_v4a(PSDS,SDCS)

Status2('busy','PSD',2);

err.flag = 0;
err.msg = '';

R = PSDS.diam/2;
Ksz = 2*ceil(R)+1;   
C = (Ksz+1)/2;
PSD = zeros(Ksz,Ksz,Ksz);
Tot = 0;
for x = 1:Ksz
    for y = 1:Ksz
        for z = 1:Ksz
            r0 = sqrt((x-C)^2 + (y-C)^2 + (z-C)^2);
            if r0 == 0
                r = 0;
            else
                phi = acos((z-C)/r0);
                rmax = sqrt(((PSDS.elip*R)^2)/(PSDS.elip^2*(sin(phi))^2 + (cos(phi))^2));
                r = r0/rmax;
            end
            if r == 0
                PSD(x,y,z) = 0;
                Tot = Tot + 1;
            elseif r <= 1
                PSD(x,y,z) = interp1(FLT.r,FLT.tf,r);
                Tot = Tot + 1;
            end
        end
    end
    Status2('busy',num2str(x),2);    
end
compV = elip*pi*(4/3)*R.^3;
Dif = compV/Tot;
if abs((1-Dif)*100) > 2
    error('Spheroid Creation More than 2% in error');
end


Const = ((R^3)*projlen)/(tro*(GAM.gam(1)^2));
if strcmp(TRAJ.orient,'Sagittal')
    PSD = permute(PSD,[3 2 1]);
elseif strcmp(TRAJ.orient,'Coronal')
    PSD = permute(PSD,[1 3 2]);
end

if strcmp(Vis,'On')
    PSDprof = squeeze(PSD((length(PSD)+1)/2,(length(PSD)+1)/2,:));
    PSDprof = PSDprof ./ max(PSDprof(:));
    figure(200); hold on; plot(PSDprof); title('PSD Function');
end

Status2('done','',2);
Status2('done','',3);



