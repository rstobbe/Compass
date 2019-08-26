%=========================================================
% 
%=========================================================

function [COMP,err] = DiffImageGen_v1a_Func(COMP,INPUT)

Status('busy','Difference Image Generation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
Im = IMG.Im;
clear INPUT;

%---------------------------------------------
% Calculate
%---------------------------------------------
ImDif = squeeze(Im(:,:,:,1) - Im(:,:,:,2));
%ImDif = ImDif./squeeze(Im(:,:,:,1));

%---------------------------------------------
% Plot
%---------------------------------------------
Scale = max(abs(Im(:)))/30;
%Scale = max(abs(Ims(:)));
ImDif = ImDif/Scale;
sz = size(ImDif);
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = floor(sqrt(sz(3))); IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = figure(); 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(ImDif,IMSTRCT);

%---------------------------------------------
% Return
%---------------------------------------------
COMP.ImDif = ImDif;

error();








%---------------------------------------------
% Plot
%---------------------------------------------
%Scale = max(abs(Im(:)));
%ImDif = ImDif/Scale;
%sz = size(ImDif);
%IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
%IMSTRCT.rows = floor(sqrt(sz(3))); IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = figure(); 
%IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
%AxialMontage_v2a(ImDif,IMSTRCT);

%---------------------------------------------
% Return
%---------------------------------------------
%COMP.PanelOutput = IMG.PanelOutput;
%COMP.Im = ImDif;

Status('done','');
Status2('done','',2);
Status2('done','',3);
