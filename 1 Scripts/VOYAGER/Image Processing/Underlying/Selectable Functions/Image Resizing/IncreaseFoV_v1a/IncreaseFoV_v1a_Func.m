%====================================================
%  
%====================================================

function [RSZ,err] = IncreaseFoV_v1a_Func(RSZ,INPUT)

Status2('busy','Increase FoV',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG{1};
MatDims = IMG.IMDISP.ImInfo.dims;
PixDims = IMG.IMDISP.ImInfo.pixdim;
IMDIM = IMG.IMDISP.IMDIM;
ReconPars = IMG.ReconPars;
clear INPUT;

%---------------------------------------------
% New
%---------------------------------------------
ind = strfind(RSZ.newfov,',');
NewFov(1) = str2double(RSZ.newfov(1:ind(1)-1));
NewFov(2) = str2double(RSZ.newfov(ind(1)+1:ind(2)-1));
NewFov(3) = str2double(RSZ.newfov(ind(2)+1:end));
ind = strfind(RSZ.matoffset,',');
MatOffset(1) = str2double(RSZ.matoffset(1:ind(1)-1));
MatOffset(2) = str2double(RSZ.matoffset(ind(1)+1:ind(2)-1));
MatOffset(3) = str2double(RSZ.matoffset(ind(2)+1:end));

%---------------------------------------------
% Increase
%---------------------------------------------
NewMatDims = 2*round(0.5*NewFov./PixDims);
Inc = NewMatDims-MatDims;

Im = zeros(NewMatDims);
bot = Inc/2;
top = NewMatDims - Inc/2 - 1;
Im(bot(1):top(1),bot(2):top(2),bot(3):top(3)) = IMG.Im;

%---------------------------------------------
% Shift
%---------------------------------------------
Im = circshift(Im,MatOffset);

%---------------------------------------------
% Update Info
%---------------------------------------------
NewFov = NewMatDims.*PixDims;
ReconPars.ImszTB = NewMatDims(1);
ReconPars.ImszLR = NewMatDims(2);
ReconPars.ImszIO = NewMatDims(3);
ReconPars.ImfovTB = NewFov(1);
ReconPars.ImfovLR = NewFov(2);
ReconPars.ImfovIO = NewFov(3);
IMG.ReconPars = ReconPars;
IMG.IMDISP.ImInfo.dims = NewMatDims;
IMG.IMDISP.IMDIM.y2 = NewMatDims(1);
IMG.IMDISP.IMDIM.x2 = NewMatDims(2);
IMG.IMDISP.IMDIM.z2 = NewMatDims(3);
IMG.IMDISP.SCALE.ymax = NewMatDims(1)+0.5;
IMG.IMDISP.SCALE.xmax = NewMatDims(2)+0.5;
IMG.IMDISP.SCALE.zmax = NewMatDims(3)+0.5;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',RSZ.method,'Output'};
RSZ.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = Im;
RSZ.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

