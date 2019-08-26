%===========================================
% 
%===========================================

function [ISHIM,err] = ShimImageIntensityLPF_v2c_Func(ISHIM,INPUT)

Status2('busy','Intensity Shim',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG;
if length(IMG) > 1
    err.flag = 1;
    err.msg = '''ShimImageIntensityLPF'' for single image only';
    return
end
IMG = IMG{1};
ReconPars = IMG.ReconPars;
if isfield(INPUT,'visuals')
    visuals = INPUT.visuals;
else
    visuals = 'Yes';
end
clear INPUT;

%---------------------------------------------
% Scale and Mask
%---------------------------------------------
Im0 = abs(IMG.Im);
Im0 = Im0/max(Im0(:));
Im00 = Im0;
NaNProf = zeros(size(Im0));
NaNProf(Im0 < ISHIM.relminval) = 1;
NaNProf(Im0 > ISHIM.relmaxval) = 1;
NaNProf = logical(NaNProf);
Im0(NaNProf) = NaN;

%---------------------------------------------
% Display
%---------------------------------------------
for n = 1:1

    sz = size(Im0);
    mxd = sz(3);
    fhand = figure(1000);
    ahand = axes('Parent',fhand);
    ahand.Position = [0,0,1,1];
    IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = round(mxd/20); IMSTRCT.stop = mxd; 
    IMSTRCT.rows = 5; IMSTRCT.lvl = [ISHIM.relminval-0.01 ISHIM.relmaxval+0.01]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000; 
    IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap6'; IMSTRCT.figsize = []; IMSTRCT.lblvals = []; IMSTRCT.ahand = ahand; IMSTRCT.fhand = fhand;
    ImageMontage_v2b(Im0,IMSTRCT);

    cont = questdlg('Continue');
    if not(strcmp(cont,'Yes'))
        err.flag = 4;
        return
    end

    medval = nanmedian(Im0(:));
    Im0(NaNProf) = medval;

    %---------------------------------------------
    % Display
    %---------------------------------------------
    if strcmp(visuals,'Yes')
        fh = figure(10000); clf;
        fh.Name = 'Image Intensity Shim';
        fh.NumberTitle = 'off';
        fh.Position = [300 50 1200 900];
        sz = size(Im0);
        maxval = max(abs(Im0(:)));
        ImAx = squeeze(abs(permute(Im0(:,:,sz(2)/2),[1,2,3])));
        subplot(3,3,1); imshow(ImAx,[0 maxval]),
        ImCor = flip(squeeze(abs(permute(Im0(:,sz(2)/2,:),[3,1,2]))),1);
        subplot(3,3,2); imshow(ImCor,[0 maxval]),
        ImSag = flip(squeeze(abs(permute(Im0(sz(2)/2,:,:),[3,2,1]))),1);
        subplot(3,3,3); imshow(ImSag,[0 maxval]);  
    end

    %-------------------------------------------
    % Create Filter
    %-------------------------------------------
    Status2('busy','Create Filter',3);
    fwidx = 2*round((ReconPars.ImfovLR/ISHIM.profres)/2);
    fwidy = 2*round((ReconPars.ImfovTB/ISHIM.profres)/2);
    fwidz = 2*round((ReconPars.ImfovIO/ISHIM.profres)/2);
    F = Kaiser_v1b(fwidx,fwidy,fwidz,ISHIM.proffilt,'unsym');
    Status2('done','Create Filter',3);

    %---------------------------------------------
    % Isotropic Low Res Image
    %---------------------------------------------
    [x0,y0,z0] = size(Im0);
    kdat0 = fftshift(fftn(ifftshift(Im0)));
    kdat = kdat0(x0/2-fwidx/2+1:x0/2+fwidx/2,y0/2-fwidy/2+1:y0/2+fwidy/2,z0/2-fwidz/2+1:z0/2+fwidz/2);
    clear kdat0;
    rat = 2*round(x0/max([fwidx fwidy fwidz]));
    %rat = 1.25*round(x0/max([fwidx fwidy fwidz]));
    x = rat*fwidx;
    y = rat*fwidy;
    z = rat*fwidz;
    kdat2 = zeros([x,y,z]);
    kdat2(x/2-fwidx/2+1:x/2+fwidx/2,y/2-fwidy/2+1:y/2+fwidy/2,z/2-fwidz/2+1:z/2+fwidz/2) = kdat.*F;
    tIm = fftshift(ifftn(ifftshift(kdat2)));
    clear kdat2;
    whos

    %---------------------------------------------
    % Shrink FoV
    %---------------------------------------------
    voxdimx = ReconPars.ImfovLR/x;
    voxdimy = ReconPars.ImfovTB/y;
    voxdimz = ReconPars.ImfovIO/z;
    voxdim = mean([voxdimx voxdimy voxdimz]);
    N = floor(ISHIM.profstretch/voxdim);
    N = N+1;
    tIm2 = tIm(N:x-N+1,N:y-N+1,N:z-N+1);
    clear tIm;
    [x,y,z] = size(tIm2);

    %---------------------------------------------
    % Convert Back
    %---------------------------------------------
    kdat3 = fftshift(fftn(ifftshift(tIm2)));
    clear tIm2;
    kdat4 = kdat3(x/2-x0/2+1:x/2+x0/2,y/2-y0/2+1:y/2+y0/2,z/2-z0/2+1:z/2+z0/2);
    clear kdat3;
    Prof = fftshift(ifftn(ifftshift(kdat4)));
    clear kdat4;
    % Prof = Prof/max(Prof(:));
    % if strcmp(ISHIM.background,'NaN')
    %     %Prof(Im0 < ISHIM.profrelmin) = NaN;
    %     Prof(Prof < ISHIM.profrelmin) = NaN;
    % else
    %     %Prof(Im0 < ISHIM.profrelmin) = ISHIM.profrelmin;
    %     Prof(Prof < ISHIM.profrelmin) = ISHIM.profrelmin;
    % end

    %---------------------------------------------
    % Display
    %---------------------------------------------
    if strcmp(visuals,'Yes')
        maxval = max(abs(Prof(:)));
        ImAx = squeeze(abs(permute(Prof(:,:,sz(2)/2),[1,2,3])));
        subplot(3,3,4); imshow(ImAx,[0 maxval]),
        ImCor = flip(squeeze(abs(permute(Prof(:,sz(2)/2,:),[3,1,2]))),1);
        subplot(3,3,5); imshow(ImCor,[0 maxval]),
        ImSag = flip(squeeze(abs(permute(Prof(sz(2)/2,:,:),[3,2,1]))),1);
        subplot(3,3,6); imshow(ImSag,[0 maxval]);  
    end

    Im0 = Im00;
    Im0(NaNProf) = Prof(NaNProf);

end

%---------------------------------------------
% Correct
%---------------------------------------------
Im = Im00./Prof;
clear Im00 Prof
Im = Im/max(Im(:));

%---------------------------------------------
% Display
%---------------------------------------------
if strcmp(visuals,'Yes')
    maxval = max(abs(Im(:)));
    ImAx = squeeze(abs(permute(Im(:,:,sz(2)/2),[1,2,3])));
    subplot(3,3,7); imshow(ImAx,[0 maxval]),
    ImCor = flip(squeeze(abs(permute(Im(:,sz(2)/2,:),[3,1,2]))),1);
    subplot(3,3,8); imshow(ImCor,[0 maxval]),
    ImSag = flip(squeeze(abs(permute(Im(sz(2)/2,:,:),[3,2,1]))),1);
    subplot(3,3,9); imshow(ImSag,[0 maxval]);  
end

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',ISHIM.method,'Output'};
ISHIM.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%--------------------------------------------- 
IMG.Im = Im;
IMG.name = [IMG.name,'_iShim'];
ISHIM.IMG = IMG;
ISHIM.FigureName = 'Intensity Shim';

Status2('done','',2);
Status2('done','',3);

