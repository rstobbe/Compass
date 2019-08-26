%=========================================================
% 
%=========================================================

function [SIMDES,err] = Anlz_SpoiledSS_v1a_Func(SIMDES,INPUT)

Status('busy','Analyze Spoiled Steady-State Signal');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT

%---------------------------------------------
% Common Variables;
%---------------------------------------------
T1 = SIMDES.T1;
T2 = SIMDES.T2;
TR = SIMDES.TR;
flip = pi*SIMDES.flip/180;

%---------------------------------------------
% Calculate
%---------------------------------------------
rSig = ((1-(exp(-TR/T1)))/(1-cos(flip)*exp(-TR/T1)))*sin(flip)
SIMDES.rSIG = rSig;


