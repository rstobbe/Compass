%=========================================================
% 
%=========================================================

function [TST,err] = StabilityCheck_v1b_Func(TST,INPUT)

Status('busy','Test Image Array Stability');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
LOAD = INPUT.LOAD;
clear INPUT;

%---------------------------------------------
% Load Image
%---------------------------------------------
func = str2func([TST.loadfunc,'_Func']); 
INPUT = struct();
[LOAD,err] = func(LOAD,INPUT);
if err.flag
    return
end
clear INPUT;
Im = LOAD.Im;

%---------------------------------------------
% Drop (temp)
%---------------------------------------------
Im = Im(:,:,:,3:end);
test = size(Im);

%---------------------------------------------
% Sort Type
%---------------------------------------------
if strcmp(TST.type,'Abs')
    Ims = abs(Im);
elseif strcmp(TST.type,'Phase')
    Ims = angle(Im);
elseif strcmp(TST.type,'Real')
    Ims = real(Im);    
elseif strcmp(TST.type,'Imag')
    Ims = imag(Im);
end

%---------------------------------------------
% Find Mean
%---------------------------------------------
MeanIm = mean(Ims,4);

sz = size(Ims);
ImDif = zeros(sz);
for n = 1:sz(4)
    if strcmp(TST.type,'Phase')
        ImDif(:,:,:,n) = (180/pi)*(Ims(:,:,:,n) - MeanIm);
    else
        ImDif(:,:,:,n) = 100*(Ims(:,:,:,n) - MeanIm) ./ MeanIm;
    end
end

%---------------------------------------------
% Permute
%---------------------------------------------
ImDif = permute(ImDif,[1 2 4 3]);

%---------------------------------------------
% Plot
%---------------------------------------------
% slice = 4;
% scale = 2;
% pltImDif = squeeze(ImDif(:,:,:,slice));
% sz = size(pltImDif);
% IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
% IMSTRCT.rows = sz(3); IMSTRCT.lvl = [-scale scale]; IMSTRCT.SLab = 0; IMSTRCT.figno = figure(); 
% IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
% AxialMontage_v2a(pltImDif,IMSTRCT);

%---------------------------------------------
% Plot
%---------------------------------------------
% pltMeanIm = squeeze(MeanIm(:,:,slice));
% scale = max(pltMeanIm(:));
% IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = 1; 
% IMSTRCT.rows = 1; IMSTRCT.lvl = [0 scale]; IMSTRCT.SLab = 0; IMSTRCT.figno = figure(); 
% IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
% AxialMontage_v2a(pltMeanIm,IMSTRCT);

%---------------------------------------------
% Return
%---------------------------------------------
TST.PanelOutput = IMG.PanelOutput;
TST.Im = ImDif;

Status('done','');
Status2('done','',2);
Status2('done','',3);
