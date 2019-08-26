%===========================================
% 
%===========================================

function [PSDS,err] = PSDBuild_TPIdesuse_v1a_Func(PSDS,INPUT)

Status2('busy','Create PSD Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
Vis = 'On';

%---------------------------------------------
% Load Input
%---------------------------------------------
PROJdgn = INPUT.PROJIMP.impPROJdgn;
diam = INPUT.tfdiam;
orient = INPUT.tforient;
clear INPUT

%---------------------------------------------
% Variables / Structures
%---------------------------------------------
PSDS.r = PROJdgn.r;
PSDS.psdarr = PROJdgn.PSD;
elip = PROJdgn.elip;

R = diam/2;
Ksz = 2*ceil(R)+1;   
C = (Ksz+1)/2;
tf = zeros(Ksz,Ksz,Ksz);
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
                tf(x,y,z) = interp1(PSDS.r,PSDS.psdarr,r);
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

if strcmp(orient,'Sagittal')
    tf = permute(tf,[3 2 1]);
elseif strcmp(orient,'Coronal')
    tf = permute(tf,[1 3 2]);
end

tf = tf/sum(tf(:));

if strcmp(Vis,'On')
    PSDprof = squeeze(tf((length(tf)+1)/2,(length(tf)+1)/2,:));
    figure(200); hold on; plot(PSDprof,'k','linewidth',2); title('PSD Function');
    ylim([0 max(PSDprof(:))*1.1]); xlim([1 length(PSDprof)]);    
end

PSDS.tf = tf;

Status2('done','',2);
Status2('done','',3);
