%=========================================================
% 
%=========================================================

function [COMP,err] = RelImageGen_v1a_Func(INPUT,COMP)

Status('busy','Relative Image Generation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Ims = INPUT.Ims;
clear INPUT;

%---------------------------------------------
% Calculate
%---------------------------------------------
ImDif = squeeze(Ims(:,:,:,2)./Ims(:,:,:,1));

%---------------------------------------------
% Plot
%---------------------------------------------
%Scale = max(abs(Ims(:)));
%ImDif = ImDif/Scale;
%sz = size(ImDif);
%IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
%IMSTRCT.rows = floor(sqrt(sz(3)))+1; IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = figure(); 
%IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
%AxialMontage_v2a(ImDif,IMSTRCT);

sz = size(ImDif);
IMSTRCT.type = 'phase'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = floor(sqrt(sz(3)))+1; IMSTRCT.lvl = [-pi/4 pi/4]; IMSTRCT.SLab = 0; IMSTRCT.figno = figure(); 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(ImDif,IMSTRCT);

%---------------------------------------------
% Return
%---------------------------------------------
COMP.ImDif = ImDif;

Status('done','');
Status2('done','',2);
Status2('done','',3);
