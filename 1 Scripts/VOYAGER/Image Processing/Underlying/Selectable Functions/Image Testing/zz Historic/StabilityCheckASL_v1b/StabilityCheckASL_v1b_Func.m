%=========================================================
% 
%=========================================================

function [TST,err] = StabilityCheckASL_v1b_Func(TST,INPUT)

Status('busy','Test Image Array Stability');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MASK = INPUT.MASK;
IMG = INPUT.IMG;
SCRPTipt = INPUT.SCRPTipt;
SCRPTGBL = INPUT.SCRPTGBL;
Im = IMG.Im;
clear INPUT;

%---------------------------------------------
% Select Subset
%---------------------------------------------
sz = size(Im);
imnums = (3:102);
%imnums = (51:100);
Im = Im(:,:,:,imnums);
sz = size(Im);

% %---------------------------------------------
% % Plot Image Movie
% %--------------------------------------------- 
% %scale = 15000;
% scale = 50;
% slice = 10;
% fighand = figure;
% Imtest = squeeze(Im(:,:,slice,:));
% Imtest = abs(Imtest);
% IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = 1; 
% IMSTRCT.rows = 1; IMSTRCT.lvl = [0 scale]; IMSTRCT.SLab = 0; IMSTRCT.figno = fighand; 
% IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
% AxialMontage_v2a(Imtest,IMSTRCT);
% m = 1;
% for n = 1:1:sz(4)
%     IMSTRCT.start = n; IMSTRCT.stop = n; 
%     AxialMontage_v2a(Imtest,IMSTRCT);
%     
%     F = getframe(fighand);
%     [Xt,~] = frame2im(F);
%     X(:,:,:,m) = rgb2ind(Xt,[gray(128);jet(128)]);
%     m = m+1;
%     clf(fighand);  
% end
% 
% %---------------------------------------------
% % Save
% %--------------------------------------------- 
% [file,path] = uiputfile('*.gif','Name Movie');
% if file == 0
%     return
% end
% size(X)
% imwrite(X,[gray(128);jet(128)],[path,file],'gif','LoopCount',inf,'DelayTime',0);    
% error();

%---------------------------------------------
% Create Mask
%---------------------------------------------
func = str2func([TST.maskfunc,'_Func']); 
INPUT.AbsIm = abs(squeeze(Im(:,:,:,1)));
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
if not(isempty(Mask))
    for n = 1:sz(4)
        Im(:,:,:,n) = Im(:,:,:,n).*Mask;
    end
end    

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
MeanIm = mean(Im,4);
sz = size(Im);
ImDif = zeros(sz);
for n = 1:sz(4)
    if strcmp(TST.type,'Phase')
        ImDif(:,:,:,n) = (180/pi)*(Im(:,:,:,n) - MeanIm);
    else
        ImDif(:,:,:,n) = 100*(Im(:,:,:,n) - MeanIm) ./ MeanIm;
    end
end

%---------------------------------------------
% Plot
%---------------------------------------------
if strcmp(TST.type,'Abs')
    scale = 2;
    slice = 10;
    rows = 10;
    pltImDif = squeeze(ImDif(50:200,:,slice,:));
    pltsz = size(pltImDif);
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = pltsz(3); 
    IMSTRCT.rows = rows; IMSTRCT.lvl = [-scale scale]; IMSTRCT.SLab = 0; IMSTRCT.figno = figure(); 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
    AxialMontage_v2a(pltImDif,IMSTRCT);
end

if strcmp(TST.type,'Phase')
    scale = 0.1;
    slice = 10;
    rows = 10;
    pltImDif = squeeze(ImDif(50:200,:,slice,:));
    pltsz = size(pltImDif);
    IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = pltsz(3); 
    IMSTRCT.rows = rows; IMSTRCT.lvl = [-scale scale]; IMSTRCT.SLab = 0; IMSTRCT.figno = figure(); 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
    AxialMontage_v2a(pltImDif,IMSTRCT);
end

%---------------------------------------------
% Plot Other
%---------------------------------------------
scale = 2;
rows = 5;
%ImAv1 = squeeze(mean(abs(Im(50:200,:,:,(76:100))),4));
%ImAv2 = squeeze(mean(abs(Im(50:200,:,:,(176:200))),4));
%ImAv1 = squeeze(mean(abs(Im(50:200,:,:,(1:2:99))),4));
%ImAv2 = squeeze(mean(abs(Im(50:200,:,:,(2:2:100))),4));
%ImAv1 = squeeze(mean(abs(Im(50:200,:,:,(101:2:199))),4));
%ImAv2 = squeeze(mean(abs(Im(50:200,:,:,(102:2:200))),4));
ImAv1 = squeeze(mean(abs(Im(50:200,:,:,(1:100))),4));
ImAv2 = squeeze(mean(abs(Im(50:200,:,:,(101:200))),4));
pltImDif = 100*(ImAv1-ImAv2)./((ImAv1+ImAv2)/2);
pltsz = size(pltImDif);
IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = pltsz(3); 
IMSTRCT.rows = rows; IMSTRCT.lvl = [-scale scale]; IMSTRCT.SLab = 0; IMSTRCT.figno = figure(); 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(pltImDif,IMSTRCT);


%---------------------------------------------
% Plot 
%---------------------------------------------
% figure(1000); hold on;
% for n = 1:sz(1)
%     for m = 1:sz(2)
%         for p = 1:sz(3)
%             plot(squeeze(ImDif(n,m,p,:)));
%         end
%     end
% end

%---------------------------------------------
% Plot 
%---------------------------------------------
% figure(1001); hold on;
% test = squeeze(nanmean(abs(ImDif),1));
% test = squeeze(nanmean(abs(test),1));
% test = squeeze(nanmean(abs(test),1));
% plot(test)



Status('done','');
Status2('done','',2);
Status2('done','',3);
