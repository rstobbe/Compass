%=========================================================
% 
%=========================================================

function [PRCALC,err] = CalcPrec_v1a_Func(PRCALC,INPUT)

Status('busy','Calculate ROI Precision');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SIV = PRCALC.SIV;
PSD = PRCALC.PSD;
ROI = INPUT.ROI;
zf = length(ROI);
sdvnoise = PRCALC.sdvnoise;
clear INPUT

%---------------------------------------------
% ZeroFill PSD
%---------------------------------------------
PSDmatwid = length(PSD.PSD);
PSDzf = zeros(zf,zf,zf);
b = (zf/2)+1-(PSDmatwid-1)/2;
t = (zf/2)+1+(PSDmatwid-1)/2;
PSDzf(b:t,b:t,b:t) = PSD.PSD;

%---------------------------------------------
% Find SIV
%---------------------------------------------
func = str2func([PRCALC.sivinroifunc,'_Func']);  
INPUT.ROI = ROI;
INPUT.Nroi = sum(ROI(:));
INPUT.PSD = PSDzf;
INPUT.psddiam = PSD.psddiam;                  % use design         
INPUT.vinvox = (zf/PSD.psddiam)^3;            % interp voxels in one real voxel.
[SIV,err] = func(SIV,INPUT);
if err.flag
    return
end
clear INPUT;
Nsiv = SIV.Nsiv;

%---------------------------------------------
% Calculate Precision
%---------------------------------------------
SDVaveNoise = sdvnoise/sqrt(Nsiv);

%---------------------------------------------
% Return
%---------------------------------------------
PRCALC.CV = SIV.CV;
PRCALC.Nsiv = SIV.Nsiv;
PRCALC.SDVaveNoise = SDVaveNoise;
PRCALC.AbsPrec95 = 1.96*SDVaveNoise;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'CV',PRCALC.CV,'Output'};
Panel(2,:) = {'Nsiv',PRCALC.Nsiv,'Output'};
Panel(3,:) = {'SDVaveNoise',PRCALC.SDVaveNoise,'Output'};
Panel(4,:) = {'AbsPrec95',PRCALC.AbsPrec95,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
PRCALC.PanelOutput = PanelOutput;

