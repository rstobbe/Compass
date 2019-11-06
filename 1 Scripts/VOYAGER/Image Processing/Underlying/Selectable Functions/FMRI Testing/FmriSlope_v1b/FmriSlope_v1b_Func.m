%===========================================
% 
%===========================================

function [PDGM,err] = FmriSlope_v1b_Func(PDGM,INPUT)

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
if strcmp(PDGM.Data,'Abs')
    Im = abs(IMG.Im);
else
    Im = real(IMG.Im);
end
sz = size(Im);
LenPdgm = sz(4);
%LenPdgm = sz(4)-1;

ImOut = NaN*ones(size(Im(:,:,:,1)));
for n = 1:sz(1)
    for m = 1:sz(2)
        for p = 1:sz(3)
            Dat = squeeze(Im(n,m,p,1:LenPdgm));
            if abs(Dat(1)) < PDGM.MinSigVal
                continue
            end
            tSlope = [ones(LenPdgm,1) (0:LenPdgm-1).']\Dat;
            [b,bint,r,rint,stats] = regress(Dat,[ones(LenPdgm,1) (0:LenPdgm-1).']);
            if stats(3) > PDGM.Significance
                continue
            end
            ImOut(n,m,p) = tSlope(2);
        end
    end
    Status2('busy',num2str(n),3);
end
IMG.Im = ImOut;

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

