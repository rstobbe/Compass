%=========================================================
% 
%=========================================================

function [PSFACALC,err] = CalcFromFilePSFA_v1a_Func(PSFACALC,INPUT)

Status2('busy','PSFA Calculate',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PSF = PSFACALC.PSF;
ROI = INPUT.ROI;
OB = INPUT.OB;
clear INPUT

%---------------------------------------------
% ZeroFill PSF
%---------------------------------------------
sz = size(ROI.roimask);
tfmatwid = length(PSF.tf);
tfzf = zeros(sz);
b1 = (sz(1)/2)+1-(tfmatwid-1)/2;
t1 = (sz(1)/2)+1+(tfmatwid-1)/2;
b2 = (sz(2)/2)+1-(tfmatwid-1)/2;
t2 = (sz(2)/2)+1+(tfmatwid-1)/2;
b3 = (sz(3)/2)+1-(tfmatwid-1)/2;
t3 = (sz(3)/2)+1+(tfmatwid-1)/2;
tfzf(b1:t1,b2:t2,b3:t3) = PSF.tf;

%---------------------------------------------
% Calculate PSFA
%---------------------------------------------
kmask = fftshift(fftn(double(OB.roimask)));
kmask = kmask.*tfzf;
Im = ifftn(ifftshift(kmask));

test = sum(imag(Im(:)));
if test > 1e-20
    error
end
Im = real(Im);
ImVals = Im(logical(ROI.roimask));
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
