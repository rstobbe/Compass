%===========================================
% 
%===========================================

function [PDGM,err] = FmriSlopeCorrect_v1b_Func(PDGM,INPUT)

Status2('busy','FMRI Slope',2);
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
%--
% Slope = [1.002064 -0.00010865];
% MeanTubes = 7.2357;
% Slope = [1.01177 -0.0006197];
% MeanTubes = 3.9812;
% Slope = [1.01565 -0.0008026];
% MeanTubes = 0.15476;
Slope = [1.0071290 -0.00036559];
MeanTubes = 0.1219693;
%--
RelChange = 1./(Slope(1)+(0:LenPdgm-1)*Slope(2));

Im = zeros(sz);
for n = 1:LenPdgm
    Im(:,:,:,n) = (IMG.Im(:,:,:,n)*RelChange(n))/MeanTubes;
end

% if strcmp(PDGM.Data,'Abs')
%     Im = abs(Im);
% else
%     Im = real(Im);
% end
% sz = size(Im);
% 
% 
% ImOut = NaN*ones(size(Im(:,:,:,1)));
% for n = 1:sz(1)
%     for m = 1:sz(2)
%         for p = 1:sz(3)
%             Dat = squeeze(Im(n,m,p,1:LenPdgm));
%             if abs(Dat(1)) < PDGM.MinSigVal
%                 continue
%             end
%             tSlope = [ones(LenPdgm,1) (0:LenPdgm-1).']\Dat;
%             [b,bint,r,rint,stats] = regress(Dat,[ones(LenPdgm,1) (0:LenPdgm-1).']);
%             if stats(3) > PDGM.Significance
%                 continue
%             end
%             ImOut(n,m,p) = tSlope(2);
%         end
%     end
%     Status2('busy',num2str(n),3);
% end

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
PDGM.FigureName = 'FMRI Subtraction';
PDGM.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

