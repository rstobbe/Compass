%=========================================================
% 
%=========================================================

function [SEFCALC,err] = CalcSEF2PSF_v1b_Func(SEFCALC,INPUT)

Status2('busy','Calculate Smearing Error Factor',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ratio = SEFCALC.ratio;
PSFob = SEFCALC.PSFob;
PSFbg = SEFCALC.PSFbg;
PROJdgn = PSFob.PROJdgn;
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
% ZeroFill PSFob
%---------------------------------------------
tfmatwid = length(PSFob.tf);
tfzfob = zeros(zf);
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
tfzfob(b1:t1,b2:t2,b3:t3) = PSFob.tf;
figure(1000); hold on;
plot(tfzfob(:,zf(2)/2+1,zf(3)/2+1));

%---------------------------------------------
% ZeroFill PSFbg
%---------------------------------------------
tfmatwid = length(PSFbg.tf);
tfzfbg = zeros(zf);
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
tfzfbg(b1:t1,b2:t2,b3:t3) = PSFbg.tf;
figure(1000); hold on;
plot(tfzfbg(:,zf(2)/2+1,zf(3)/2+1));

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
bgmask = 1-obmask;

%---------------------------------------------
% Create Smeared Object
%---------------------------------------------
kmask = fftshift(fftn(obmask));
kmask = kmask.*tfzfob;
SmearOb = ifftn(ifftshift(kmask));
test = sum(imag(SmearOb(:)));
if test > 1e-10
    error
end
SmearOb = real(SmearOb);
clear tfzfob
clear obmask

%---------------------------------------------
% Create Smeared BackGround
%---------------------------------------------
kmask = fftshift(fftn(bgmask));
kmask = kmask.*tfzfbg;
SmearBG = ifftn(ifftshift(kmask));
test = sum(imag(SmearBG(:)));
if test > 1e-10
    error
end
SmearBG = real(SmearBG);
clear tfzfbg
clear bgmask

SmearIm = ratio*SmearOb+SmearBG;

ImVals = SmearIm(logical(roimask));
SEFCALC.meanvals = mean(ImVals);
SEFCALC.maxval = max(ImVals);
SEFCALC.sef = (SEFCALC.meanvals-1)/(ratio-1);

%---------------------------------------------
% Calculate SEF
%---------------------------------------------
SEFCALC.return = SEFCALC.sef;
SEFCALC.label = {'SEF'};
SEFCALC.ExpDisp = ['(',ROI.roiname,')   ',SEFCALC.label{1},':  ',num2str(SEFCALC.return)];

SEFCALC.saveable = 'yes';

Status2('done','',2);
Status2('done','',3);
