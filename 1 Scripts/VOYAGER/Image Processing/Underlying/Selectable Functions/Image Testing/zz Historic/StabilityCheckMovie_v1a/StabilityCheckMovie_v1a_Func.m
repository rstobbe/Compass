%=========================================================
% 
%=========================================================

function [TST,err] = StabilityCheckMovie_v1a_Func(TST,INPUT)

Status('busy','Test Image Array Stability');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MASK = INPUT.MASK;
FILT = INPUT.FILT;
IMG = INPUT.IMG;
SCRPTipt = INPUT.SCRPTipt;
SCRPTGBL = INPUT.SCRPTGBL;
Im = IMG.Im;
sz = size(Im)
clear INPUT;

%---------------------------------------------
% Select Subset
%---------------------------------------------
ind = strfind(TST.images,':');
im1 = str2double(TST.images(1:ind(1)-1));
im2 = str2double(TST.images(ind(1)+1:end));
imnums = (im1:im2);
%Im = squeeze(Im(:,:,TST.slicenum,imnums));
Im = squeeze(Im(:,:,TST.slicenum,imnums,4));
sz = size(Im);

% %---------------------------------------------
% % Filter
% %---------------------------------------------
% func = str2func([TST.filtfunc,'_Func']); 
% %----
% INPUT.Im = Im;
% %----
% INPUT.ReconPars = [];
% [FILT,err] = func(FILT,INPUT);
% if err.flag
%     return
% end
% clear INPUT;
% Im = FILT.Im;

%---------------------------------------------
% Create Mask
%---------------------------------------------
func = str2func([TST.maskfunc,'_Func']); 
INPUT.AbsIm = abs(squeeze(Im(:,:,1)));
INPUT.ReconPars = [];
INPUT.figno = 1000;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
[MASK,err] = func(MASK,INPUT);
if err.flag
    return
end
clear INPUT;
Mask = MASK.Mask;

%---------------------------------------------
% Mask Image
%---------------------------------------------
sz = size(Im);
if not(isempty(Mask))
    for n = 1:sz(3)
        Im(:,:,n) = Im(:,:,n).*Mask;
    end
end    

%---------------------------------------------
% Test
%---------------------------------------------
scale = max(abs(Im(:)));
fighand = figure;
IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = 1; 
IMSTRCT.rows = 1; IMSTRCT.lvl = [0 scale]; IMSTRCT.SLab = 0; IMSTRCT.figno = fighand; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(abs(Im),IMSTRCT);

%---------------------------------------------
% Sort Type
%---------------------------------------------
if strcmp(TST.type,'Abs')
    Im = abs(Im);
elseif strcmp(TST.type,'Phase')
    test = isreal(Im);
    if test == 1
        err.flag = 1;
        err.msg = 'Input Image Not Complex';
        return
    end
    Im = angle(Im);
elseif strcmp(TST.type,'Real')
    Im = real(Im);    
elseif strcmp(TST.type,'Imag')
    Im = imag(Im);
end

%---------------------------------------------
% Find Mean
%---------------------------------------------
MeanIm = mean(Im,3);
sz = size(Im);
ImDif = zeros(sz);
for n = 1:sz(3)
    if strcmp(TST.type,'Phase')
        ImDif(:,:,n) = (180/pi)*(Im(:,:,n) - MeanIm);
    else
        ImDif(:,:,n) = 100*(Im(:,:,n) - MeanIm) ./ MeanIm;
    end
end

%---------------------------------------------
% Plot
%---------------------------------------------
if strcmp(TST.type,'Abs')
    scale = 4;
elseif strcmp(TST.type,'Phase')
    scale = 8;
end

%---------------------------------------------
% Plot Image Movie
%--------------------------------------------- 
fighand = figure;
IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = 1; 
IMSTRCT.rows = 1; IMSTRCT.lvl = [-scale scale]; IMSTRCT.SLab = 0; IMSTRCT.figno = fighand; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(ImDif,IMSTRCT);
m = 1;
for n = 1:1:sz(3)
    IMSTRCT.start = n; IMSTRCT.stop = n; 
    AxialMontage_v2a(ImDif,IMSTRCT);
    
    F = getframe(fighand);
    [Xt,~] = frame2im(F);
    X(:,:,:,m) = rgb2ind(Xt,[gray(128);jet(128)]);
    m = m+1;
    clf(fighand);  
end

%---------------------------------------------
% Save
%--------------------------------------------- 
[file,path] = uiputfile('*.gif','Name Movie');
if file == 0
    return
end
size(X)
%imwrite(X,[gray(128);jet(128)],[path,file],'gif','LoopCount',inf,'DelayTime',0);   
imwrite(X,[gray(128);jet(128)],[path,file],'gif','LoopCount',1,'DelayTime',0.25);    


Status('done','');
Status2('done','',2);
Status2('done','',3);
