%====================================================
%
%====================================================

function [RDAT,err] = Grid2SampPreCalc_v1a_Func(INPUT,RDAT)

Status('busy','Grid2Samp PreCalculate');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
IMP = INPUT.IMP;
if isfield(IMP,'impPROJdgn');
    PROJdgn = IMP.impPROJdgn;
else
    PROJdgn = IMP.PROJdgn;
end
KRNprms = INPUT.KRNprms;
PROJimp = IMP.PROJimp;
Kmat = IMP.Kmat;
clear INPUT

%---------------------------------------------
% Variables
%---------------------------------------------
kstep = PROJdgn.kstep;
npro = PROJimp.npro;
nproj = PROJimp.nproj;
SS = KRNprms.DesforSS;

%---------------------------------------------
% Convolution Kernel Tests
%---------------------------------------------
if rem(round(1e9*(1/(KRNprms.res*SS)))/1e9,1)
    err.flag = 1;
    err.msg = '1/(kernres*SS) not an integer';
    return
elseif rem((KRNprms.W/2)/KRNprms.res,1)
    err.flag = 1;
    err.msg = '(W/2)/kernres not an integer';
    return
end

%---------------------------------------------
% Convolution Kernel Setup
%---------------------------------------------
KERN.W = KRNprms.W*SS;
KERN.res = KRNprms.res*SS;
KERN.iKern = round(1e9*(1/(KRNprms.res*SS)))/1e9;
KERN.Kern = KRNprms.Kern;
CONV.chW = ceil(((KRNprms.W*SS)-2)/2);                    % with mFCMexSingleR_v3
if (CONV.chW+1)*KERN.iKern > length(KERN.Kern)
    err.flag = 1;
    err.msg = 'zW of Kernel not large enough';
    return
end

%---------------------------------------------
% Normalize Trajectories to Grid
%---------------------------------------------
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4b(Kmat,nproj,npro,kstep,CONV.chW,SS,'M2A');
clear Kmat
RDAT.Ksz = Ksz;

%--------------------------------------------
% Find Points
%--------------------------------------------
StatLev = 2;
[KernVals,CDatInds,err] = mG2SMexPreCalculate_v1a(Ksz,Kx,Ky,Kz,KERN,CONV,StatLev);
Status2('done','',2);

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'Imp_File',RDAT.ImpFile,'Output'};
Panel(2,:) = {'Kern_File',RDAT.KernFile,'Output'};
Panel(3,:) = {'Ksz',RDAT.Ksz,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
RDAT.PanelOutput = PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
KRNprms = rmfield(KRNprms,'Kern');
RDAT.KernVals = KernVals;
RDAT.CDatInds = CDatInds;
RDAT.KRNprms = KRNprms;
