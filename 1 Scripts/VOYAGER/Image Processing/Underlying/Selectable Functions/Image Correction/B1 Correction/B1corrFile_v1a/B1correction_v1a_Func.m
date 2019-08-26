%====================================================
%  
%====================================================

function [COR,err] = B1correction_v1a_Func(COR,INPUT)

Status('busy','B1-Correction (DW)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im = INPUT.Im;
B1map = INPUT.B1map;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------


%---------------------------------------------
% Calc
%---------------------------------------------
error();    % fix this function so that flip comes from the image data 
%flip = 90;
B1mapScale = (B1map.*sin(pi*flip/180*B1map))/sin(pi*flip/180);
B1mapScale(B1mapScale == 0) = NaN;
Im = Im./B1mapScale;

%---------------------------------------------
% Mask
%---------------------------------------------
COR.MV = 1;
Im(abs(Im) < COR.MV) = 0;
Im(isnan(Im)) = 0;

%---------------------------------------------
% Display
%---------------------------------------------
sz = size(B1mapScale);
IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = floor(sqrt(sz(3))+1); IMSTRCT.lvl = [0.75 1.25]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(B1mapScale,IMSTRCT);

%---------------------------------------------
% Display
%---------------------------------------------
sz = size(Im);
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = floor(sqrt(sz(3))+1); IMSTRCT.lvl = [0 max(abs(Im(:)))]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1001; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(Im,IMSTRCT);

%---------------------------------------------
% Return
%---------------------------------------------
%if isfield(IMG{1},'PanelOutput');
%    B1MAP.PanelOutput = IMG{1}.PanelOutput;
%end

COR.Im = Im;

Status('done','');
Status2('done','',2);
Status2('done','',3);

