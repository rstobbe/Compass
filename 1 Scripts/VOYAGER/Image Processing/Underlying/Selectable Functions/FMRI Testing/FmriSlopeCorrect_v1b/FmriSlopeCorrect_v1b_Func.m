%===========================================
% 
%===========================================

function [PDGM,err] = FmriSlopeCorrect_v1b_Func(PDGM,INPUT)

Status2('busy','FMRI Slope Correct',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
clear INPUT;

%---------------------------------------------
% Test
%--------------------------------------------- 
sz = size(IMG.Im);
LenPdgm = sz(4);
Slope = [PDGM.RelOffset PDGM.RelSlope];
MeanTubes = PDGM.RefMean;
RelChange = 1./(Slope(1)+(0:LenPdgm-1)*Slope(2));

Im = zeros(sz);
for n = 1:LenPdgm
    Im(:,:,:,n) = (IMG.Im(:,:,:,n)*RelChange(n))/MeanTubes;
end
IMG.Im = Im;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',PDGM.method,'Output'};
PDGM.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
PDGM.FigureName = 'FMRI Slope Correct';
PDGM.IMG = IMG;

Status2('done','',2);
Status2('done','',3);
