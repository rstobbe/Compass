%====================================================
%  
%====================================================

function [COR,err] = B1corrDW_v1b_Func(COR,INPUT)

Status2('busy','DW-weighted B1 Correction',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im = INPUT.Im;
B1map = INPUT.B1Map;
Sequence = INPUT.Sequence;
clear INPUT;

%---------------------------------------------
% Info
%---------------------------------------------
flip = Sequence.flip_angle;

%---------------------------------------------
% Ensure proper
%---------------------------------------------
B1map = real(B1map);
B1map(B1map<0.5) = NaN;

%---------------------------------------------
% Calc
%---------------------------------------------
MxyDifFlip = sin(B1map*pi*flip/180)/sin(pi*flip/180);
%B1mapScale = B1map.*MxyDifFlip;
B1mapScale = MxyDifFlip;
%B1mapScale = B1map;
B1mapScale(B1mapScale == 0) = NaN;
Im = Im./B1mapScale;

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = B1mapScale;
COR.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

