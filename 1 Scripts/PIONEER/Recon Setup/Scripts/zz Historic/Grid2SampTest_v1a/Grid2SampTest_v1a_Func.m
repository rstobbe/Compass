%====================================================
%
%====================================================

function [CONV,err] = Grid2SampTest_v1a_Func(INPUT,CONV)

Status('busy','Convolution Test');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
RDAT = INPUT.RDAT;
clear INPUT

%--------------------------------------------
% Find Points
%--------------------------------------------
StatLev = 2;
Ksz = RDAT.Ksz;
CDat = ones(Ksz,Ksz,Ksz);
[Dat,err] = mG2SMexConvPC_v1a(RDAT,CDat,StatLev);
Status2('done','',2);

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'Imp_File',CONV.ImpFile,'Output'};
Panel(2,:) = {'Kern_File',CONV.KernFile,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
CONV.PanelOutput = PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
CONV.KernVals = KernVals;
CONV.CDatInds = CDatInds;

