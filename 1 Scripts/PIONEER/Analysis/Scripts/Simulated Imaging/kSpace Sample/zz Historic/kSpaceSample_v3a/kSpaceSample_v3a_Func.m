%===========================================
%
%===========================================

function [SAMP,err] = kSpaceSample_v3a_Func(INPUT,SAMP)

Status('busy','Sample k-Space');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
OB = INPUT.OB;
IMP = INPUT.IMP;
KSMP = INPUT.KSMP;
EFCT = INPUT.EFCT;
clear INPUT;

%----------------------------------------------------
% Get Sampling Info
%----------------------------------------------------
ZF = KSMP.IFprms.ZF;
SS = KSMP.IFprms.SS;

%----------------------------------------------------
% Build Object
%----------------------------------------------------
func = str2func([SAMP.ObjectFunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.ZF = ZF;
INPUT.SS = SS;
[OB,err] = func(OB,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Effect (on traj)
%---------------------------------------------
func = str2func([SAMP.EffectAddFunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.OB = OB;
INPUT.prepostsamp = 'pre';
[EFCT,err] = func(EFCT,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Plot
%---------------------------------------------
plotob = 1;
sz = size(OB.Ob);
start = round(((SS-1)/3)*sz(3));
stop = sz(3)-round(((SS-1)/3)*sz(3))+1;
INPUT.Image = OB.Ob(:,:,start:stop);
INPUT.numberslices = 28;
[MCHRS,err] = DefaultMontageChars_v1a(INPUT);
MCHRS.MSTRCT.figno = 100;
INPUT = MCHRS;
if isfield(EFCT,'B0map')
    B0Map = EFCT.B0map;
    if plotob == 1
        PlotMontageOverlay_v1e(INPUT);
    end   
else
    B0Map = 0;
    if plotob == 1
        PlotMontageImage_v1e(INPUT);
    end
end
clear INPUT;

button = questdlg('Continue?');
if strcmp(button,'No') || strcmp(button,'Cancel')
    err.flag = 4;
    return
end

%---------------------------------------------
% Orient
%---------------------------------------------
OB.Ob = permute(OB.Ob,[2 1 3]);                        

%---------------------------------------------
% Sample
%---------------------------------------------
func = str2func([SAMP.SampleFunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.OB = OB;
INPUT.B0Map = B0Map;
INPUT.MaskFoV = 'No';
[KSMP,err] = func(KSMP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Effect (on data)
%---------------------------------------------
func = str2func([SAMP.EffectAddFunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.OB = OB;
INPUT.KSMP = KSMP;
INPUT.prepostsamp = 'post';
[EFCT,err] = func(EFCT,INPUT);
if err.flag
    return
end
KSMP.SampDat = EFCT.SampDat;
clear INPUT;

%---------------------------------------------
% Panel
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'ImpFile',IMP.name,'Output'};
Panel(3,:) = {'KernFile',KSMP.KRNprms.name,'Output'};
Panel(4,:) = {'InvFiltFile',KSMP.IFprms.name,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
SAMP.PanelOutput = PanelOutput;
SAMP.PanelOutput = [SAMP.PanelOutput;OB.PanelOutput];

%---------------------------------------------
% Return
%---------------------------------------------
SAMP.SampDat = DatArr2Mat(KSMP.SampDat,IMP.PROJdgn.nproj,IMP.PROJimp.npro);
OB = rmfield(OB,'Ob');
SAMP.OB = OB;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);


