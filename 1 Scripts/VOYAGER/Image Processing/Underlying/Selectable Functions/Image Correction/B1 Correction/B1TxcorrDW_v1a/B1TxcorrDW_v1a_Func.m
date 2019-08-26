%====================================================
%  
%====================================================

function [COR,err] = B1TxcorrDW_v1a_Func(COR,INPUT)

Status2('busy','DW-weighted B1 Correction (Tx only)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
B1MAP = INPUT.B1MAP;
clear INPUT;
Im = IMG.Im;
B1map = B1MAP.Im;

%---------------------------------------------
% Info
%---------------------------------------------
SeqPars = IMG.ExpPars.Sequence;
flip = SeqPars.flipangle;

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
% Display
%---------------------------------------------
% sz = size(B1mapScale);
% IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
% IMSTRCT.rows = floor(sqrt(sz(3))+1); IMSTRCT.lvl = [0.75 1.25]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000; 
% IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
% AxialMontage_v2a(B1mapScale,IMSTRCT);

%---------------------------------------------
% Display
%---------------------------------------------
% sz = size(Im);
% IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
% IMSTRCT.rows = floor(sqrt(sz(3))+1); IMSTRCT.lvl = [0 max(abs(Im(:)))]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1001; 
% IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
% AxialMontage_v2a(Im,IMSTRCT);

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = Im;
COR.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

