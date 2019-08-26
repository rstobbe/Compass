%======================================================
% 
%======================================================

function [PSFACALC,err] = CalcPSFA_v1a_Func(PSFACALC,INPUT)

Status2('busy','PSFA Calculate',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = PSFACALC.IMP;
PROJdgn = IMP.PROJdgn;
TFB = PSFACALC.TFB;
SUS = PSFACALC.SUS;
ROI = INPUT.ROI;
IMG = INPUT.IMG;
clear INPUT

%---------------------------------------------
% Get Variables
%---------------------------------------------
zf = length(ROI.Mask);                      % for now isotropic

%---------------------------------------------
% Build Transfer Function
%---------------------------------------------
func = str2func([PSFACALC.tfbuildfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.tfdiam = 2*PROJdgn.rad;
INPUT.tforient = 'Axial';                       % for now
[TFB,err] = func(TFB,INPUT);
if err.flag
    return
end
clear INPUT;
tf = TFB.tf;
tfmatwid = length(tf);
tfzf = zeros(zf,zf,zf);
b = (zf/2)+1-(tfmatwid-1)/2;
t = (zf/2)+1+(tfmatwid-1)/2;
tfzf(b:t,b:t,b:t) = tf;

%---------------------------------------------
% Build Susceptibility Transform
%---------------------------------------------
func = str2func([PSFACALC.susbuildfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.tfdiam = 2*PROJdgn.rad;
INPUT.tforient = 'Axial';                       % for now
INPUT.Vis = 'On';
[SUS,err] = func(SUS,INPUT);
if err.flag
    return
end
clear INPUT;
sus = SUS.tf;
if not(isempty(sus))
    susmatwid = length(sus);
    suszf = zeros(zf,zf,zf);
    b = (zf/2)+1-(susmatwid-1)/2;
    t = (zf/2)+1+(susmatwid-1)/2;
    suszf(b:t,b:t,b:t) = sus;
    tfzf = tfzf.*suszf;
end

%--------------------------------------
% FT
%--------------------------------------
Status2('busy','Fourier Transform',2);
Im = fftshift(fftn(double(ROI.Mask)));
Im = Im.*tfzf;
Im = ifftn(ifftshift(Im));
test = sum(imag(Im(:)));
if test > 1e-20
    error
end
temp = abs(Im(ROI.Mask));
psfa = mean(temp(:));

%---------------------------------------------
% Return Data
%--------------------------------------------- 
PSFACALC.psfa = psfa;
PSFACALC.return = PSFACALC.psfa;
PSFACALC.label = 'PSFA';
PSFACALC.ExpDisp = ['(',ROI.Name,')   ',PSFACALC.label,':  ',num2str(PSFACALC.psfa)];
PSFACALC = rmfield(PSFACALC,'IMP');

%---------------------------------------------
% Return Image
%--------------------------------------------- 
PSFACALC.Im = Im;
PSFACALC.ImageType = 'Image';
PSFACALC.ReconPars = IMG.ReconPars;


Status2('done','',2);
Status2('done','',3);
