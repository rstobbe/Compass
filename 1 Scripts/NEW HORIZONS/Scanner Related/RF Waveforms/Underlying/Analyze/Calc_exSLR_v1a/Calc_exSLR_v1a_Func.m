%====================================================
%  
%====================================================

function [CALC,err] = Calc_exSLR_v1a_Func(CALC,INPUT)

Status2('busy','Calculate exSLR Aspects',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
M = INPUT.M;
tbw = INPUT.tbw;
CRTE = INPUT.CRTE;
clear INPUT;

%---------------------------------------------
% Test BW
%---------------------------------------------
Etbwprod = 2*interp1(abs(M),tbw,abs(M(1))/2);  

%---------------------------------------------
% Refocus
%---------------------------------------------
phase = unwrap(angle(M));
phaseaccum = interp1(tbw,phase,Etbwprod/2) - phase(1);
expectphaseaccum = (Etbwprod/4);                                % half BW for half time
ARef = abs(phaseaccum/(4*pi))/expectphaseaccum;

%---------------------------------------------
% Info
%---------------------------------------------
wfm = CRTE.wfm;
integral = sum(real(wfm))/length(wfm);
RelPower = round(sum(((1/integral)*abs(wfm)).^2));

%---------------------------------------------
% Panel Items
%---------------------------------------------
Panel(1,:) = {'Integral',integral,'Output'};
Panel(2,:) = {'RelPower',RelPower,'Output'};
Panel(3,:) = {'Etbwprod',Etbwprod,'Output'};
Panel(4,:) = {'RelAreaGradRefocus',ARef,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
CALC.PanelOutput = PanelOutput;

%---------------------------------------------
% Build Structure
%---------------------------------------------
BLD.Etbwprod = Etbwprod;
BLD.ARef = ARef;
BLD.type = CRTE.type;
BLD.modulate = CRTE.modulation;
BLD.gradref = CRTE.gradref;
BLD.integral = integral;
BLD.relpower = RelPower;

%---------------------------------------------
% Return
%---------------------------------------------
CALC.Etbwprod = Etbwprod;
CALC.ARef = ARef;
CALC.BLD = BLD;

Status2('done','',2);
Status2('done','',3);

