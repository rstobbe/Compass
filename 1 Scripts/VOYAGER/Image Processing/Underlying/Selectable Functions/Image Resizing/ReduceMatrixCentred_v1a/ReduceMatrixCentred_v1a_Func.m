%===========================================
% 
%===========================================

function [RESZ,err] = ReduceMatrixCentred_v1a_Func(RESZ,INPUT)

Status2('busy','Reduce Matrix Size',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG;
Im = INPUT.IMG.Im;
ReconPars = INPUT.IMG.ReconPars;
clear INPUT;

%---------------------------------------------
% Get Input
%--------------------------------------------- 
inds = strfind(RESZ.newsize,',');
LR = str2double(RESZ.newsize(1:inds(1)-1));
TB = str2double(RESZ.newsize(inds(1)+1:inds(2)-1));
IO = str2double(RESZ.newsize(inds(2)+1:length(RESZ.newsize))); 
sz = size(Im);

%---------------------------------------------
% Reduce Matrix
%---------------------------------------------
if rem(sz(1),2) 
    error
end
if rem(TB,2)
    err.flag = 1;
    err.msg = 'Dimensions should be even';
    return
end
TBbot = (sz(1)-TB)/2+1;
TBtop = TBbot+TB-1;
LRbot = (sz(2)-LR)/2+1;
LRtop = LRbot+LR-1;
IObot = (sz(3)-IO)/2+1;
IOtop = IObot+IO-1;

ImNew = Im(TBbot:TBtop,LRbot:LRtop,IObot:IOtop); 
IMG.Im = ImNew;

%---------------------------------------------
% Update ReconPars
%---------------------------------------------
ReconPars.ImszTB = TB;
ReconPars.ImszLR = LR;
ReconPars.ImszIO = IO;
ReconPars.ImfovTB = ReconPars.ImszTB*ReconPars.ImvoxTB;
ReconPars.ImfovLR = ReconPars.ImszLR*ReconPars.ImvoxLR;
ReconPars.ImfovIO = ReconPars.ImszIO*ReconPars.ImvoxIO;
IMG.ReconPars = ReconPars;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',RESZ.method,'Output'};
RESZ.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
RESZ.FigureName = 'Reduced Matrix';
RESZ.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

