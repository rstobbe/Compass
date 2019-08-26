%====================================================
%  
%====================================================

function [RF,err] = Create_RFwfm_v1b_Func(INPUT,RF)

Status('busy','Create RF Waveform');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
CRTE = INPUT.CRTE;
SIM = INPUT.SIM;
CALC = INPUT.CALC;
WRT = INPUT.WRT;
clear INPUT;

%---------------------------------------------
% Create RF
%---------------------------------------------
func = str2func([RF.crtefunc,'_Func']);
INPUT = struct();
[CRTE,err] = func(CRTE,INPUT);
if err.flag
    return
end
wfm = CRTE.wfm;
Dflip = CRTE.Dflip;
Dtbwprod = CRTE.Dtbwprod;
clear INPUT

%---------------------------------------------
% Plot
%---------------------------------------------
figure(100); hold on;
plot(real(wfm),'r');
plot(imag(wfm),'b');
xlabel('ms');
ylabel('Relative');
title('Relative RF pulse shape');

%---------------------------------------------
% Simulate
%---------------------------------------------
func = str2func([RF.simfunc,'_Func']);
INPUT.wfm = wfm;
INPUT.flip = Dflip;
INPUT.simhbw = Dtbwprod;
[SIM,err] = func(SIM,INPUT);
if err.flag
    return
end
clear INPUT
M = SIM.M;
tbw = SIM.tbw;

%---------------------------------------------
% Calculate
%---------------------------------------------
func = str2func([RF.calcfunc,'_Func']);
INPUT.M = M;
INPUT.tbw = tbw;
INPUT.CRTE = CRTE;
[CALC,err] = func(CALC,INPUT);
if err.flag
    return
end
clear INPUT
BLD = CALC.BLD;
RF.PanelOutput = CALC.PanelOutput;

%---------------------------------------------
% Write
%---------------------------------------------
func = str2func([RF.wrtfunc,'_Func']);
INPUT.CRTE = CRTE;
INPUT.BLD = BLD;
[WRT,err] = func(WRT,INPUT);
if err.flag
    return
end
clear INPUT

%---------------------------------------------
% Return
%---------------------------------------------
RF.CRTE = CRTE;
RF.SIM = SIM;
RF.BLD = BLD;

Status('done','');
Status2('done','',2);
Status2('done','',3);

