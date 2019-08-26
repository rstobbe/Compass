%=========================================================
% 
%=========================================================

function [SIGDEC,err] = BiExpAddTE_v1a_Func(SIGDEC,INPUT)

Status2('busy','Add Bi-Exponential decay',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SampDat = INPUT.SampDat;
samp = INPUT.samp;
PROJimp = INPUT.PROJimp;
T2f = SIGDEC.T2f;
T2s = SIGDEC.T2s;
TE = SIGDEC.TE;
clear INPUT;

%---------------------------------------------
% Add Exponential Decay
%---------------------------------------------
samp = samp + TE;
T2decay = 0.6*exp(-samp/T2f) + 0.4*exp(-samp/T2s);
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