%=========================================================
% 
%=========================================================

function [SIGDEC,err] = MonoExpAdd_v1a_Func(SIGDEC,INPUT)

Status2('busy','Add Mono-Exponential decay',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SampDat = INPUT.SampDat;
samp = INPUT.samp;
PROJimp = INPUT.PROJimp;
T2 = SIGDEC.T2;
clear INPUT;

%---------------------------------------------
% Add Exponential Decay
%---------------------------------------------
%TE = 0.5;
%samp = samp + TE;
T2decay = exp(-samp/T2);
[Datmat] = DatArr2Mat(SampDat,PROJimp.nproj,PROJimp.npro);
T2decaymat = repmat(T2decay,[PROJimp.nproj 1]);
SampDat = DatMat2Arr(Datmat.*T2decaymat,PROJimp.nproj,PROJimp.npro);

%--
% - Orientation Test
%SampDat = SampDat + 10000*randn(size(SampDat));
%--

%---------------------------------------------
% Return
%---------------------------------------------
SIGDEC.SampDat = SampDat;

Status2('done','',3);