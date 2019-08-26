%====================================================
%  
%====================================================

function [COR,err] = B1corrDW_v1a_Func(COR,INPUT)

Status2('busy','DW-weighted B1 Correction',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im = INPUT.Im;
B1Map = INPUT.B1Map;
SeqPars = INPUT.Sequence;
clear INPUT;

%---------------------------------------------
% Info
%---------------------------------------------
flip = SeqPars.flip_angle;

%---------------------------------------------
% Ensure proper
%---------------------------------------------
B1Map = real(B1Map);
B1Map(B1Map<0.5) = NaN;

%---------------------------------------------
% Calc
%---------------------------------------------
MxyDifFlip = sin(B1Map*pi*flip/180)/sin(pi*flip/180);
B1MapScale = B1Map.*MxyDifFlip;
%B1MapScale = MxyDifFlip;
%B1MapScale = B1Map;
B1MapScale(B1MapScale == 0) = NaN;
Im = Im./B1MapScale;

%---------------------------------------------
% Return
%---------------------------------------------
COR.Im = Im;

Status2('done','',2);
Status2('done','',3);

