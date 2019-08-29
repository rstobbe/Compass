%=========================================================
% 
%=========================================================

function [MONT,err] = MontageCompass_v1a_Func(MONT,INPUT)

Status2('busy','Create Montage Figure for Compass',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
MSTRCT = INPUT.MSTRCT;
clear INPUT

%---------------------------------------------
% Columns (rewrite)
%---------------------------------------------
pixdim = MSTRCT.ImInfo.pixdim;
Ratio0 = 4/3;
sz = size(Image(:,:,:,1)) .* pixdim;
num = length(MSTRCT.start:MSTRCT.step:MSTRCT.stop);
for ncolumns = 1:20
    rows = ceil(num/ncolumns);
    horz = ncolumns*sz(2);
    vert = rows*sz(1);
    ratio(ncolumns) = horz/vert;
end
ncolumns = find(abs(ratio-Ratio0) == min(abs(ratio-Ratio0)),1);    
nrows = ceil(num/MSTRCT.ncolumns);
% if (ncolumns*nrows-num)/ncolumns < (1/3)
%     MSTRCT.ncolumns = ncolumns - 1;
% end
    
%---------------------------------------------
% Create Montage Matrix
%--------------------------------------------- 
sz = size(Image);
sz = [sz 1 1 1 1];
for n = 1:sz(4)
    for m = 1:sz(5)
        for p = 1:sz(6)
            [ImageOut(:,:,1,n,m,p),slcelab] = CreateMontageImageArray_v1b(Image(:,:,:,n,m,p),MSTRCT);
        end
    end
end

%---------------------------------------------
% Plot
%--------------------------------------------- 
INPUT.Image = ImageOut;
INPUT.MSTRCT = MSTRCT;
IMDISP = ImagingPlotSetup(INPUT);

%----------------------------------------------
% Return
%----------------------------------------------
MONT.Im = ImageOut;
MONT.MSTRCT = MSTRCT;
MONT.IMDISP = IMDISP;
MONT.CompassDisplay = 'Yes';

Status2('done','',2);
Status2('done','',3);
