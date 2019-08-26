%====================================================
%  
%====================================================

function [B1MAP,err] = B1map2angle_v1b_Func(B1MAP,INPUT)

Status('busy','Generate B1map');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
clear INPUT;
Im(:,:,:,1) = IMG{1}.Im;
Im(:,:,:,2) = IMG{2}.Im;

%---------------------------------------------
% Drop Resolution
%---------------------------------------------
Sz = 16;                    % note 16 used for paper.
%Sz = 10;
beta = 6;
Filt = Kaiser_v1b(Sz,Sz,Sz,beta,'unsym');
sz = size(Im);
bot = (sz(1)-Sz)/2+1;
top = bot + Sz-1;
for n = 1:2
    k = fftshift(ifftn(ifftshift(Im(:,:,:,n))));
    k2 = zeros(size(k));
    k2(bot:top,bot:top,bot:top) = Filt.*k(bot:top,bot:top,bot:top);
    Im2(:,:,:,n) = fftshift(fftn(ifftshift(k2)));
end

%---------------------------------------------
% Mask
%---------------------------------------------
B1MAP.MV = 0.1;
mask = abs(mean(Im,4));
mask(mask < B1MAP.MV) = 0;
mask(mask >= B1MAP.MV) = 1;

%---------------------------------------------
% Calc
%---------------------------------------------
Im2 = abs(Im2);
Im = abs(Im);

Imrel2 = Im2(:,:,:,1)./Im2(:,:,:,2);
Imrel1 = Im(:,:,:,1)./Im(:,:,:,2);
%Imrel = Imrel1./Imrel2;
Imrel = Imrel2;

Imflip = acos(1./(2*Imrel));
B1rel = (Imflip*180/pi)/B1MAP.specflip1;
%B1rel = Imrel;

%---------------------------------------------
% Return
%---------------------------------------------
B1MAP.Im = B1rel .* mask;
%B1MAP.Im = B1rel;

%---------------------------------------------
% Display
%---------------------------------------------
sz = size(B1MAP.Im);
IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = floor(sqrt(sz(3))+1); IMSTRCT.lvl = [0.8 1.2]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(B1MAP.Im,IMSTRCT);

%---------------------------------------------
% Return
%---------------------------------------------
if isfield(IMG{1},'PanelOutput');
    B1MAP.PanelOutput = IMG{1}.PanelOutput;
else
    Panel(1,:) = {'','','Output'};
    PanelOutput = cell2struct(Panel,{'label','value','type'},2);
    B1MAP.PanelOutput = PanelOutput;
end

Status('done','');
Status2('done','',2);
Status2('done','',3);

