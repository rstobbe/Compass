%=========================================================
% 
%=========================================================

function [PSFACALC,err] = CalcSEF_v1b_Func(PSFACALC,INPUT)

Status2('busy','Calculate Smearing Error Factor',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PSF = PSFACALC.PSF;
PROJdgn = PSF.PROJdgn;
ROI = INPUT.ROI;
OB = INPUT.OB;
IMAGEANLZ = INPUT.IMAGEANLZ;
clear INPUT

%---------------------------------------------
% Image Info
%---------------------------------------------
pixdim = IMAGEANLZ.GetPixelDimensions;
zf = (PROJdgn.fov./pixdim);

%---------------------------------------------
% ZeroFill PSF
%---------------------------------------------
tfmatwid = length(PSF.tf);
tfzf = zeros(zf);
if round(rem(tfmatwid,2)*1e6) == 0
    b1 = (zf(1)-tfmatwid)/2+1;
    t1 = b1+tfmatwid-1;
    b2 = (zf(2)-tfmatwid)/2+1;
    t2 = b1+tfmatwid-1;  
    b3 = (zf(3)-tfmatwid)/2+1;
    t3 = b1+tfmatwid-1;  
else
    b1 = (zf(1)/2)+1-(tfmatwid-1)/2;
    t1 = (zf(1)/2)+1+(tfmatwid-1)/2;
    b2 = (zf(2)/2)+1-(tfmatwid-1)/2;
    t2 = (zf(2)/2)+1+(tfmatwid-1)/2;
    b3 = (zf(3)/2)+1-(tfmatwid-1)/2;
    t3 = (zf(3)/2)+1+(tfmatwid-1)/2;
end
tfzf(b1:t1,b2:t2,b3:t3) = PSF.tf;
figure(1000); hold on;
plot(tfzf(:,zf(2)/2+1,zf(3)/2+1));

%---------------------------------------------
% Restore Image FoV (if needed)
%---------------------------------------------
sz = size(OB.roimask);
bot = (zf-sz)/2+1;
top = bot+sz-1;
obmask = zeros(zf);
obmask(bot(1):top(1),bot(2):top(2),bot(3):top(3)) = OB.roimask;
roimask = zeros(zf);
roimask(bot(1):top(1),bot(2):top(2),bot(3):top(3)) = ROI.roimask;

%---------------------------------------------
% Calculate PSFA
%---------------------------------------------
kmask = fftshift(fftn(obmask));
kmask = kmask.*tfzf;
SmearIm = ifftn(ifftshift(kmask));

test = sum(imag(SmearIm(:)));
if test > 1e-15
    error
end
SmearIm = real(SmearIm);
ImVals = SmearIm(logical(roimask));
PSFACALC.psfa = mean(ImVals);
PSFACALC.maxval = max(ImVals);

%---------------------------------------------
% Calculate PSFA
%---------------------------------------------
PSFACALC.return = PSFACALC.psfa;
PSFACALC.label = {'PSFA'};
PSFACALC.ExpDisp = ['(',ROI.roiname,')   ',PSFACALC.label{1},':  ',num2str(PSFACALC.return)];

PSFACALC.saveable = 'yes';

Status2('done','',2);
Status2('done','',3);
